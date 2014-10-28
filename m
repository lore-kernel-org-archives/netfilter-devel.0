From: Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: Re: [PATCH 1/3] Introduce nft_log_dereference() macro
Date: Tue, 28 Oct 2014 10:47:54 -0200
Message-ID: <544F907A.9030409@redhat.com>
References: <12a99ae77aa9969692d847d8d2929deb13485e72.1414155204.git.mleitner@redhat.com> <20141027220342.GA5998@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbaJ1Mr6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:47:58 -0400
In-Reply-To: <20141027220342.GA5998@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27-10-2014 20:03, Pablo Neira Ayuso wrote:
> On Fri, Oct 24, 2014 at 10:59:49AM -0200, Marcelo Ricardo Leitner wrote:
>> Wrap up a common call pattern in an easier to handle call.
>
> Patch doesn't apply for some reason.
>
> nf-next$ git am /tmp/1-3-Introduce-nft_log_dereference-macro.patch -s
> Applying: Introduce nft_log_dereference() macro
> error: patch failed: net/netfilter/nf_log.c:28
> error: net/netfilter/nf_log.c: patch does not apply
> Patch failed at 0001 Introduce nft_log_dereference() macro
> When you have resolved this problem run "git am --resolved".
> If you would prefer to skip this patch, instead run "git am --skip".
> To restore the original branch and stop patching run "git am --abort".
>

Oh that's weird, but I'll send it again together with the other ones.

Marcelo
