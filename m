From: Gerardo Herzig <gherzig@fmed.uba.ar>
Subject: ssh conection limit not working
Date: Fri, 25 Jul 2008 11:24:22 -0300
Message-ID: <4889E216.6030600@fmed.uba.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.fmed.uba.ar ([157.92.152.1]:51616 "EHLO mail.fmed.uba.ar"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884AbYGYPIR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2008 11:08:17 -0400
Received: from [157.92.155.58] (mailbis [157.92.155.58])
	by mail.fmed.uba.ar (Postfix) with ESMTP id 2ABFF1F605E
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Jul 2008 11:34:57 -0300 (ART)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all. Im trying to use the limit module for ssh conections. After this
rule, i cant do ssh not even once.

iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m limit -limit
5/min -j ACCEPT

iptables -A INPUT -p tcp --dport 22 -j DROP

(Not other rulez in any chain.)
iptables -L -v
Chain INPUT (policy ACCEPT 22 packets, 2784 bytes)
 pkts bytes target     prot opt in     out     source    destination
    0     0 ACCEPT     tcp  --  any    any     anywhere  anywhere
     tcp dpt:22 state NEW limit: avg 5/min burst 5
    0     0 DROP       tcp  --  any    any     anywhere
anywhere            tcp dpt:22

(after triyng a `ssh localhost' with no luck)
Chain INPUT (policy ACCEPT 1041 packets, 120K bytes)
 pkts bytes target     prot opt in     out     source  destination
    1    60 ACCEPT     tcp  --  any    any     anywhere
anywhere            tcp dpt:22 state NEW limit: avg 5/min burst 5
    7   400 DROP       tcp  --  any    any     anywhere anywhere  tcp dpt:22

I can see the package is being dropped. Crap.
Any hints?

iptables v1.3.8
uname -r
2.6.22.5-31-default

Thanks!

Gerardo
