From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: build: resolve autotools suggestions
Date: Thu, 8 Jan 2009 00:49:39 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901080049060.29344@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0812252021300.17625@fbirervta.pbzchgretzou.qr> <495A05B0.8070700@netfilter.org> <alpine.LSU.2.00.0812301611070.5671@fbirervta.pbzchgretzou.qr> <4964B8F6.8080605@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55531 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbZAGXtl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:49:41 -0500
In-Reply-To: <4964B8F6.8080605@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-01-07 15:15, Pablo Neira Ayuso wrote:
>
>Applied. Thanks. Any other missing patch to apply to iptables from your
>side? I remember those to deprecate -b for iptables-save/restore but I
>prefer to add a warning before removing them as I suggested.

I really really doubt anyone ever used it -- since there was no code,
there was no effect.
