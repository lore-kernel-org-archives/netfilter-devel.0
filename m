From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/3] ipset patches for nf
Date: Sun, 8 Nov 2015 22:42:50 +0100
Message-ID: <20151108214250.GA12481@salvia>
References: <1446900145-14190-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60984 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbbKHVmz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Nov 2015 16:42:55 -0500
Content-Disposition: inline
In-Reply-To: <1446900145-14190-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 07, 2015 at 01:42:22PM +0100, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> Please apply the next bugfixes against the nf tree.
> 
> - Fix extensions alignment in ipset: Gerhard Wiesinger reported
>   that the missing data aligments lead to crash on non-intel
>   architecture. The patch was tested on armv7h by Gerhard Wiesinger
>   and on x86_64 and sparc64 by me.
> - An incorrect index at the hash:* types could lead to
>   falsely early expired entries and memory leak when the comment
>   extension was used too.
> - Release empty hash bucket block when all entries are expired or
>   all slots are empty instead of shrinkig the data part to zero.

Pulled, thanks Jozsef.
