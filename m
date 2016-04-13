From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/4 v6] libnftnl: Implement new buffer of TLV objects
Date: Thu, 14 Apr 2016 01:55:40 +0200
Message-ID: <20160413235540.GB4253@salvia>
References: <1458675987-32398-1-git-send-email-carlosfg@riseup.net>
 <20160413231322.GA4253@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44232 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbcDMXzu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2016 19:55:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7BCB973F2
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 01:55:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6E919EBADB
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 01:55:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7E4CFC21A8
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 01:55:46 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160413231322.GA4253@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 14, 2016 at 01:13:22AM +0200, Pablo Neira Ayuso wrote:
> > +/* nftnl_udata_buf */
> > +struct nftnl_udata_buf *nftnl_udata_buf_alloc(uint32_t data_size);
> > +void nftnl_udata_buf_free(struct nftnl_udata_buf *buf);
> > +uint32_t nftnl_udata_buf_len(const struct nftnl_udata_buf *buf);
> > +uint32_t nftnl_udata_buf_size(const struct nftnl_udata_buf *buf);
> 
> Do we need nftnl_udata_buf_size? If not, please remove this.
> 
> We should only expose the interfaces that are strictly necessary.

Just manually removed this function myself here and applied this
patch.
