From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables: improve build system
Date: Mon, 13 Jan 2014 09:12:51 +0000
Message-ID: <20140113091250.GB14601@macbook.localnet>
References: <1389604070-12068-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55241 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaAMJMz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:12:55 -0500
Content-Disposition: inline
In-Reply-To: <1389604070-12068-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 13, 2014 at 10:07:47AM +0100, Jan Engelhardt wrote:
> 
> The following changes since commit b566123b9b60aff8ef21dfa7b21f817261236b1d:
> 
>   nftables: drop hard coded install using root user owner and group (2014-01-13 06:36:45 +0000)
> 
> are available in the git repository at:
> 
>   git://git.inai.de/nftables master
> 
> for you to fetch changes up to 54f180f8d762259d6fe5f671e5b19cf9a5a9b683:
> 
>   build: use automake and pkgconfig (2014-01-13 10:04:35 +0100)

I have no general objections against moving to automake/pkgconfig, but
your changelogs leave room for improvement.

>       build: remove unused checks

Why aren't we instead evaluating the results?

>       build: rename conflicting parser.h instances

The changelog mentions something about -I but no further explanation about
why this change is done and the effects.

I can't really comment on these changes unless I have further explanation.
