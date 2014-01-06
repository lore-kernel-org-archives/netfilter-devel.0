From: David Gervais <dgervais@gmail.com>
Subject: ipset: hash_netnet4_data_equal typo commit status follow-up
Date: Mon, 6 Jan 2014 12:52:51 -0500
Message-ID: <CADrOd4ATEkknSRonuuS5me-UraJaoK+UaBd68D_Q4nnQ0oMD-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vb0-f50.google.com ([209.85.212.50]:40659 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaAFRwv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:52:51 -0500
Received: by mail-vb0-f50.google.com with SMTP id w18so9236240vbj.37
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jan 2014 09:52:51 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef, et. al.,

I noticed that the following commit has not yet been synchronized into
the main ipset git repo and requires pulling. The commit currently
exists in Pablo's netfilter repo, David Miller's repo, and in Linus's
3.14 RC repo.

netfilter: ipset: fix incorret comparison in hash_netnet4_data_equal()
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=b49faea7655ec10ade15d7d007e4218ca578a513

Since the original fix was submitted on November 25th and still has
yet to be applied to the main ipset git repo, I figured I would
follow-up regarding its status and to make sure it wasn't lost.

Original thread details can be found here:
http://marc.info/?l=netfilter-devel&m=138649510024398

-Dave
