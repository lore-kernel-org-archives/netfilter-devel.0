From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH -next 3/4] netfilter: xtables: don't save/restore
 jumpstack offset
Date: Thu, 09 Jul 2015 09:54:14 +0200
Message-ID: <1436428454.24939.13.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1436390139-4405-1-git-send-email-fw@strlen.de>
	 <1436390139-4405-4-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35410 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbbGIHyT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jul 2015 03:54:19 -0400
Received: by wiga1 with SMTP id a1so305178764wig.0
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jul 2015 00:54:18 -0700 (PDT)
In-Reply-To: <1436390139-4405-4-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2015-07-08 at 23:15 +0200, Florian Westphal wrote:

> +
> +	/* Switch to alternate jumpstack if we're being invoked via TEE.
> +	 * The problem is that TEE issues XT_CONTINUE verdict on original
> +	 * skb so we must not clobber the jumpstack.
> +	 *
> +	 * For recursion via REJECT or SYNPROXY the stack will be clobbered
> +	 * but its no problem since absolute verdict is issued by these.
> +	 */
> +	jumpstack += private->stacksize * __this_cpu_read(nf_skb_duplicated);

This could eventually be garded by

#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TEE)

Or even better, a jump label that would be enabled when TEE module is
loaded.



