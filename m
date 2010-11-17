From: Changli Gao <xiaosuo@gmail.com>
Subject: [RFC] don't copy the whole table to all the other CPUs
Date: Wed, 17 Nov 2010 22:54:13 +0800
Message-ID: <AANLkTinBSZPAMKb7J0aBb4_xBv_QPnXTZAE9c+8=cnHz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56685 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179Ab0KQOyf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Nov 2010 09:54:35 -0500
Received: by fxm6 with SMTP id 6so610541fxm.19
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Nov 2010 06:54:34 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When reviewing the iptables code, I find there is one exact copy of
table on every possible CPU for parallel processing. However, only
counters are private, and the others are the same. It is a wast of
memory. I know the current implementation maybe good for NUMA, but I
don't think NUMA is common, and I doubt its benefit. I'll try to
convert the code use one shared table, but private counters.

Any comment?

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
