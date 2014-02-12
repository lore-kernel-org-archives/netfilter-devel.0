From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables (nft-compat) PATCH 0/5] Various fixes version 2
Date: Wed, 12 Feb 2014 10:21:02 +0100
Message-ID: <20140212092102.GA6583@localhost>
References: <1392136606-10339-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57957 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbaBLJVm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:21:42 -0500
Content-Disposition: inline
In-Reply-To: <1392136606-10339-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 11, 2014 at 06:36:41PM +0200, Tomasz Bursztyka wrote:
> Patch 1 and 2 are a resent of previous patchset.
> (patch 1 is quite useful actually, at leats it was for testing patch 3)
> (patch 2 is a bug fix)
> 
> Patch 3 is the full rewrite of patch 8 it previous patchset.
> Much smaller, and works in all case with xtables-restore with or without --table option.
> 
> Patch 4 is applying the idea to get rid of useless error message (which clearly did not help at all).
> 
> Patch 5 is a debug message fix.

Series applied, thanks Tomasz.
