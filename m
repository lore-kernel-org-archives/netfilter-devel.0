From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: audit fix, headers,
Date: Tue, 18 Jan 2011 16:21:33 +0100
Message-ID: <4D35AFFD.7040103@trash.net>
References: <1295363820-14881-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57625 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab1ARPVh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 10:21:37 -0500
In-Reply-To: <1295363820-14881-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18.01.2011 16:16, Jan Engelhardt wrote:
> The following changes since commit fbabf31e4d482149b5e2704eb0287cf9117bdcf3:
> 
>   netfilter: create audit records for x_tables replaces (2011-01-16 18:12:59 +0100)
> 
> are available in the git repository at:
>   git://dev.medozas.de/linux master
> 
> Jan Engelhardt (4):
>       netfilter: xtables: add missing aliases for autoloading via iptables
>       audit: export symbol for use with xt_AUDIT
>       netfilter: xtables: use __uXX guarded types for userspace exports
>       netfilter: xtables: add missing header files to export list
> 
> Richard Weinberger (1):
>       netfilter: xt_connlimit: use hotdrop jump mark

Pulled, thanks Jan. I'll push them out in a few minutes after some
build testing.

