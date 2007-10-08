From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] TCPOPTSTRIP 20071006 (iptables)
Date: Mon, 08 Oct 2007 10:22:07 +0200
Message-ID: <4709E8AF.1020501@trash.net>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de> <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr> <46FD1798.2020302@trash.net> <87tzpd266j.fsf@begreifnix.intranet.astaro.de> <87hcl91ubt.fsf@begreifnix.intranet.astaro.de> <87abr11tth.fsf@begreifnix.intranet.astaro.de> <Pine.LNX.4.64.0710021656510.7130@fbirervta.pbzchgretzou.qr> <874ph4bafm.fsf@apollo.sven.bitebene.org> <Pine.LNX.4.64.0710061630310.5969@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0710061700360.5969@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Sven Schnelle <svens@bitebene.org>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55614 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbXJHIYa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2007 04:24:30 -0400
In-Reply-To: <Pine.LNX.4.64.0710061700360.5969@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> Adds libxt_TCPOPTSTRIP.


I'll wait with applying this until we've released the next
iptables version, I don't want to get back into releasing
extensions for unreleased targets.
