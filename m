From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables: misc option edits
Date: Wed, 23 Feb 2011 17:40:34 +0100
Message-ID: <4D653882.7070501@trash.net>
References: <1298142259-11213-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55232 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab1BWQkj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Feb 2011 11:40:39 -0500
In-Reply-To: <1298142259-11213-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 19.02.2011 20:04, schrieb Jan Engelhardt:
> Please review! (And if ok, merge.)
> 
> ===
> 
> The following changes since commit 87dc7c4c842deb1e2e3d38089ffcad9f238d98de:
> 
>   xtables: use strspn() to check if string needs to be quoted (2011-02-17 11:57:19 +0100)
> 
> are available in the git repository at:
>   git://dev.medozas.de/iptables master
> 
> Jan Engelhardt (8):
>       doc: fix wrong sentence about negation in xt_limit
>       doc: fix misspelling of "field"
>       extensions: remove redundant init functions
>       Remove unused CVS expanded keywords
>       libip6t_dst: remove unimplemented --dst-not-strict
>       libip6t_hbh: remove unimplemented --hbh-not-strict
>       extensions: add missing checks for specific flags
>       libipt_ECN: set proper option flags
> 

Looks good, pulled, thanks Jan.
