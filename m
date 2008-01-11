From: Peter Warasin <peter@endian.com>
Subject: [PATCH 0/5] ulogd2 patches
Date: Fri, 11 Jan 2008 16:09:10 +0100
Message-ID: <20080111150910.582899000@andrew.endian.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:34009 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760548AbYAKQAR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jan 2008 11:00:17 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by solaria.endian.it (Postfix) with ESMTP id E910C59832E
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Jan 2008 16:28:37 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi guys

This patchset is against ulogd2 subversion repository.

The actual code in subversion did not work for me with the
following stack:
stack=log1:NFLOG,base1:BASE,ifi2:IFINDEX,print1:PRINTPKT,emu1:SYSLOG
stack=log2:ULOG,base2:BASE,print1:PRINTPKT,emu2:SYSLOG

The patch set fixes some problems after which ulogd2 works for me with
this plugin stack.


Patch #4 is a workaround of the following problem,
of which i am not quite sure is really no problem of
ulogd2, but i think so:

After every successful received packet coming from the ULOG
netlink, namely in the next iteration of ipulog_read() in
ulog_read_cb(), ipulog_read() returns -1 and thus logs an
error.
This happens because the recvfrom() within ipulog_netlink_recvfrom()
fails with EAGAIN, which in reality should'nt, since the
select() should only return when packets are present.

I think it is probably this kernel bug:
http://bugzilla.kernel.org/show_bug.cgi?id=5498

I'm not sure if it is really that bug, but i think so, because
libipulog had virtually no changes between ulogd1 and ulogd2
and ulogd1 does not have this problem. The only thing which
changed is that the netlink socket is now O_NONBLOCK, which
IMHO indicates that it must be that kernel bug.

Probably it is already solved with newer kernel versions.
I tested on 2.6.22.15

BTW: finally managed to set up quilt correctly, so these patches
should now be inline :)

kind regards,
Peter

--
