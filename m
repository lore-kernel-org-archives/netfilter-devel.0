From: NuSkooler <nuskooler@gmail.com>
Subject: Custom Module for Userspace Proxy
Date: Tue, 25 Nov 2014 14:35:58 -0700
Message-ID: <CAPnjhY-p_EjCJQXzXeQ0Yk29o0vRZ7a5rqzuqbO86uNa_gSywA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:47920 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaKYVf6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:35:58 -0500
Received: by mail-qc0-f179.google.com with SMTP id c9so1140941qcz.24
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Nov 2014 13:35:58 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello all --

I have been handed a kernel module who's purpose is to redirect all
TCP/IP traffic to a localhost proxy for inspection/modification. This
module works on various Linux system and (our target) Android up to
version 5.0 (Lollipop).

The way the module works is a bit of a hack (I believe): A new
protocol is registered by copying IPv4's and replacing a few
functions. Packets are marked with a magic # using SKB's 'mark' member
as to prevent a proxy loop. At least one problem is that as of Android
5.0, the 'mark' member is being used for other purposes by the system.
Another issue is I need to add IPv6 support and the symbols are not
exported/available to just port over the protocol hack described
above.

Before anyone asks: The reason a new module is used instead of just
using IPTables rules is mostly so we can send up additional metadata
to userspace about connections (PID, process path, etc.)

This brings me to my real question: What is the proper way (where to
hook into/etc.) to go about achieving this for IPv4 and IPv6 TCP/IP?
TL;DR, I need to:
1) Redirect new connections to a localhost proxy
2) Send additional metadata about said connections to userspace (PID,
etc.). Currently this is done via the protocol hack and using
getsockop/setsockopt() for IPC and tuple lookups.

Another way to possibly describe what I'm attempting to achieve: The
way this is written for the Windows platform is via a WFP Connection
Redirection driver and IOCTL's for the IPC.

Hopefully that's described well enough. Any pointers appreciated!
