From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] connlabel: clarify default config path
Date: Wed, 20 Jul 2016 18:22:26 +0200
Message-ID: <20160720162226.GB1413@salvia>
References: <1469008704-22989-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48471 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610AbcGTQWb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jul 2016 12:22:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 46EF8392E09
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 18:22:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 37A49FC61C
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 18:22:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 307B6FAB5E
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 18:22:27 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1469008704-22989-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 20, 2016 at 11:58:24AM +0200, Florian Westphal wrote:
> Pablo suggested to print full config file path for connlabel.conf
> parsing errors.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Pablo,
> 
>  I could also add the suggested nfct_labels_get_path() to lnf_conntrack
>  but that means next iptables-release depends on a new library version.
>  Given this name is set in stone anyway I would prefer this patch instead.
> 
>  Let me know, thanks.
>  I will send a separate patch to change nftables location.

We'll have a release of iptables 1.6.1 soon. Pablo Bermudo is working
on making sure that the interaction between nftables and
iptables-compat is fine.

And libnetfilter_conntrack is coming with IPv6 NAT support.

So I can schedule a release before end of this week / beginning next
weekend with accumulated updates so this comes in the next release.

Thanks for working on this!
