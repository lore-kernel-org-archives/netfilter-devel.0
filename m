From: Sam Roberts <vieuxtech@gmail.com>
Subject: kernel bug while trying to create expectations in user-space
Date: Tue, 15 Feb 2011 15:21:49 -0800
Message-ID: <AANLkTiku+WoLDn_vnGv-Bo7sc1GmC=g_f9KmPssJ8and@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60736 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731Ab1BOXVt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Feb 2011 18:21:49 -0500
Received: by qwa26 with SMTP id 26so586121qwa.19
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Feb 2011 15:21:49 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am running v2.6.37 from http://kernel.ubuntu.com/~kernel-ppa/mainline/.

I've removed the ubuntu conntrack libraries and tools, and rebuilt
libnfct and conntrack tools from git master.

I ran expect_create_userspace a few times, the first was shown by
conntrack -E expect, I think the third run in a row crashed.

BUG: unable to handle kernel NULL pointer dereference at    (null)
IP: [f9b71ce2>] exp_seq_show+0xd2/0x200 [nf_conntrack]

It goes on...

Is there a better way to report this?

I'll try to reproduce this, I'm thrashing around with a range of
problems with nfct right now.

Cheers,
Sam
