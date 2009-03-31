From: Haibin Wang <haibin123us@gmail.com>
Subject: stream-like interface by netfilter?
Date: Tue, 31 Mar 2009 15:03:07 -0700
Message-ID: <741894ea0903311503j1ac8aebbt3b2767d6e18173eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:17723 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759525AbZCaWDJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:03:09 -0400
Received: by yx-out-2324.google.com with SMTP id 31so2642349yxl.1
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2009 15:03:07 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Netfilter folks,

Some questions on netfilter interface in kernel space.

First, Does netfilter provide a stream-like interface in kernel space,
in addition to packets?
Second, if not, is there a way that netfilter provides packets of a
TCP connection in right order ( maybe also duplications free)?
Third, if so, what would be the best place to put in TCP reassembly
code to collect packets and present a stream-like interface? I used
NAT helper and CONNTRACK helper before, but not sure that is the right
place to fulfill such a function.

Essentially we are doing a project that requires inspecting contents
of TCP connections, our current approach requires patch to kernel
TCP/IP stack, which isn't that convenient to end users. So we want to
explore the idea whether we could do it using Netfilter. But so far I
haven't found such an interface from Netfilter documentation.

I did read another open source project Layer 7 Netfilter,
http://l7-filter.sourceforge.net/


, but since it also applies patch to the kernel, it isn't exactly what
we want, though a good place to start with.

Thanks for your attention.

Haibin
