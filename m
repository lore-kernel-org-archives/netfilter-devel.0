From: Patrick McHardy <kaber@trash.net>
Subject: Re: [07/19] libxt_CONNMARK r1
Date: Sun, 20 Jan 2008 14:27:48 +0100
Message-ID: <47934C54.9080700@trash.net>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801161450030.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57924 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbYATN2s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:28:48 -0500
In-Reply-To: <Pine.LNX.4.64.0801161450030.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Add support for xt_CONNMARK target revision 1.
> 
> +static void connmark_tg_help(void)
> +{
> +	printf(
> +"CONNMARK target options:\n"
> +"  XOR-based operations:\n"
> +"  --set-xmark value[/ctmask]    Zero mask bits and XOR ctmark with value\n"
> +"  --save-mark [--ctmask mask] [--nfmask mask]\n"
> +"                                Copy ctmark to nfmark using masks\n"
> +"  --restore-mark [--ctmask mask] [--nfmask mask]\n"
> +"                                Copy nfmark to ctmark using masks\n"
> +"  --and-mark bits\n"
> +"  --or-mark bits\n"
> +"  --xor-mark bits\n"
> +"  OR-based operations (deprecated):\n"
> +"  --set-mark value[/mask]       Set conntrack mark value\n"
> +"  --save-mark [--mask mask]     Save the packet nfmark in the connection\n"
> +"  --restore-mark [--mask mask]  Restore saved nfmark value\n"
> +);
> +}

This confuses me - why are --set-mark and --restore-mark deprecated?
I also want to keep --set-mark. Why not simply keep all the options
named like before?

