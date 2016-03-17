From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2] extensions: libip6t_REJECT: Avoid to print the default
 reject with value in the translation
Date: Thu, 17 Mar 2016 16:46:38 +0100
Message-ID: <20160317154638.GB10673@salvia>
References: <20160316221749.GA4613@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50371 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935456AbcCQPqn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Mar 2016 11:46:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2F2F713C0E7
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Mar 2016 16:46:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2015CDA399
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Mar 2016 16:46:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1BA5BDA395
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Mar 2016 16:46:40 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160316221749.GA4613@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 16, 2016 at 11:17:52PM +0100, Laura Garcia Liebana wrote:
> Avoid to print the reject with value in the translation when the value
> is the default.
> 
> Before this patch:
> 
> $ sudo ip6tables-translate -A FORWARD -p TCP --dport 22 -j REJECT
> nft add rule ip6 filter FORWARD tcp dport 22 counter reject with icmpv6 type port-unreachable
> 
> After this patch:
> 
> $ sudo ip6tables-translate -A FORWARD -p TCP --dport 22 -j REJECT
> nft add rule ip6 filter FORWARD tcp dport 22 counter reject

Also applied, thanks.
