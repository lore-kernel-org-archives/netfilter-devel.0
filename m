From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next v3] netfilter: conntrack: allow increasing bucket
 size via sysctl too
Date: Thu, 23 Jun 2016 19:41:03 +0200
Message-ID: <20160623174103.GA3620@salvia>
References: <1466594770-8610-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, zlpnobody@gmail.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56954 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbcFWRlI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 13:41:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E57908D051C
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:41:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D49789EBA8
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:41:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C898B9EBAF
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:41:04 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1466594770-8610-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 22, 2016 at 01:26:10PM +0200, Florian Westphal wrote:
> No need to restrict this to module parameter.
> 
> We export a copy of the real hash size -- when user alters the value we
> allocate the new table, copy entries etc before we update the real size
> to the requested one.
> 
> This is also needed because the real size is used by concurrent readers
> and cannot be changed without synchronizing the conntrack generation
> seqcnt.
> 
> We only allow changing this value from the initial net namespace.
> 
> Tested using http-client-benchmark vs. httpterm with concurrent
> 
> while true;do
>  echo $RANDOM > /proc/sys/net/netfilter/nf_conntrack_buckets
> done

Applied, thanks Florian.
