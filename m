From: Mistick Levi <gmistick@gmail.com>
Subject: libnetfilter_queue - remove packet from kernel buffer, and reinject
	later
Date: Tue, 19 Jan 2010 21:25:44 +0200
Message-ID: <6c279bde1001191125u28fa13a4i4fd7973cf950cccc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:37356 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab0ASTZq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2010 14:25:46 -0500
Received: by bwz19 with SMTP id 19so3121052bwz.28
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2010 11:25:44 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
I've worked with libipq, and libnetfilter_queue, and i got to a place
where my userspace code can't get anymore packets( with the message:
netlink message: no buffer space available ) .

Now what i want to do is this:
Read a packet from the queue, copy it to my own queue/location in my
program, and re injecting the packet later on with my verdict, after i
finished.

but to my best of my understanding, until i send a verdict the packet
still takes place in the queue.
and i've read something about using NF_STOLEN and then reinject, but i
dont think that NF_STOLEN is a valid verdict.

Any ideas on how i can do what it is i wish to do? ( Clear the kernel
queue by transferring the packets to my queue ).

Kind regards
Levi Yechiel
