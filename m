From: Pavel Vajarov <pavel@x3me.net>
Subject: NFQUEUE and TRPOXY
Date: Thu, 25 May 2017 14:51:49 +0300
Message-ID: <CAJEV1ihZ7UC7BQnz66gfT-+Tm3c+bcSmmAJEzBX3oFx-j5LYpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:32843 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936230AbdEYLvu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 May 2017 07:51:50 -0400
Received: by mail-oi0-f41.google.com with SMTP id w10so277345735oif.0
        for <netfilter-devel@vger.kernel.org>; Thu, 25 May 2017 04:51:49 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Let me first say our usage scenario of the above two targets.
We have a proxy working in transparent mode. We would like the proxy
to not accept a connection from the client if it can't connect to the
origin. This way it can become even more transparent.

So we decided to try the NFQUEUE target and send the incoming SYN
packets to the user space application. The application there tries to
connect to the origin and if it succeeds it issues NF_ACCEPT. If it
can't connect in a few seconds to the origin it issues NF_DROP.

Here are the related iptables-rules in the mangle table:
-A PREROUTING -i eth0 -p tcp -m tcp --dport 80 -j TPROXY --on-port
8081 --on-ip 127.0.0.1 --tproxy-mark 0x1/0x1
-A INPUT -i eth0 -p tcp -m tcp --dport 80 --tcp-flags FIN,SYN,RST,ACK
SYN -j NFQUEUE --queue-num 0

The user space application correctly receives the SYN packets and
connects to the origin. The problem is that when it issues the
NF_ACCEPT verdict nothing seems to happen. I mean that the application
doesn't receive any connect request.
 I think that the connected tproxy socket, bound to the client ip:port
and connected to the origin ip:port, somehow breaks the things. If I
change the bind port of this socket to some different number
everything works correctly and the application receives connect
request on it's listener socket.

Saw in the source code of the xt_TPROXY that it just assign a
different socket, in my case the listener socket, to the incoming
skbuff. I suppose that somehow instead of the assigned socket the
newly connected is used inside the network stack, but couldn't find
how this can happen. Tried to trace the logic through the
net/ipv4/ip_input.c, net/ipv4/tcp_v4.c and net/ipv4/tcp_input.c, but
still can't find how this happens.

I'll really appreciate if somebody can give me some piece of advice
about this case.

Thanks,
Pavel.
