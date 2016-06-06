From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH] include/network.h: fix erroneus comment
 in NTA_(S|D)NAT_IPV6
Date: Mon, 6 Jun 2016 13:24:34 +0200
Message-ID: <20160606112434.GA24269@salvia>
References: <146494412135.11445.11203183861526839776.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52130 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbcFFLYr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2016 07:24:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8D22EED062
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Jun 2016 13:24:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7C5D71B32CE
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Jun 2016 13:24:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5BB8D1B323C
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Jun 2016 13:24:35 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146494412135.11445.11203183861526839776.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 03, 2016 at 10:55:21AM +0200, Arturo Borrero Gonzalez wrote:
> We don't use 'struct nfct_attr_grp_ipv6', actually 'uint32_t * 4'.

Applied, thanks.
