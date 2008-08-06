From: synapse@hippy.csoma.elte.hu
Subject: conntrack -L shows an entry, conntrack -G doesn't
Date: Wed, 6 Aug 2008 17:01:51 +0200 (CEST)
Message-ID: <55990.80.98.202.103.1218034911.squirrel@hippy.csoma.elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:46263 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588AbYHFPB6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:01:58 -0400
Received: from csomalin.csoma.elte.hu ([157.181.103.194])
	by mx2.mail.elte.hu with esmtp (Exim)
	id 1KQkWM-0003pI-UD
	from <synapse@hippy.csoma.elte.hu>
	for <netfilter-devel@vger.kernel.org>; Wed, 06 Aug 2008 17:01:57 +0200
Received: from localhost (localhost [127.0.0.1])
	by csomalin.csoma.elte.hu (Postfix) with ESMTP id 8FD8F82DBE7
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Aug 2008 17:01:50 +0200 (CEST)
Received: from csomalin.csoma.elte.hu ([127.0.0.1])
	by localhost (csomalin.csoma.elte.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I5Eai55GGEpu for <netfilter-devel@vger.kernel.org>;
	Wed,  6 Aug 2008 17:01:50 +0200 (CEST)
Received: from hippy.csoma.elte.hu (hippy.csoma.elte.hu [157.181.103.200])
	by csomalin.csoma.elte.hu (Postfix) with ESMTP id E95BC824CBD
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Aug 2008 17:01:49 +0200 (CEST)
Received: from hippy.csoma.elte.hu (localhost [127.0.0.1])
	by hippy.csoma.elte.hu (Postfix) with ESMTP id E0FFCA4114
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Aug 2008 17:01:51 +0200 (CEST)
References: 
In-Reply-To: 
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello

I have a machine which redirects all connections going out to any tcp 22
port to
localhost tcp port 12345.

My little daemon that listens on port 12345 gives me this info:

    Connection accepted peer ip: 192.168.13.12, peer port: 49939, host ip:
192.168.13.12, host port:12345

cat /proc/net/conntrack
Shows the connection, and also does conntrack -L. However the same command
with -G
returns with an error:

root@test:~# conntrack -L -s 192.168.13.12 -q 192.168.13.12 -p tcp
--orig-port-src
49939 --reply-port-src 12345
    tcp      6 431950 ESTABLISHED src=192.168.13.12 dst=217.20.131.2
sport=49939
dport=22 packets=2 bytes=112 src=127.0.0.1
    dst=192.168.13.12     sport=12345 dport=49939 packets=1 bytes=60
[ASSURED]
mark=0 use=1

root@test:~# conntrack -G -s 192.168.13.12 -q 192.168.13.12 -p tcp
--orig-port-src
49939 --reply-port-src 12345
    Operation failed: such conntrack doesn't exist

The redirection is done as:

    iptables -t nat -F
    iptables -t nat -X
    iptables -t nat -Z

    iptables -t nat -A OUTPUT -p tcp --destination-port 22 -j REDIRECT
--to-ports 1234

I am using the latest ubuntu btw (upgraded fully), with versions:
    conntrack                           1.00~beta2-1
    libnetfilter-conntrack-dev          0.0.81-1
    libnetfilter-conntrack1             0.0.81-1

Basically I am clueless here as to why -L shows the connection and -G
doesn't. My
goal is to
transparently proxy outgoing connections through my program. Therefore I
need to detect
what its' original destination would be from the information seen by the
program on
12345.

My questions:
 - Is that even possible? Please say yes :)
 - Am I doing something wrong?
 - Is it a bug?

I'm contacting you, since user "jengelh" on the #netfilter channel
(freenode) told
me that
this is probably a bug.

Thanks in advance:

Kalman Gergely






