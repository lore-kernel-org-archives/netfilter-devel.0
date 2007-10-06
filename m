From: Sven Schnelle <svens@bitebene.org>
Subject: Re: [RFC] TCPOPTSTRIP target (iptables)
Date: Sat, 06 Oct 2007 16:53:54 +0200
Message-ID: <87y7eg9tvh.fsf@apollo.sven.bitebene.org>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
	<Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
	<46FD1798.2020302@trash.net>
	<87tzpd266j.fsf@begreifnix.intranet.astaro.de>
	<87hcl91ubt.fsf@begreifnix.intranet.astaro.de>
	<87abr11tth.fsf@begreifnix.intranet.astaro.de>
	<Pine.LNX.4.64.0710021656510.7130@fbirervta.pbzchgretzou.qr>
	<874ph4bafm.fsf@apollo.sven.bitebene.org>
	<Pine.LNX.4.64.0710061630310.5969@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from woomax.duncanthrax.net ([195.2.162.46]:57275 "EHLO
	woomax.duncanthrax.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197AbXJFOx4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Oct 2007 10:53:56 -0400
In-Reply-To: <Pine.LNX.4.64.0710061630310.5969@fbirervta.pbzchgretzou.qr> (Jan Engelhardt's message of "Sat\, 6 Oct 2007 16\:33\:58 +0200 \(CEST\)")
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> writes:

> On Oct 6 2007 16:10, Sven Schnelle wrote:
>>  pkts bytes target     prot opt in     out     source               destination         
>>  0     0 TCPOPTSTRIP  tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           tcp flags:0x17/0x02 TCPOPTSTRIP options wscale,77
>
> I added support for numeric printing (e.g. iptables -nvL),
> so that it shows 3,77 (as requested by -n) instead of wscale,77,
> making it behave like the other iptables modules like xt_tcpudp.

Hehe, even though i'm almost always using iptables -nvL, i've missed
that one. Thanks again. :)

> I have chosen to always use numeric output for tcpoptstrip_save,
> _unlike_ xt_tcpudp, which always uses symbolic names.

That's fine with me.
