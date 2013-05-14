From: Ronald <ronald645@gmail.com>
Subject: v3.10-rc1 regression notice. (bug #818: NULL pointer dereference ipt_log_packet+0x2e/0x2b0)
Date: Tue, 14 May 2013 19:21:46 +0200
Message-ID: <CAF1_xX0ssFWyY8Lvi6z3pSAA4gPUEJXVxrfHhdPPG3hZoMD+dA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:53691 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab3ENRVr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 May 2013 13:21:47 -0400
Received: by mail-qa0-f54.google.com with SMTP id o13so571825qaj.13
        for <netfilter-devel@vger.kernel.org>; Tue, 14 May 2013 10:21:46 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear netfilter developers,

Since v3.10-rc1 I get kernel panics on two entirely different
machines. They seem to be related to netfilter. I posted a bugreport
[1], but have not seen any reply.

If I did something (incredibly) wrong, please let me know. Otherwise,
sorry for my impatience.

                    Ronald

[1]: https://bugzilla.netfilter.org/show_bug.cgi?id=818
