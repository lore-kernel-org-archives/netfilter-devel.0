From: Erik Schweigert <ejschweigert@gmail.com>
Subject: TCP Timeout Values
Date: Mon, 13 Sep 2010 13:01:07 -0700
Message-ID: <AANLkTik-DnT1rG5Y0YeJtK+42=gLBLaRAvCX2VU285te@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63270 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab0IMUBI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:01:08 -0400
Received: by gyd8 with SMTP id 8so2232532gyd.19
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Sep 2010 13:01:07 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I am wondering where the timeout values in

/net/netfilter/nf_conntrack_proto_tcp.c

of:

static unsigned int tcp_timeouts[TCP_CONNTRACK_MAX] __read_mostly = {
      [TCP_CONNTRACK_SYN_SENT]        = 2 MINS,
      [TCP_CONNTRACK_SYN_RECV]        = 60 SECS,
      [TCP_CONNTRACK_ESTABLISHED]     = 5 DAYS,
      [TCP_CONNTRACK_FIN_WAIT]        = 2 MINS,
      [TCP_CONNTRACK_CLOSE_WAIT]      = 60 SECS,
      [TCP_CONNTRACK_LAST_ACK]        = 30 SECS,
      [TCP_CONNTRACK_TIME_WAIT]       = 2 MINS,
      [TCP_CONNTRACK_CLOSE]           = 10 SECS,
 };

are decided?  Are these arbitrary or is this defined in the TCP RFC (I
could not see the TCP_CONNTRACK_ESTABLISHED value defined there).

Thanks,

Erik
