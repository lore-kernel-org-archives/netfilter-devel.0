Return-Path: <SRS0=4EdP=WW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D55C3A59F
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Aug 2019 10:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97BEE2187F
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Aug 2019 10:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfHZKbP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Aug 2019 06:31:15 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:44313 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbfHZKbP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Aug 2019 06:31:15 -0400
Received: from [31.4.213.210] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <pablo@gnumonks.org>)
        id 1i2CHD-0006e4-0s; Mon, 26 Aug 2019 12:31:13 +0200
Date:   Mon, 26 Aug 2019 12:31:04 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/2 nf-next v2] netfilter: nf_tables: Introduce stateful
 object update operation
Message-ID: <20190826103104.3nt4jbk6pmrfryuo@salvia>
References: <20190822164827.1064-1-ffmancera@riseup.net>
 <20190823124142.dsmyr3mkwt3ppz3y@salvia>
 <20190823124250.75apok22fnbdhujd@salvia>
 <fc6fe6d4-1efa-6845-f0ee-4e1f1da61da5@riseup.net>
 <20d36122-4d8d-e73f-a5d9-af1642d3a887@riseup.net>
 <20190824162934.sdlrz56out4tzlw7@salvia>
 <1640db44-1d46-e1d9-ab5f-ac66131c66d8@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1640db44-1d46-e1d9-ab5f-ac66131c66d8@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 26, 2019 at 12:16:34PM +0200, Fernando Fernandez Mancera wrote:
> Hi Pablo,
> 
> On 8/24/19 6:29 PM, Pablo Neira Ayuso wrote:
> > On Fri, Aug 23, 2019 at 08:28:46PM +0200, Fernando Fernandez Mancera wrote:
> >> On 8/23/19 8:05 PM, Fernando Fernandez Mancera wrote:
> >>>
> >>>
> >>> On 8/23/19 2:42 PM, Pablo Neira Ayuso wrote:
> >>>> On Fri, Aug 23, 2019 at 02:41:42PM +0200, Pablo Neira Ayuso wrote:
> >>>>> On Thu, Aug 22, 2019 at 06:48:26PM +0200, Fernando Fernandez Mancera wrote:
> >>>>>> @@ -1405,10 +1409,16 @@ struct nft_trans_elem {
> >>>>>>  
> >>>>>>  struct nft_trans_obj {
> >>>>>>  	struct nft_object		*obj;
> >>>>>> +	struct nlattr			**tb;
> >>>>>
> >>>>> Instead of annotatint tb[] on the object, you can probably add here:
> >>>>>
> >>>>> union {
> >>>>>         struct quota {
> >>>>>                 uint64_t                consumed;
> >>>>>                 uint64_t                quota;
> >>>>>       } quota;
> >>>>> };
> >>>>>
> >>>>> So the initial update annotates the values in the transaction.
> >>>>>
> >>
> >> If we follow that pattern then the indirection would need the
> >> nft_trans_phase enum, the quota struct and also the tb[] as parameters
> >> because in the preparation phase we always need the tb[] array.
> > 
> > Right, so this is my next idea :-)
> > 
> > For the update case, I'd suggest you use the existing 'obj' field in
> > the transaction object. The idea would be to allocate a new object via
> > nft_obj_init() from the update path. Hence, you can use the existing
> > expr->ops->init() interface to parse the attributes - I find the
> > existing parsing for ->update() a bit redundant.
> > 
> > Then, from the commit path, you use the new ->update() interface to
> > update the object accordingly taking this new object as input. I think
> > you cannot update u64 quota like you do in this patch. On 32-bit
> > arches, an assignment of u64 won't be atomic. So you have to use
> > atomic64_set() and atomic64_read() to make sure that packet path does
> > not observes an inconsistent state. BTW, once you have updated the
> > existing object, you can just release the object in the transaction
> > coming in this update. I think you will need a 'bool update' field on
> > the transaction object, so the commit path knows how to handle the
> > update.
> > 
> 
> I would need to add a second 'obj' field in the transaction object in
> order to have the existing object pointer and the new one.

Hm, this might be convenient, we might need to swap other objects.

> Also, right now we are not using atomic64_set() when initializing u64
> quota is that a bug then? If it is, I could include a patch fixing it.

No packets see that quota limit by when it is set for first time.

With quota updates, packets are walking over this state while this is
updated from the control plane.
