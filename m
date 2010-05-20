From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables connlimit not works in RHEL 5.1
Date: Thu, 20 May 2010 21:03:43 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005202102080.23657@obet.zrqbmnf.qr>
References: <AANLkTilspYQiScZyBROF-x9nh54ju_KXMH9gHVUKNTQ8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Narendra Choyal <narendrachoyal@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40349 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab0ETTDp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 May 2010 15:03:45 -0400
In-Reply-To: <AANLkTilspYQiScZyBROF-x9nh54ju_KXMH9gHVUKNTQ8@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-05-20 21:00, Narendra Choyal wrote:

>connlimit doesn't work on RHEL 5.1


And you get to that conclusion because of...?

(Then again, RHEL is known to be, well, really dated.)


>and same command will works on all versions of Fedora
>
>My command is
>
>#iptables -A INPUT -p tcp --syn --dport -s X.X.X.X -m connlimit !
>--connlimit-above 2 -j REJECT --reject-with -tcp-reset

