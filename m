From: Jianhua Sun <jsun01@email.wm.edu>
Subject: Support SNAT on the INPUT chain
Date: Sun, 28 Dec 2014 23:31:56 -0500
Message-ID: <CALfN5Z7Qd8eO4Vrz=b3S71HrZtPiESM6nkVu4g9NV_zGLJsW-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:53815 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaL2Eb5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Dec 2014 23:31:57 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so21040816wiv.1
        for <netfilter-devel@vger.kernel.org>; Sun, 28 Dec 2014 20:31:56 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello there,

I am a computer science student interested in Netfilter development.
In my research, I need to do source NAT on the INPUT chain.

My Linux kernel version is 2.6.18. This kernel does not have a INPUT
chain where source NAT can be done. Basically, I want to
change the source IP of the incoming packets on the INPUT chain. This
sounds a little weird. But yes, that is what I need to do
in my current research project.

I am thinking that we may need to patch the Netfilter code of the
2.6.18 kernel to achieve my goal. That is not easy to do.
So does anyone have any suggestion of how to do SNAT on the INPUT
chain? I would greatly appreciate it if you can
provide a patch to do that.

Thanks for your help.

Best,

Steve
Computer Science Dept.
College of William and Mary
