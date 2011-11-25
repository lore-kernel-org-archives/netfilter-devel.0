From: marty <martinbarrowcliff@gmail.com>
Subject: latency increased X 10 on update
Date: Fri, 25 Nov 2011 16:45:54 -0500
Message-ID: <4ED00C92.9030701@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38335 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab1KYVqA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Nov 2011 16:46:00 -0500
Received: by vbbfc26 with SMTP id fc26so2479787vbb.19
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Nov 2011 13:45:59 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Using ipset-6.9.1 on Linux-3.1.1
Only managing ipv4 traffic on Intel Atom-330 firewall.

Same iptables rules, however after updating from v4 code I see issues.
Attacker sends a packet;
I detect a unserved dest port and --add-set Blah src;
LOG it, DROP it, and begone;
But the set may not match for several further packets.
Ouch. Buffers?

Blah is used as
iptables -t raw -I PREROUTING  --match-set Blah src-j DROP
This DROP is NEVER logged, but certainly counted.

However I often continue to log multiple packets from blocked hosts, 
despite I am supposedly blocking them on the first bad packet.
I can confirm they are in the set but when packet_count exceeds 1 
something is very wrong with that picture.


Marty B.
