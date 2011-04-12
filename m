From: Justin Yaple <yaplej@gmail.com>
Subject: Netfilter Hook and Multiqueue?
Date: Tue, 12 Apr 2011 12:21:17 -0700
Message-ID: <BANLkTiku955Q-f=8T0K=qqY6i3tm5jFN_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43510 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab1DLTVS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:21:18 -0400
Received: by bwz15 with SMTP id 15so5639939bwz.19
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2011 12:21:17 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I am using a netfilter hook to capture "NF_IP_FORWARD" traffic and
route packets to my application in userspace.  I want to implement
more queues to distribute softirqs between multiple CPUs.  Is it
currently possible to "return NF_QUEUE" with a specific queuenum or is
this handled automatically if I create more queue handlers in my
application?

Thanks.
