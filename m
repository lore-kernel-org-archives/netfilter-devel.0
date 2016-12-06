From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] netfilter: convert while loops to for loops
Date: Tue, 6 Dec 2016 16:10:33 +0300
Message-ID: <20161206131033.GA20750@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: aconole@bytheb.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26987 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752043AbcLFNUe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2016 08:20:34 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Aaron Conole,

This is a semi-automatic email about new static checker warnings.

The patch 66cfc1dd07c7: "netfilter: convert while loops to for loops" 
from Nov 15, 2016, leads to the following Smatch complaint:

net/bridge/br_netfilter_hooks.c:1016 br_nf_hook_thresh()
	 warn: variable dereferenced before check 'elem' (see line 1012)

net/bridge/br_netfilter_hooks.c
  1011		for (elem = rcu_dereference(net->nf.hooks[NFPROTO_BRIDGE][hook]);
  1012		     nf_hook_entry_priority(elem) <= NF_BR_PRI_BRNF;
                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Dereference inside function.

  1013		     elem = rcu_dereference(elem->next))
  1014			;
  1015	
  1016		if (!elem)
                     ^^^^
This can't be reached without already dereferencing "elem".

  1017			return okfn(net, sk, skb);
  1018	

regards,
dan carpenter
