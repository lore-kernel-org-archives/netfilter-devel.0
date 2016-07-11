From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/2] netfilter: move nat hlist_head to nf_conn
Date: Mon, 11 Jul 2016 12:10:32 +0200
Message-ID: <20160711101032.GA18393@salvia>
References: <1467713244-8555-1-git-send-email-fw@strlen.de>
 <1467713244-8555-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44135 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbcGKKKh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jul 2016 06:10:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1B88B17AB6A
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:10:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F28EDEBADB
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:10:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A28249EBD2
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:10:33 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1467713244-8555-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 05, 2016 at 12:07:23PM +0200, Florian Westphal wrote:
> The nat extension structure is 32bytes in size on x86_64:
> 
> struct nf_conn_nat {
>         struct hlist_node          bysource;             /*     0    16 */
>         struct nf_conn *           ct;                   /*    16     8 */
>         union nf_conntrack_nat_help help;                /*    24     4 */
>         int                        masq_index;           /*    28     4 */
>         /* size: 32, cachelines: 1, members: 4 */
>         /* last cacheline: 32 bytes */
> };
> 
> The hlist is needed to quickly check for possible tuple collisions
> when installing a new nat binding. Storing this in the extension
> area has two drawbacks:
> 
> 1. We need ct backpointer to get the conntrack struct from the extension.
> 2. When reallocation of extension area occurs we need to fixup the bysource
>    hash head via hlist_replace_rcu.
> 
> We can avoid both by placing the hlist_head in nf_conn and place nf_conn in
> the bysource hash rather than the extenstion.
> 
> We can also remove the ->move support; no other extension needs it.
> 
> Moving the entire nat extension into nf_conn would be possible as well but
> then we have to add yet another callback for deletion from the bysource
> hash table rather than just using nat extension ->destroy hook for this.
> 
> nf_conn size doesn't increase due to aligment, followup patch replaces
> hlist_node with single pointer.

Applied, thanks.
