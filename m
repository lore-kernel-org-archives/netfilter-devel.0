From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables cleanup patches
Date: Wed, 4 Nov 2009 23:35:12 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911042334190.19630@obet.zrqbmnf.qr>
References: <1257271483-26772-1-git-send-email-jengelh@medozas.de> <4AF07613.6030701@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42824 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758285AbZKDWfI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Nov 2009 17:35:08 -0500
In-Reply-To: <4AF07613.6030701@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2009-11-03 19:27, Patrick McHardy wrote:

>Jan Engelhardt wrote:
>> I am posting here already the next round of pullable patches
>> (that I originally wanted to get in _much_ faster) for review.
>
>Well, you could speed things up by benchmarking your patches yourself
>when concerns about adding overhead is raised. Otherwise you'll just
>have to wait until someone else gets to do it.

What would you use for profiling? A wallclock, rdtsc around the 
section,-- or one of the fancy 
ftrace/oprofile/perfcounter/$yetanotherprofiler?
