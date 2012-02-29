From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnetfilter_cttimeout: misc cleanup
Date: Wed, 29 Feb 2012 10:40:30 +0100
Message-ID: <20120229094030.GA32689@1984>
References: <1330499742-28091-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48550 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964940Ab2B2Jki (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Feb 2012 04:40:38 -0500
Content-Disposition: inline
In-Reply-To: <1330499742-28091-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 29, 2012 at 08:15:36AM +0100, Jan Engelhardt wrote:
> 
> 
> Note that src/*.c reads "GPL-2.0+" while the COPYING file shows
> an LGPL-2.1 text. Clarification would be welcome.

This is GPLv2+ stuff. I just pushed a patch to fix this, thanks for
spotting this.

> ===
> The following changes since commit eb9385b594bbd463fdc0704c33ca88e4d2e4cbb1:
> 
>   add README file (2012-02-29 03:33:44 +0100)
> 
> are available in the git repository at:
>   git://dev.medozas.de/libnetfilter_cttimeout master
> 
> Jan Engelhardt (6):
>       Add .gitignore
>       const-ify static data objects
>       Add stdint header and type corrections
>       Properly NUL-terminate name in nfct_timeout_attr_set
>       const-ify arguments of functions
>       Add extern "C" guard for C++ compilation mode

And this bunch applied, thanks Jan!
