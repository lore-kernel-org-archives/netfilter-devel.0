From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] configure: display summary at end of configure
Date: Wed, 5 Jun 2013 04:26:35 +0200
Message-ID: <20130605022635.GA12525@localhost>
References: <1359154090-11061-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56876 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab3FEC0l (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Jun 2013 22:26:41 -0400
Content-Disposition: inline
In-Reply-To: <1359154090-11061-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

On Fri, Jan 25, 2013 at 11:48:10PM +0100, Eric Leblond wrote:
> This patch adds a message at the end of configure which displays
> the different compilation options and system settings.
> 
> An example result is the following:
> 
> Iptables Configuration:
>   IPv4 support:				yes
>   IPv6 support:				yes
>   Devel support:			yes
>   IPQ support:				no
>   Large file support:			yes
> 
> Build parameters:
>   Static build:				no
>   Shared build:				yes
>   Installation prefix (--prefix):	/usr/local
>   Xtables extension directory:		/usr/local/lib/xtables
>   Pkg-config directory:			/usr/local/lib/pkgconfig
>   Kernel build directory:		/lib/modules/custom
>   Host:					x86_64-unknown-linux-gnu
>   GCC binary:				gcc

I recovered this patch and push it to master. I mangled it to fix a
conflict with the current tree and added the BPF utils to the display.
Thanks.

Regards.
