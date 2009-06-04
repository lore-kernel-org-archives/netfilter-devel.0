From: Nishit Shah <nsshah.82@gmail.com>
Subject: TSO issue - DNAT/mark based routing/MASQUEARDE on locally genrated
	traffic
Date: Thu, 4 Jun 2009 20:01:18 +0530
Message-ID: <b2d58cb80906040731oce8cc42k8dd42f1f396fc16f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qy0-f200.google.com ([209.85.221.200]:52275 "EHLO
	mail-qy0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZFDOiM convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:38:12 -0400
Received: by qyk38 with SMTP id 38so189792qyk.33
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Jun 2009 07:38:13 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
=A0 =A0 =A0 =A0Whenever there is a output device change for locally
generated traffic due to,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DNAT/mark based routing in OUTPUT n=
at/mangle
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MASQURADE in POSTROUTING nat
=A0 =A0 =A0 =A0 NETIF_F_TSO flag is not unset from sk->sk_route_caps.

        So, there are chances that, output device returned at TCP/IP la=
yer
routing supports NETIF_F_TSO =A0and changed output device due to
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
