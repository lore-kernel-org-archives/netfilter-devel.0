Return-Path: <SRS0=bD7Q=5E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A0CAC4332D
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Mar 2020 20:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BF042070A
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Mar 2020 20:49:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Is53v1Wz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgCSUtd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Mar 2020 16:49:33 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:49622 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725787AbgCSUtd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Mar 2020 16:49:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584650971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+kGPWVZ1JYPgnWvFYolrBTfcSCVkDgdHgsl5mik+1R8=;
        b=Is53v1WzPWj2n+ubyZvrI+ikUr7w+xz4Q8vqhSxFgk7TNPrFRitWEmKtyGjz+tWNhbzP3/
        8xVcDgSsVG8CimUM11OPy/8d80J3+CZy69XmQyRpMnvZV9GdHEIrDJLSB7S436kvbfkgZW
        5+zQe59Ogqd4aBHaVWlR6BhZyOc2J/s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-VreRf3x-Mlu69AhW5M1NcA-1; Thu, 19 Mar 2020 16:49:29 -0400
X-MC-Unique: VreRf3x-Mlu69AhW5M1NcA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 773311005510;
        Thu, 19 Mar 2020 20:49:28 +0000 (UTC)
Received: from elisabeth (unknown [10.40.208.93])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A18385D9CD;
        Thu, 19 Mar 2020 20:49:26 +0000 (UTC)
Date:   Thu, 19 Mar 2020 21:49:20 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 4/4] nft_set_rbtree: Detect partial overlaps on
 insertion
Message-ID: <20200319214920.590055ab@elisabeth>
In-Reply-To: <20200319193211.fcv6xg6mtr3t3mez@salvia>
References: <cover.1583438771.git.sbrivio@redhat.com>
        <e6f84fe980f55dde272f7c17e2423390a03e942d.1583438771.git.sbrivio@redhat.com>
        <20200319193211.fcv6xg6mtr3t3mez@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 19 Mar 2020 20:32:11 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> Hi Stefano,
> 
> Sorry for the late response to this one.
> 
> On Thu, Mar 05, 2020 at 09:33:05PM +0100, Stefano Brivio wrote:
> > @@ -223,17 +258,40 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
> >  		d = memcmp(nft_set_ext_key(&rbe->ext),
> >  			   nft_set_ext_key(&new->ext),
> >  			   set->klen);
> > -		if (d < 0)
> > +		if (d < 0) {
> >  			p = &parent->rb_left;
> > -		else if (d > 0)
> > +
> > +			if (nft_rbtree_interval_start(new)) {
> > +				overlap = nft_rbtree_interval_start(rbe) &&
> > +					  nft_set_elem_active(&rbe->ext,
> > +							      genmask);
> > +			} else {
> > +				overlap = nft_rbtree_interval_end(rbe) &&
> > +					  nft_set_elem_active(&rbe->ext,
> > +							      genmask);
> > +			}
> > +		} else if (d > 0) {
> >  			p = &parent->rb_right;
> > -		else {
> > +
> > +			if (nft_rbtree_interval_end(new)) {
> > +				overlap = nft_rbtree_interval_end(rbe) &&
> > +					  nft_set_elem_active(&rbe->ext,
> > +							      genmask);
> > +			} else if (nft_rbtree_interval_end(rbe) &&
> > +				   nft_set_elem_active(&rbe->ext, genmask)) {
> > +				overlap = true;
> > +			}
> > +		} else {
> >  			if (nft_rbtree_interval_end(rbe) &&
> >  			    nft_rbtree_interval_start(new)) {
> >  				p = &parent->rb_left;
> > +  
> 
> Instead of this inconditional reset of 'overlap':
> 
> > +				overlap = false;  
> 
> I think this should be:
> 
>                         if (nft_set_elem_active(&rbe->ext, genmask))
>         			overlap = false;
> 
> if the existing rbe is active, then reset 'overlap' to false.

I think you're right (also for the case just below this), and, if
you're not, then a comment on why I'm not checking it is clearly
needed, because I have a vague memory about the fact we could *perhaps*
skip it in this particular case, and I can't remember that myself :)

I'll fix either problem in v2.

-- 
Stefano

