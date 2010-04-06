From: K-Gen <alphakgen@gmail.com>
Subject: Prerouting hook doesn't "see" all packets
Date: Wed, 7 Apr 2010 01:10:56 +0200
Message-ID: <y2yefcd93941004061610n9f6b0a90lec0209b794d5bc14@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.211.172]:41363 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512Ab0DFXK5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Apr 2010 19:10:57 -0400
Received: by ywh2 with SMTP id 2so216344ywh.33
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Apr 2010 16:10:56 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi there.
I'm trying to see TCP packets passing through a router using a
netfilter module (in order to eventually alter them).

I have a hook on PREROUTING, and it doesn't quite work as expected.
The only packets I see, are the TCP handshake (3 packets). Any packets
in an established connection do not get to my hook.
The TCP connections in question all pass via NAT before reaching my
hook. I've thus given my hook the priority NF_IP_PRI_LAST.
I've tried setting nfcache to NFC_UNKNOWN for every TCP packet, and
this didn't help.

The kernel version on the router is 2.6.8.1, the router itself is
based on a BCM board. I did not try to the same on another machine.

My goal is to be able to see ALL the TCP packets in my hook. I do not
want any caching/optimizations to take place.

I'm obviously doing something wrong, so please tell my why is this happening.

Thanks,
Greg.
