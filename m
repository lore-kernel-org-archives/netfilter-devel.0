From: Nishit Shah <nsshah.82@gmail.com>
Subject: TSO issue - "DNAT/mark based routing/MASQUEARDE on locally genrated
	traffic"
Date: Wed, 3 Jun 2009 14:25:49 +0530
Message-ID: <b2d58cb80906030155j2431b907yd0444c7ae372e064@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qy0-f104.google.com ([209.85.221.104]:39335 "EHLO
	mail-qy0-f104.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbZFCIzs convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:55:48 -0400
Received: by qyk2 with SMTP id 2so1675674qyk.33
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Jun 2009 01:55:50 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
                Whenever there is a output device change for locally
generated traffic due to,
                           DNAT/mark based routing in OUTPUT nat/mangle
                           MASQURADE in POSTROUTING nat
                 NETIF_F_TSO flag is not unset from sk->sk_route_caps.

So, there are chances that, output device returned at TCP/IP layer
routing supports NETIF_F_TSO  and changed output device due to
DNAT/mark based routing/MASQUERADE doesn=92t support NETIF_F_TSO.
In some of my experiments for some interfaces, I got =93NETDEV_WATCHDOG=
:
eth1 transmit timeout=94 messages and for some others packets doesn=92t=
 go
out of the box.
Currently I have disabled TSO on all interfaces through ethtool.

Is there any other way to solve this issue (something like resetting
the flag in route_me_harder() if device doesn=92t support TSO ) ?

Rgds,
Nishit Shah.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
