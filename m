From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2] ipvs: use nf_ct_kill helper
Date: Fri, 12 Aug 2016 12:24:43 +0200
Message-ID: <20160812102443.GA3086@salvia>
References: <1470230488-302-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, lvs-devel@vger.kernel.org,
	horms@verge.net.au
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58888 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbcHLKYz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 06:24:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6862CD1632
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 12:24:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5A85EFAB5B
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 12:24:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5DF02FAB5B
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 12:24:52 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1470230488-302-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 03, 2016 at 03:21:28PM +0200, Florian Westphal wrote:
> Once timer is removed from nf_conn struct we cannot open-code
> the removal sequence anymore.

@Simon and other IPVS folks: I'm going to take this patch since
Florian needs this merged for follow up patches.

So I'm dealing with this small one.

Thanks.
