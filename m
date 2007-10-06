From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC] TCPOPTSTRIP target (iptables)
Date: Sat, 6 Oct 2007 16:33:58 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710061630310.5969@fbirervta.pbzchgretzou.qr>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
 <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
 <46FD1798.2020302@trash.net> <87tzpd266j.fsf@begreifnix.intranet.astaro.de>
 <87hcl91ubt.fsf@begreifnix.intranet.astaro.de> <87abr11tth.fsf@begreifnix.intranet.astaro.de>
 <Pine.LNX.4.64.0710021656510.7130@fbirervta.pbzchgretzou.qr>
 <874ph4bafm.fsf@apollo.sven.bitebene.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Sven Schnelle <svens@bitebene.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34733 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbXJFOd7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Oct 2007 10:33:59 -0400
In-Reply-To: <874ph4bafm.fsf@apollo.sven.bitebene.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 6 2007 16:10, Sven Schnelle wrote:
>
>Thanks. I've added only a few options, so this list may still be
>extensible ;-)

Well, with md5, it is complete for now. I have gone through net/tcp.h, which is
how I even found TCPOPT_MD5 (though, I knew of the existence of MD5 signatures
for network streams beforehand).

>I've changed the code in the meantime so that names could be specified
>inside the --strip-options argument list, instead of having extra
>options for every tcp option, this makes code smaller, and it is even
>simpler to add new names.

Very good.

>  pkts bytes target     prot opt in     out     source               destination         
>  0     0 TCPOPTSTRIP  tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           tcp flags:0x17/0x02 TCPOPTSTRIP options wscale,77

I added support for numeric printing (e.g. iptables -nvL),
so that it shows 3,77 (as requested by -n) instead of wscale,77,
making it behave like the other iptables modules like xt_tcpudp.

I have chosen to always use numeric output for tcpoptstrip_save,
_unlike_ xt_tcpudp, which always uses symbolic names.

Patches following.
