From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Accessing sk_buf
Date: Tue, 6 Apr 2010 12:57:03 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004061255130.16293@obet.zrqbmnf.qr>
References: <174890.36512.qm@web111003.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Andrew Watts <akwatts@ymail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36916 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab0DFK5F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Apr 2010 06:57:05 -0400
In-Reply-To: <174890.36512.qm@web111003.mail.gq1.yahoo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-04-05 12:10, Andrew Watts wrote:

>Dear list:
>
>I am writing a "bump" message for a previous post of mine. I would like
>suggestions or advice on how to go about accessing packet skbuf->sk
>fields (inodes, for example), in userspace via NFQUEUE. My read is
>that this is currently not possible as these are not exported.
>
>Has anyone played with patches that achieve this? Any suggestions on
>where to look?

There is a bug report at 
http://bugzilla.netfilter.org/show_bug.cgi?id=600 where I posted a 
patch, but it has not seen acceptance yet. May need to push harder.
