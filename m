From: aikipooh@gmail.com (=?utf-8?B?0K7RgNC40Lkg0J/Rg9GF0LDQu9GM0YHQutC4?=
	=?utf-8?B?0Lk=?=)
Subject: Mangling packets & routing in kernels>3.17
Date: Thu, 21 May 2015 21:58:38 +0300
Message-ID: <87h9r5u59d.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:33436 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbbEUS6g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 May 2015 14:58:36 -0400
Received: by lami4 with SMTP id i4so192145lam.0
        for <netfilter-devel@vger.kernel.org>; Thu, 21 May 2015 11:58:34 -0700 (PDT)
Received: from pooh ([37.204.161.45])
        by mx.google.com with ESMTPSA id v6sm5460047laa.23.2015.05.21.11.58.33
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2015 11:58:34 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have an application and an iptables kernel module to change src/dst addr/port of the packets going from different interfaces. Application uses libnetfilter_queue.
It worked ok with 3.17.2 (embedded gentoo) where kernel module works and also on 3.14 on regular linux where libnetfilter application works.
After I've upgraded to 3.18 both stopped working. The packet comes, I change addresses and ports and don't see it coming out. I've tried to route it manually in kernel module but it didn't help. Locally originated packets were mangled and sent out correctly with the module. So it must be something with the forwarding/routing part probably.

Can you think of any changes between 3.17 and 3.18 that could have broken it?
