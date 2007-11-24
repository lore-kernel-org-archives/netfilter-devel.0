From: ZC Miao <hellwolf.misty@gmail.com>
Subject: about the exact meanning of verdict value in netfilter_queue
Date: Sat, 24 Nov 2007 21:45:34 +0800
Message-ID: <1195911934.30072.8.camel@cocteau.freehell.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:14982 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbXKXNpy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Nov 2007 08:45:54 -0500
Received: by wa-out-1112.google.com with SMTP id v27so135959wah
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Nov 2007 05:45:54 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

When programming with netfilter_queue, I must verdict every package I
received with nfq_set_verdict/nfq_set_verdict_mark, the meaning of the
verdict value seems a little different with that in kernel space. Is
there any explanation of each of them(NF_ACCEPT, NF_QUEUE, NF_REPEAT,
NF_STOLEN, NF_STOP,..)?

Thanks, best regards,
--
ZC Miao (hellwolf.misty@gmail.com)
Blog http://hellwolf.cublog.cn

gpg --keyserver pgp.mit.edu --recv-key 0x6B174C6F

Our business is run on trust.  We trust you will pay in advance.

