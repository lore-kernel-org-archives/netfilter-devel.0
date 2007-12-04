From: "Damian Hites" <nizebulous@gmail.com>
Subject: netfilter_queue doesn't seem to be queueing any packets.
Date: Mon, 3 Dec 2007 18:17:59 -0800
Message-ID: <a2997d4b0712031817h1e94aafew8cdadd069eb83b2b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.184]:52447 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbXLDCSA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2007 21:18:00 -0500
Received: by rv-out-0910.google.com with SMTP id k20so2939817rvb
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Dec 2007 18:17:59 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I tried running the test code that is included in the utils/
directory.  It runs and then stalls where it is supposed to be
receiving packets to queue.  I am wondering if there is something I'm
missing.  Currently my machine is just on my private network. It is
NOT setup as a router, the traffic that I thought I would see would be
simple http packets from visiting web pages.  However, it doesn't see
to get any packets of any sort.  Am I missing something?  Do I need to
somehow setup netfilter to intercept the packets and then queue them
for my userspace program?  Any help would be greatly appreciated.
Thanks.
-Dom
