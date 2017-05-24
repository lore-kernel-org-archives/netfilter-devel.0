From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 6/6 RFC] netfilter: add audit netns ID
Date: Wed, 24 May 2017 19:31:06 +0200
Message-ID: <20170524173106.GA7439@salvia>
References: <cover.1495124188.git.rgb@redhat.com>
 <c19c5f9a2b5bf8d43ced7a0a10d2da80934f242a.1495124188.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, linux-audit@redhat.com,
        Florian Westphal <fw@strlen.de>,
        Thomas Woerner <twoerner@redhat.com>,
        Thomas Graf <tgraf@infradead.org>,
        Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46088 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752700AbdEXRbM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 13:31:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ED199DFF1F
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 19:31:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DE5321007B4
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 19:31:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C5168DA87A
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 19:31:00 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <c19c5f9a2b5bf8d43ced7a0a10d2da80934f242a.1495124188.git.rgb@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cc'ing Eric Biederman.

On Thu, May 18, 2017 at 01:21:52PM -0400, Richard Guy Briggs wrote:
> diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
> index 59b63a8..0f77b2a 100644
> --- a/net/bridge/netfilter/ebtables.c
> +++ b/net/bridge/netfilter/ebtables.c
> @@ -27,6 +27,7 @@
>  #include <linux/smp.h>
>  #include <linux/cpumask.h>
>  #include <linux/audit.h>
> +#define PROC_DYNAMIC_FIRST 0xF0000000U
>  #include <net/sock.h>
>  /* needed for logical [in,out]-dev filtering */
>  #include "../br_private.h"
> @@ -1075,7 +1076,8 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
>  			ab = audit_log_start(current->audit_context, GFP_KERNEL,
>  					     AUDIT_NETFILTER_CFG);
>  			if (ab) {
> -				audit_log_format(ab, "op=replace family=%u table=%s entries=%u",
> +				audit_log_format(ab, "op=replace net=%u family=%u table=%s entries=%u",
> +						 net->ns.inum - PROC_DYNAMIC_FIRST,

IIRC, there was a discussion on exposing netns i-node number to
userspace time ago on netdev and Eric Biederman was not happy about
this?
