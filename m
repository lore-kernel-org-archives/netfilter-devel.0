From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables: NULL pointer dereference
Date: Thu, 23 Jul 2009 14:26:14 +0200
Message-ID: <4A6856E6.9030600@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: "Christoph A." <casmls@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35915 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbZGWM0S (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jul 2009 08:26:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Christoph A. wrote:
> when executing the testscript [1] (just to see if my nftables setup is
> working), I get the following stack trace.
>
> [1] http://article.gmane.org/gmane.linux.network/122512
>
> I'm using the latest version from:
> git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nft-2.6.git
> kernel config is attached
>
> BUG: unable to handle kernel NULL pointer dereference at 00000014
>  IP: [<f8b471ff>] nft_validate_data_load+0x20/0x53 [nf_tables]

Thanks for the report. This is likely happening because the kernel
includes support for some changes for which I haven't pushed out the
corresponding userspace support yet, but it certainly shouldn't oops.
I'll look into it ...


