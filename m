From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables build fixes
Date: Tue, 09 Aug 2011 13:23:33 +0200
Message-ID: <4E4118B5.1090600@trash.net>
References: <1312764144-23849-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35443 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab1HILXg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Aug 2011 07:23:36 -0400
In-Reply-To: <1312764144-23849-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08.08.2011 02:42, Jan Engelhardt wrote:
> The following changes since commit 88e0a097c3f23dadf041b60445c6c9802c502f15:
> 
>   Merge branch 'master' of git://dev.medozas.de/iptables (2011-07-11 10:41:10 +0200)
> 
> are available in the git repository at:
> 
>   git://dev.medozas.de/iptables master
> 
> Jan Engelhardt (7):
>       extensions: use multi-target registration
>       libxt_TCPMSS: restore build with IPv6-less libcs
>       libxt_string: define _GNU_SOURCE for strnlen
>       build: workaround broken linux-headers on RHEL-5
>       build: strengthen check for overlong lladdr components
>       build: abort autogen on subcommand failure
>       libipq: add pkgconfig file

Pulled, thanks Jan.
