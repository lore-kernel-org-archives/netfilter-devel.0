From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: conntrack: fix CT target for UNSPEC helpers
Date: Wed, 9 Nov 2016 00:07:22 +0100
Message-ID: <20161108230722.GA31437@salvia>
References: <1478180682-3776-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, twoerner@redhat.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59182 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751977AbcKHXIE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Nov 2016 18:08:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F3A55392E19
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2016 00:07:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DFE29DA807
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2016 00:07:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DB20BDA807
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2016 00:07:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1478180682-3776-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 03, 2016 at 02:44:42PM +0100, Florian Westphal wrote:
> Thomas reports its not possible to attach the H.245 helper:
> 
> iptables -t raw -A PREROUTING -p udp -j CT --helper H.245
> iptables: No chain/target/match by that name.
> xt_CT: No such helper "H.245"
> 
> This is because H.245 registers as NFPROTO_UNSPEC, but the CT target
> passes NFPROTO_IPV4/IPV6 to nf_conntrack_helper_try_module_get.
> 
> We should treat UNSPEC as wildcard and ignore the l3num instead.

Also applied, thanks.
