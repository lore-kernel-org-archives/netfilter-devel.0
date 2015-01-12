From: Lennart Poettering <lennart@poettering.net>
Subject: xtables tools locking vulnerable to local DoS
Date: Mon, 12 Jan 2015 15:41:16 +0100
Message-ID: <20150112144115.GA25098@gardel-login>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:34238 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbbALOro (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:47:44 -0500
Received: from gardel-login.0pointer.net (gardel.0pointer.net [IPv6:2a01:238:43ed:c300:10c3:bcf3:3266:da74])
	by gardel.0pointer.net (Postfix) with ESMTP id B3A87E80CEB
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Jan 2015 15:41:16 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Heya,

I noticed that the iptables/xtables userspace tools implement a
locking scheme based on abstract namespace AF_UNIX sockets, in
xtables_lock() in iptables/xshared.c. This is vulnerable to local DoS,
since unprivileged clients can create that socket too, thus making all
iptables tools hang and hinder them from making changes to the
firewall. Abstract namespace AF_UNIX sockets are really not a suitable
locking primitive!

The code should probably be changed to use a file lock (BSD flock()
preferably) on a lock file in /run somewhere, with correct access
modes, so that unpriviliged users cannot play games with this.

Also, the sleep() loop around the AF_UNIX bind is pretty ugly anyway...

Lennart
