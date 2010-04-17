From: Ali Hamidi <ali.hamidi759@gmail.com>
Subject: Kernel Hung using packet squeezer
Date: Sat, 17 Apr 2010 10:56:38 +0430
Message-ID: <g2u6a3fa21004162326x9927450ezc70e9ae58a09f261@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Justin Yaple <yaplej@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:53965 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab0DQG0l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Apr 2010 02:26:41 -0400
Received: by bwz25 with SMTP id 25so3832822bwz.28
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Apr 2010 23:26:38 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I put the packet squeezer code inside dom 0 of a xen enabled kernel
that the version is 2.6.24-25-xen and after correction of some errors
i compiled it and insert the module into kernel. every thing was OK,
until i started a tcp connection from a domu guest, the dom0 kernel
hung and i don't know why. because the correction of your code was
based on the kernel changes for dev_get_by_name function and the skb
pointer of the netfilter hook function must be *skb not **skb. please
help me solve this problem I really don't know what to do.
