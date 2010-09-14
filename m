From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: TCP Timeout Values
Date: Tue, 14 Sep 2010 11:59:07 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1009141158000.6873@obet.zrqbmnf.qr>
References: <AANLkTik-DnT1rG5Y0YeJtK+42=gLBLaRAvCX2VU285te@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Erik Schweigert <ejschweigert@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:60747 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab0INJ7J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Sep 2010 05:59:09 -0400
In-Reply-To: <AANLkTik-DnT1rG5Y0YeJtK+42=gLBLaRAvCX2VU285te@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-09-13 22:01, Erik Schweigert wrote:

>Hi all,
>
>I am wondering where the timeout values in
>
>/net/netfilter/nf_conntrack_proto_tcp.c
>
>of:
>
>static unsigned int tcp_timeouts[TCP_CONNTRACK_MAX] __read_mostly = {
>      [TCP_CONNTRACK_SYN_SENT]        = 2 MINS,
>      [TCP_CONNTRACK_SYN_RECV]        = 60 SECS,
>      [TCP_CONNTRACK_ESTABLISHED]     = 5 DAYS,
>      [TCP_CONNTRACK_FIN_WAIT]        = 2 MINS,
>      [TCP_CONNTRACK_CLOSE_WAIT]      = 60 SECS,
>      [TCP_CONNTRACK_LAST_ACK]        = 30 SECS,
>      [TCP_CONNTRACK_TIME_WAIT]       = 2 MINS,
>      [TCP_CONNTRACK_CLOSE]           = 10 SECS,
> };
>
>are decided?  Are these arbitrary or is this defined in the TCP RFC (I
>could not see the TCP_CONNTRACK_ESTABLISHED value defined there).

In the TCP RFC. Of course you won't find TCP_CONNTRACK_ESTABLISHED in 
there, it's a TCP RFC. Not a conntrack RFC.

"""the TCP must keep quiet for a maximum segment lifetime (MSL) before 
assigning any sequence numbers upon starting up or recovering from a 
crash in which memory of sequence numbers in use was lost.  For this 
specification the MSL is taken to be 2 minutes."""
