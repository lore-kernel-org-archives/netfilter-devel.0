From: "Gurpreet Kaur" <G.Kaur@globallogic.com>
Subject: iptables hashlimit behaviour
Date: Wed, 22 Dec 2010 12:44:22 +0530
Message-ID: <C6BC71B0FE52F34DB131AA6993A023F60114F125@ex2-del1.synapse.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx-del1-1.globallogic.com ([202.174.92.25]:55017 "EHLO
	emailsecurity-del1-1.globallogic.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522Ab0LVHf3 convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Dec 2010 02:35:29 -0500
Received: from emailsecurity-del1-1.globallogic.com (127.0.0.1) by emailsecurity-del1-1.globallogic.com (MlfMTA v3.2r9) id h26ktc0171sb for <netfilter-devel@vger.kernel.org>; Wed, 22 Dec 2010 12:42:36 +0530 (envelope-from <G.Kaur@globallogic.com>)
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am new to iptables and currently working on hashlimit option.
Recently, I found a behaviour of iptables which is quite strange. When I
issue the following command :

iptables -A I_UDP_def_realm_4000 -m hashlimit --hashlimit-upto 6000
--hashlimit-burst 40 --hashlimit-mode srcip --hashlimit-name test -j
I_SYS_RATELIMIT_CHAIN

it take limit as 10000/s instead of 6000/s and this behaviour is for any
value greater than 5000. 

Also I have some observations like if I give 2000/s or 2500/s, it takes
the value as such but if I give 3000/s, it takes the value as 3333/s.
And any value above it, it takes it as 5000/s.

Please explain why iptables is behaving like this. Is it in algorithm
and the purpose for the same.

Thanks,
Gurpreet
