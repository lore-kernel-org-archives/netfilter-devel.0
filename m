From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ipset-5 build patches
Date: Sun, 24 Oct 2010 23:30:45 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010242330250.18070@obet.zrqbmnf.qr>
References: <1287504742-12922-1-git-send-email-jengelh@medozas.de> <alpine.DEB.2.00.1010242217200.22824@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49045 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932980Ab0JXVar (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Oct 2010 17:30:47 -0400
In-Reply-To: <alpine.DEB.2.00.1010242217200.22824@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2010-10-24 23:01, Jozsef Kadlecsik wrote:

>Hi Jan,
>
>On Tue, 19 Oct 2010, Jan Engelhardt wrote:
>
>> Jan Engelhardt (8):
>>       build: just use autoreconf
>>       build: resolve autoreconf/libtoolize suggestions
>>       build: add separate option for kernel source directory
>>       build: use libmnl's pkgconfig files
>>       build: remove manual -fPIC flag
>>       build: use subdir-objects and CC_C_O
>>       build: run autoupdate
>>       Add .gitignore files
>
>All patches are applied, thanks. For the separate kernel source directory 
>option I've added a fallback to the kernel build directory.

Um, you squashed all commits. That's bad for tracking.
