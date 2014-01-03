From: Mehran Kholdi <semekh.dev@gmail.com>
Subject: How to get pid of packet sender from NFQUEUE?
Date: Fri, 3 Jan 2014 03:52:21 +0330
Message-ID: <CAKiFbu9h1an38XXeNDy1ivcEz1vZHaqK+ekmQVXZLUChpJ3pBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:49781 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbaACAXC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:23:02 -0500
Received: by mail-pa0-f51.google.com with SMTP id fa1so15198271pad.10
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Jan 2014 16:23:01 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So, I've got my code in userland (using netfilter_queue) that tries to
handle packets according to different attributes (sort of a firewall).
Is it possible to get the pid of sender program?
I'm aware that it is possible to apply pid-based rules with iptables
directly, but how could I access that property in the NFQUEUE?

Thanks,
-- Mehran
