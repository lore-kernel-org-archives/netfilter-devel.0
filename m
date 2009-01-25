From: ilninno <ilninno@gmail.com>
Subject: Connection pid
Date: Mon, 26 Jan 2009 00:32:19 +0100
Message-ID: <92770c820901251532v6e0f12a0w891ddbd0e2337680@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.180]:59922 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbZAYXcV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Jan 2009 18:32:21 -0500
Received: by el-out-1112.google.com with SMTP id b25so988824elf.1
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Jan 2009 15:32:19 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello again!

I have some problems with libnetfilter_queue, I need connections pid.
My program captures outgoings connections(only new connections)

1- I tried with netstat but its too low.  (each netstat call changes
process context)
2- I tried with netstat code, but its too low because all the info is
in different files. The first problem is get connection inode
(/proc/net/tcp or /proc/net/udp), with inode then i must search in fd
(inodes) of each process (/proc/pid/fd/). This is too low, Im not
using cache because i only capture new connections.

There is any reference to process id or process name in struct
nfq_data *pkt or similar struct?


Thanks for your time and sorry for my english.
