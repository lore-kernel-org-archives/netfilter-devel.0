From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Missing GPL headers
Date: Fri, 26 Feb 2010 11:55:31 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002261154001.29558@obet.zrqbmnf.qr>
References: <4B87A59F.60602@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Thomas Woerner <twoerner@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48943 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933370Ab0BZKzc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Feb 2010 05:55:32 -0500
In-Reply-To: <4B87A59F.60602@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-02-26 11:42, Thomas Woerner wrote:

> Hello,
>
> lots of files in the iptables tree are missing the GPL header but contain
> copyright messages.

I don't speak authoritatively, but the Linux kernel also has some files 
- usually those dating back to the initial years of Linux - that have no 
GPL header either, and everybody seems to be fine with that. See 
kernel/exit.c.
