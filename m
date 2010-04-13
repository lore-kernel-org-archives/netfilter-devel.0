From: Justin Yaple <yaplej@gmail.com>
Subject: Can the next-hop be set on queued packets?
Date: Mon, 12 Apr 2010 22:05:14 -0700
Message-ID: <x2z8363055a1004122205j71febec3sb9ba5c1bc4f21177@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39729 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab0DMFFQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 01:05:16 -0400
Received: by gwaa18 with SMTP id a18so388266gwa.19
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Apr 2010 22:05:15 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I was just wondering if the next-hop router can be set on packets that
were queued to userspace before they are returned to the kernel?  I
have a module that when loaded redirects specific traffic to the queue
where my service processes them.  I am trying to lookup the IP of the
original source MAC, and then source route the traffic back to that
device, but I am not sure if its even possible with libnetfilter_queue
currently.

Thanks.
