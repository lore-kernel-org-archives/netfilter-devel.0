From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] Introduce nft_log_dereference() macro
Date: Mon, 27 Oct 2014 23:03:42 +0100
Message-ID: <20141027220342.GA5998@salvia>
References: <12a99ae77aa9969692d847d8d2929deb13485e72.1414155204.git.mleitner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Marcelo Ricardo Leitner <mleitner@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38312 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbaJ0WCG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Oct 2014 18:02:06 -0400
Content-Disposition: inline
In-Reply-To: <12a99ae77aa9969692d847d8d2929deb13485e72.1414155204.git.mleitner@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 24, 2014 at 10:59:49AM -0200, Marcelo Ricardo Leitner wrote:
> Wrap up a common call pattern in an easier to handle call.

Patch doesn't apply for some reason.

nf-next$ git am /tmp/1-3-Introduce-nft_log_dereference-macro.patch -s
Applying: Introduce nft_log_dereference() macro
error: patch failed: net/netfilter/nf_log.c:28
error: net/netfilter/nf_log.c: patch does not apply
Patch failed at 0001 Introduce nft_log_dereference() macro
When you have resolved this problem run "git am --resolved".
If you would prefer to skip this patch, instead run "git am --skip".
To restore the original branch and stop patching run "git am --abort".
