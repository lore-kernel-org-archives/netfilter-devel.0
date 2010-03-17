From: Dominik Kaspar <dokaspar.ietf@gmail.com>
Subject: RAWDNAT and disappearing packets
Date: Wed, 17 Mar 2010 10:40:52 +0100
Message-ID: <2a3692de1003170240k1b5b4e88k6f447d8fd3cb213@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:60633 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab0CQJky (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 05:40:54 -0400
Received: by bwz1 with SMTP id 1so802316bwz.1
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2010 02:40:53 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have a question about why packets are disappearing in my setup. My
machine has two L2TP tunnels (10.6.1.2 and 10.6.1.3) to a Web server
(10.6.1.1). The local machine uses a command such as "wget
http://10.6.1.1/file --bind-address 10.6.1.2" to request a file from
the server. On the server, outgoing packets are rewritten to 10.6.1.3,
so that they travel back through the other tunnel. That works fine.

At the client, I am using the RAWDNAT target to translate the address
of incoming packets destined for 10.6.1.3 to be locally translated
back to 10.6.1.2. This is the rule I use:

iptables -t raw -A PREROUTING -p tcp --sport 80 -d 10.6.1.3 -j RAWDNAT
--to-destination 10.6.1.2

I added a LOG rule before and after RAWDNAT to verify that the
destination is changed to 10.6.1.2. Everything in PREROUTING works.
According to the netfilter flow chart, a packet then travels into
"conntrack" and then into MANGLE PREROUTING, where I can still log the
packet (that is now going to 10.6.1.2 instead of 10.6.1.3).

However, then it somehow disappears! I cannot find the packet in NAT
PREROUTING and also not in any INPUT or FORWARD tables after the
routing decision point. What happened? What made the packet suddenly
disappear? Is there something going on that causes the packets to be
dropped?

Best regards,
Dominik
