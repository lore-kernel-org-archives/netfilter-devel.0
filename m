From: "Giant Sand Fan's" <rampxxxx@gmail.com>
Subject: NF_IP_PRE_ROUTING,... not defined
Date: Mon, 10 Nov 2008 18:53:30 +0100
Message-ID: <417f50830811100953i6edaa921x53de3710e956c97f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:7140 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbYKJRxb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2008 12:53:31 -0500
Received: by yw-out-2324.google.com with SMTP id 9so947175ywe.1
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2008 09:53:30 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

because the #ifndef __KERNEL__ tags goes beyond NT_IP_PRE_ROUTING,..
defines , this change appears in 2.6.25 (because I works in 2.6.22)
and I cannot compile my kernel module hook with that version.

There is a way to do a correct development-compilation with this headers?

I cannot find anything about this issue.Yes I can move the "#endif"
but i think that must not be right thing.

So sorry if I'm out of scope.
-- 
Please avoid sending me Word or PowerPoint attachments.
See http://www.gnu.org/philosophy/no-word-attachments.html
