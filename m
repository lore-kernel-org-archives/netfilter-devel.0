Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41FC2E82CB1
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 16:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjI0Qwl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 12:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjI0Qwl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 12:52:41 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80097DE
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 09:52:39 -0700 (PDT)
Received: from [78.30.34.192] (port=40764 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qlXm6-00DZCn-VI; Wed, 27 Sep 2023 18:52:37 +0200
Date:   Wed, 27 Sep 2023 18:52:34 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 3/3,v2] netlink_linearize: skip set element
 expression in map statement key
Message-ID: <ZRRd0gxC81eoYNSP@calendula>
References: <20230926160216.152549-1-pablo@netfilter.org>
 <ZRMNB+3/4rzYb08p@orbyte.nwl.cc>
 <ZRPq/JMoVffTEDM4@calendula>
 <ZRQNkSG/dnesQ6Wv@orbyte.nwl.cc>
 <ZRQPw+jMI+i9qSyE@calendula>
 <ZRQpodNr/9aiVI7H@orbyte.nwl.cc>
 <ZRQ/DhU558tSxQ/D@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZRQ/DhU558tSxQ/D@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 27, 2023 at 04:41:18PM +0200, Phil Sutter wrote:
> On Wed, Sep 27, 2023 at 03:09:53PM +0200, Phil Sutter wrote:
> > On Wed, Sep 27, 2023 at 01:19:31PM +0200, Pablo Neira Ayuso wrote:
> > > Hi Phil,
> > > 
> > > On Wed, Sep 27, 2023 at 01:10:09PM +0200, Phil Sutter wrote:
[...]
> > > > I actually considered forking the project. Or we just ship a copy of the
> > > > lib with nftables sources?
> > > 
> > > I would try to get back to them to refresh and retry.
> > 
> > Oh well. I'll try an approach which eliminates the pointer if not
> > enabled. The terse feedback and pessimistic replies right from the start
> > convinced me though they just don't want it.
> 
> OK, so I had a close look at the code and played a bit with pahole. My
> approach to avoiding the extra pointer is to add another set of types
> which json_t embed. So taking json_array_t as an example:
> 
> | typedef struct {
> |     json_t json;
> |     size_t size;
> |     size_t entries;
> |     json_t **table;
> | } json_array_t;
> 
> I could introduce json_location_array_t:
> 
> | typedef struct {
> |     json_array_t array;
> |     json_location_t *location;
> | } json_location_array_t;
>
> The above structs are opaque to users, they only know about json_t.

OK, so this new object type is hiding behind the json_t opaque type.

> So I introduced a getter for the location data:
> 
> | int json_get_location(json_t *json, int *line, int *column,
> |                       int *position, int *length);
> 
> In there, I have to map from json_t to the type in question. The problem
> is to know whether I have a json_location_array_t or just a
> json_array_t. The json_t may have been allocated by the input parser
> with either JSON_STORE_LOCATION set or not or by json_array().
>
> In order to make the decision, I need at least a bit in well-known
> memory. Pahole tells there's a 4byte hole in json_t, but it may be
> gone in 32bit builds (and enlarging json_t is a no-go, they consider
> it ABI). The json_*_t structures don't show any holes, and extending
> them means adding a mandatory word due to buffering, so I may just
> as well store the location pointer itself in them.
>
> The only feasible alternative is to store location data separate from
> the objects themselves, ideally in a hash table. This reduces the
> overhead if not used by a failing hash table lookup in json_delete().

If I understood correctly, then this means you are ditching the
json_location_array_t approach that you are detailing above.

The hashtable approach might be sensible to follow, and such approach
does not require any update to libjansson?
