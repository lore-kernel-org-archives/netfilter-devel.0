From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] build: resolve build failure on systems with old
 glibc-linux headers
Date: Thu, 18 Dec 2014 19:53:38 +0100
Message-ID: <20141218185338.GA4776@salvia>
References: <1418687687-9124-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54006 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaLRSvU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Dec 2014 13:51:20 -0500
Content-Disposition: inline
In-Reply-To: <1418687687-9124-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 16, 2014 at 12:54:47AM +0100, Jan Engelhardt wrote:
> This fails to build on a SUSE Linux Enterprise 11 system where the
> linux-glibc-devel headers (/usr/include/linux) are of version 2.6.32.
> 
> The reason for that is that x_tables.h is only present in the git
> repository, but not the tarball as produced by `make dist`. Add the
> missing file to the file list.

This doesn't apply neither to libnftnl nor to nftables (the PATCH tag
doesn't specify).

Please test that your patches before submitting, thank you.
