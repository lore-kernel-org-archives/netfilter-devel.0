From: Aviad Lahav <aviad.lahav@gmail.com>
Subject: Netfilter injects network headers
Date: Wed, 9 Dec 2009 18:50:32 +0200
Message-ID: <85ce6a220912090850n2bc9827sfd90a82e7be6b587@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:41456 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbZLIQub (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Dec 2009 11:50:31 -0500
Received: by ewy1 with SMTP id 1so4491308ewy.28
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Dec 2009 08:50:35 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,
I've posted this to the netfilter-users but got no response, hope I
can get more help here.


I'm trying to set up an SSL transparent proxy, and I've seen very
bizarre behavior on my system.
I've added two NAT rules to  the PREROUTING chain, looking like this:

# iptables -L -v -t nat
Chain PREROUTING (policy ACCEPT 561 packets, 70236 bytes)
 pkts bytes target     prot opt in     out     source               destination
   20  1280 REDIRECT   tcp  --  ppp0   any     anywhere
anywhere            tcp dpt:4309 redir ports 4443
    8   512 REDIRECT   tcp  --  ppp0   any     anywhere
anywhere            tcp dpt:https redir ports 4443

So I've got a listener on port 4443, accepting connections from both
ports 443 and 4309.
When I'm doing the first recv() in my accepting server, I get the
incoming connections to port 443 very well, BUT:
Incoming connections to port 4309 gets *3 extra bytes* in the
beginning of the connection (maybe also to subsequent packets, but I
haven't had the chance to see this data yet...()

The first 3 bytes I'm getting is:
0x00 0x01 0x05

My machine is an up-to-date Ubuntu 9.10 (karmic), and the packets are
coming from a client connected thru pptpd.
Anyone has a clue?
