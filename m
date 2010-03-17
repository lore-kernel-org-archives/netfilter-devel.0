From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables pull request, add XT_RECENT_REAP support
Date: Wed, 17 Mar 2010 21:14:55 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003172113480.16169@obet.zrqbmnf.qr>
References: <20100317184852.89F0DF89BB@sepang.rtg.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Tim Gardner <timg@tpi.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51251 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755157Ab0CQUO4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 16:14:56 -0400
In-Reply-To: <20100317184852.89F0DF89BB@sepang.rtg.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-03-17 19:48, Tim Gardner wrote:
>@@ -41,6 +41,11 @@ This option must be used in conjunction with one of \fB\-\-rcheck\fP or
> \fB\-\-update\fP. When used, this will narrow the match to only happen when the
> address is in the list and was seen within the last given number of seconds.
> .TP
>+\fB\-\-reap\fP \fIreap\fP
>+This option must be used in conjunction with \fB\-\-seconds\fP. When used, this
>+will remove entries with the most recent timestamp older then \fB\-\-seconds\fP
>+since the last packet was received.
>+.TP

 --reap does not take any argument.

Also, this option does not need to be used (!must be), it's optional.
