From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2 nf-next 4/4] netfilter: nfnetlink_log: allow to attach
 conntrack
Date: Mon, 5 Oct 2015 17:23:16 +0200
Message-ID: <20151005152315.GA11562@salvia>
References: <1443724990-4014-1-git-send-email-pablo@netfilter.org>
 <1443724990-4014-2-git-send-email-pablo@netfilter.org>
 <20151005024454.GA14637@gmail.com>
 <20151005025046.GE14637@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53797 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbbJEPQW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Oct 2015 11:16:22 -0400
Content-Disposition: inline
In-Reply-To: <20151005025046.GE14637@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 05, 2015 at 11:50:46AM +0900, Ken-ichirou MATSUZAWA wrote:
> This patch enables to include the conntrack information together
> with the packet that is sent to user-space via NFLOG, then a
> user-space program can acquire NATed information by this NFULA_CT
> attribute.

WARNING: suspect code indent for conditional statements (8, 24)
#99: FILE: net/netfilter/nfnetlink_log.c:581:
+       if (ct && nfnl_ct->build(inst->skb, ct, ctinfo,
[...]
+                       goto nla_put_failure;

Please, make sure you use tabs next time.

ERROR: trailing whitespace
#102: FILE: net/netfilter/nfnetlink_log.c:584:

ERROR: trailing whitespace
#137: FILE: net/netfilter/nfnetlink_log.c:693:

Please, run checkpatch.pl on your patches next time to address
whitespace errors and wrong indent.

And regarding this:

        ...
        rcu_dereference(nfnl_ct_hook) == NULL) {

it should be:

        rcu_access_pointer(nfnl_ct_hook) == NULL) {

I have fixed these issues here this time, no need to resend.

But, would you please resubmit this:

http://patchwork.ozlabs.org/patch/516185/

but using rcu_access_pointer() instead?

BTW, another thing that would be good to investigate is to autoload
nf_conntrack_netlink if the process passes the _F_CONNTRACK flag is
set. Would you have a look into that?

Thanks.
