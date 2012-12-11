From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/5] netfilter: nf_tables: nf_tables update
Date: Tue, 11 Dec 2012 02:42:39 +0100
Message-ID: <20121211014239.GA18063@1984>
References: <1355160012-13952-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33742 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab2LKBmo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Dec 2012 20:42:44 -0500
Content-Disposition: inline
In-Reply-To: <1355160012-13952-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 10, 2012 at 06:20:07PM +0100, kaber@trash.net wrote:
> The following patches for nf_tables fix a few bugs and introduct
> loop detection:
> 
> - anonymous sets are currently broken since we're not reporting the
>   chosen set name to userspace anymore
> 
> - save 48 bits per rule by reducing the handle size and plugging a whole
> 
> - destroy anonymous sets immediately when binding fails since there
>   will be no unbinding operation
> 
> - add loop detection for new jump verdicts
> 
> Please apply, thanks!

All applied, thanks a lot Patrick!
