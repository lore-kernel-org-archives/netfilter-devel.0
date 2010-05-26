From: Felipe W Damasio <felipewd@gmail.com>
Subject: Help: Cycle through iptables rules
Date: Tue, 25 May 2010 21:31:23 -0300
Message-ID: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57285 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600Ab0EZAbZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 May 2010 20:31:25 -0400
Received: by fxm5 with SMTP id 5so3848680fxm.19
        for <netfilter-devel@vger.kernel.org>; Tue, 25 May 2010 17:31:23 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  Hi,

  I'm using squid on an ISP as a webcache.

  We have a very high load cache (6000 users with 300Mbps of web
access), and to solve the squid slowdown, the solution is to use
multiple http_port, using around 48 squid instances to serve the
users.

  It works fine when I put the machine (which is in bridge mode)
between the users and the final router (which does the NAT from
reserved IP addresses to the real IPs). I separated the rules like
this:

iptables -t mangle -A PREROUTING -i eth0 -p tcp -s 192.168.1.0/24
--dport 80  -j TPROXY --tproxy-mark 0x1/0x1 --on-port 3127
iptables -t mangle -A PREROUTING -i eth0 -p tcp -s 192.168.2.0/24
--dport 80  -j TPROXY --tproxy-mark 0x1/0x1 --on-port 3128
...


  Everything works fine when we use this scenario.

  But now it was decided (and I can't reverse the decision) that the
webcache machine was to be located between the final Router and the
internet....in this case, the cache machine is now only seeing a few
IP addresses....so I can't do this "-s <network or ip>" trick.

  So I'd like to know if I can cycle through all these rules based on
the number of connections.

  Something like "Forward the first 100 connections to port 3127, the
next 100 to 3128 ....at the end, forward the next 100 to port 3127
again", and so on.

  Is it possible?

  If it isn't currently, can this functionality be added? How can I help?

  Thanks for your advice.

   Cheers,

Felipe Damasio
