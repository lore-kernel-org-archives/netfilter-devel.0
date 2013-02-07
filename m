From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Assorted fixes v3
Date: Thu, 7 Feb 2013 19:53:31 +0100
Message-ID: <20130207185330.GA18719@localhost>
References: <1360111625-1759-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:31811 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161093Ab3BGSxg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:53:36 -0500
Content-Disposition: inline
In-Reply-To: <1360111625-1759-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 06, 2013 at 01:47:01AM +0100, Jan Engelhardt wrote:
> Removed
>   build: also use libtool for install stage
>   iptables: reword warning on using an alias
> Added:
>   build: bump SONAME for libxtables
> 
> ===
> The following changes since commit 817ac5a5e54d083983b7c834194b46c4366d71d2:
> 
>   Merge branch 'master' of vishnu.netfilter.org:/data/git/iptables (2013-01-31 20:36:27 +0100)
> 
> are available in the git repository at:
> 
> 
>   git://git.inai.de/iptables master
> 
> for you to fetch changes up to 80722f5b0c2723d34782affec7dc247352d9be33:
> 
>   iptables: fall back to using save function when print is not defined (2013-02-06 01:40:43 +0100)
> 
> ----------------------------------------------------------------
> Jan Engelhardt (4):
>       build: bump SONAME for libxtables

Applied this one, thanks a lot for catching up this.

>       libxtables: centralize checking for a .save function
>       extensions: eui64: set userspacesize=0
>       iptables: fall back to using save function when print is not defined

Not applying these, they are not fixes, sorry.
