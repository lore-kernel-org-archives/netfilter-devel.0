From: Afi Gjermund <afigjermund@gmail.com>
Subject: nf_conntrack_count versus '/proc/net/nf_conntrack | wc -l' count
Date: Mon, 15 Feb 2010 09:27:29 -0800
Message-ID: <48ceaa831002150927q166b5955gfa0e1e465903d29d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f191.google.com ([209.85.216.191]:32906 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab0BOR1a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 12:27:30 -0500
Received: by pxi29 with SMTP id 29so1171416pxi.1
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Feb 2010 09:27:30 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I am running into an odd issue where the kernel begins to drop packets
because the connection tracking table is full. (I am running
2.6.26.5).

A 'cat /proc/sys/net/netfilter/nf_conntrack_count' says 4096.  But if
I do a 'cat /proc/net/nf_conntrack | wc -l' then it says 4.

A tail on /var/log/messages has:

Feb 15 16:45:33 titan user.warn kernel: __ratelimit: 20 messages suppressed
Feb 15 16:45:33 titan user.warn kernel: nf_conntrack: table full,
dropping packet.

I have an interface that allows me to do a 'nf_conntrack_flush' in
kernel, but that seems to only clear the table of
/proc/net/nf_conntrack and not the count the kernel has.

I need a way to ensure that at say 95% there is a way to clear the
"actual" table as well as the count...whichever that may be.  There
seems to be a disconnect between the implementation versus my
understanding of how the system is working. Any help is appreciated.

Afi
