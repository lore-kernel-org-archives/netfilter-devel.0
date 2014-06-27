From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: use IS_ENABLED() macro
Date: Fri, 27 Jun 2014 12:50:18 +0200
Message-ID: <20140627105018.GA6058@localhost>
References: <53AD0623.5090104@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46771 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158AbaF0Ku1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2014 06:50:27 -0400
Content-Disposition: inline
In-Reply-To: <53AD0623.5090104@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 27, 2014 at 01:50:27PM +0800, Duan Jiong wrote:
> 
> replace:
>  #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
> with
>  #if IS_ENABLED(CONFIG_NF_CT_NETLINK)

Could you also send a new version including these?

net/ipv4/netfilter/nf_defrag_ipv4.c:#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
net/ipv4/netfilter/nf_defrag_ipv4.c:#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
net/ipv4/netfilter/nf_defrag_ipv4.c:#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
net/ipv4/netfilter/nf_defrag_ipv4.c:#if !defined(CONFIG_NF_NAT) && !defined(CONFIG_NF_NAT_MODULE)

Thanks.
