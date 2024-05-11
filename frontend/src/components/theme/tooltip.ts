import { defineStyleConfig } from '@chakra-ui/react'
import { cssVar } from '@chakra-ui/react'

const $arrowBg = cssVar('popper-arrow-bg')

const baseStyle = {
  borderRadius: 'md',
  fontWeight: 'normal',
  background: 'gray.700',
  color: 'gray.100',
  [$arrowBg.variable]: 'gray.700',
}

export const tooltipTheme = defineStyleConfig({ baseStyle })
