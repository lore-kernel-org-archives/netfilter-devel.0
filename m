From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/5][IPTABLES]: libxt_CONNMARK revision 1
Date: Tue, 29 Jan 2008 14:19:35 +0100
Message-ID: <479F27E7.7040300@trash.net>
References: <Pine.LNX.4.64.0801242000350.12676@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801242002320.12676@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54788 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932614AbYA2Nfd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:35:33 -0500
In-Reply-To: <Pine.LNX.4.64.0801242002320.12676@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
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
> +"  OR-based operations:\n"
> +"  --set-mark value[/mask]       Set conntrack mark value\n"
> +"  --save-mark [--mask mask]     Save the packet nfmark in the connection\n"
> +"  --restore-mark [--mask mask]  Restore saved nfmark value\n"
> +"  Other operations:\n"
> +"  --and-mark value              Binary AND the ctmark with bits\n"
> +"  --or-mark value               Binary OR  the ctmark with bits\n"
> +"  --xor-mark value              Binary XOR the ctmark with bits\n"

I don't think users need to care how the operations are implemented,
so I removed the "XOR-based/OR-based/Other" lines.
