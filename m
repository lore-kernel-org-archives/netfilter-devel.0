From: Aaron Conole <aconole@bytheb.org>
Subject: Re: [RFC nf-next 1/3] netfilter: bridge: add and use br_nf_hook_thresh
Date: Wed, 22 Jun 2016 17:43:11 -0400
Message-ID: <f7t1t3ozyq8.fsf@redhat.com>
References: <1466631271-10737-1-git-send-email-aconole@bytheb.org>
	<1466631271-10737-2-git-send-email-aconole@bytheb.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netfilter-devel@vger.kernel.org
To: netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:35858 "EHLO
	mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbcFVVnO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 17:43:14 -0400
Received: by mail-qk0-f181.google.com with SMTP id p10so84039414qke.3
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 14:43:13 -0700 (PDT)
In-Reply-To: <1466631271-10737-2-git-send-email-aconole@bytheb.org> (Aaron
	Conole's message of "Wed, 22 Jun 2016 17:34:29 -0400")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Aaron Conole <aconole@bytheb.org> writes:

> From: Florian Westphal <fw@strlen.de>
>
> This replaces the last uses of NF_HOOK_THRESH().
> Followup patch will remove it and rename nf_hook_thresh.
>
> The reason is that inet (non-bridge) netfilter no longer invokes the
> hooks from hooks, so we do no longer need the thresh value to skip hooks
> with a lower priority.
>
> The bridge netfilter however may need to do this. br_nf_hook_thresh is a
> wrapper that is supposed to do this, i.e. only call hooks with a
> priority that exceeds NF_BR_PRI_BRNF.
>
> It's used only in the recursion cases of br_netfilter.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Aaron Conole <aconole@redhat.com>
> ---

I will make sure to fix the address in this patch.  Apologies.
