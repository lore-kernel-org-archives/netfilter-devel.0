From: Justin Yaple <yaplej@gmail.com>
Subject: Access source MAC address in userspace?
Date: Sun, 11 Apr 2010 19:14:17 -0700
Message-ID: <g2l8363055a1004111914w8399e046ye0fe1b7ef748d9a8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f171.google.com ([209.85.210.171]:53133 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab0DLCOS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Apr 2010 22:14:18 -0400
Received: by yxe1 with SMTP id 1so2312325yxe.33
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Apr 2010 19:14:17 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I am redirecting traffic from multiple routers to my host using policy
based routing so I can run all the traffic through my application.
The packets are queued to userspace so my application has access to
them.

I would like to return the packet back to the original router that
redirected it.  I would need to replace the destination MAC with the
original source MAC, and then return the packet to the kernel.  I
think that the kernel will probably do some route lookup, and change
those fields.  So is there any way to avoid having the destination MAC
changed back to the MAC of the default gateway or whatever the MAC of
the next-hop might be?

Maybe I could save the IP address of the orignal router that
redirected the traffic, and set the next-hop on the packet then just
return it to the kernel.  Not sure if source routing is supported or
not.  Just trying to figure out some possible ways to do this.

Thanks.
