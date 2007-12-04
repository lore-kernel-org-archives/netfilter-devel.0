From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [rfc] using xor in mark targets
Date: Tue, 4 Dec 2007 11:52:07 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712041145420.10859@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711292335090.3089@fbirervta.pbzchgretzou.qr>
 <474F4AD4.5030502@trash.net> <Pine.LNX.4.64.0711300120310.3089@fbirervta.pbzchgretzou.qr>
 <47541C45.3090804@trash.net> <Pine.LNX.4.64.0712031832430.11746@fbirervta.pbzchgretzou.qr>
 <47550BC3.9080404@trash.net> <Pine.LNX.4.64.0712040951310.11746@fbirervta.pbzchgretzou.qr>
 <47551B3A.7090100@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46027 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbXLDKwJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 05:52:09 -0500
In-Reply-To: <47551B3A.7090100@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 4 2007 10:17, Patrick McHardy wrote:
>
> I still don't see why you can't keep --set-mark and add new options
> --and-mark, --xor-mark, ...
>

	-j CONNMARK --xor-mark 0x01
	-j CONNMARK --and-mark 0xffffffdf
	-j CONNMARK --or-mark 0x400

I would prefer the single invocation:

	-j CONNMARK --set-xmark 0x401/0xfffffbdf
