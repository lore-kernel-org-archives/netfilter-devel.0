From: Hamid Nassiby <h.nassiby@gmail.com>
Subject: Packet manipulation in user space, drop/reinject modified packets
Date: Fri, 9 Apr 2010 21:23:21 +0430
Message-ID: <r2tb3f13ff81004090953v4a7eeea7k9072c0e777292407@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:44172 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab0DIQxn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Apr 2010 12:53:43 -0400
Received: by fxm23 with SMTP id 23so2972279fxm.21
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Apr 2010 09:53:41 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I'm working on a project which wants to port a Windows-based network
protocol to Linux. The protocol works as a VPN/Firewall, on packets
copied from Data-Link Layer to user space. In MS Windows
WinpkFilter(C) does copying from kernel space (Data-Link layer)  to
user space and then drops the original packet. In user space, our
protocol does some operation on packet ( e.g. checks  the packet
authority and/or encrypts/decrypts it, ...) and then injects the
packet upward to application layer or downward or simply drops it. The injected
modified packet may not be as the same size of original one.

So our requirements are:

1-Capture each packet which is coming inside or going outside the
computer in Data-link Layer.
2-Create a copy of the packet and drop the original one.
3-Copy of packet must be available in user space to be manipulated by
our protocol.
4-After manipulation in user space, inject encrypted/decrypted version
of the privileged (copy of) packets to the network or upward to the
application layer.

And of course we want to have the minimum changes to be made on our
current protocol.

I tried raw sockets and libnetfilter_queue  , but I didn't find a
suitable solution (specially to let me inject packets upward
to the application layer.)
I need to know if it is possible to do this with libraries/interfaces currently
available in user space or should I write a kernel module to do the
above tasks for us?

It is possible that I be overall in a mistake, so any guidance is pleased,

Thanks in advance,

Hamid.
