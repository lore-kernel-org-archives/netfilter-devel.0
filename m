Return-Path: <SRS0=edwS=ZZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D65FC432C0
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Dec 2019 15:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 564AA205ED
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Dec 2019 15:56:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WTpEV3qC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfLCP4x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Dec 2019 10:56:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31619 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726024AbfLCP4x (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Dec 2019 10:56:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575388611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xIi7noPPtiEQxY7qdrwGBQGlXr7rUAxDm/jjZ+vMNos=;
        b=WTpEV3qCr/y2TU2BxlHQWvmSxjce11nez9k5Vv68wm3TanoTugyEx/GVaZWUkz1yg250Wl
        U8u0WcTH8j2q45xoTWEx9ylzHGCzTU9Ny8nfqeVnfHIgw/BKV2EMk7eSQf44PrcPUMsSB/
        xZt2hiQsTKlv6lNflO/HWKU+kwBPWls=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-i1iADWZfPGShuaRHTSHtGw-1; Tue, 03 Dec 2019 10:56:49 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEC10DBF1;
        Tue,  3 Dec 2019 15:56:48 +0000 (UTC)
Received: from elisabeth (ovpn-200-27.brq.redhat.com [10.40.200.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BF9695DA60;
        Tue,  3 Dec 2019 15:56:47 +0000 (UTC)
Date:   Tue, 3 Dec 2019 16:56:42 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH,nf-next RFC 0/2] add NFTA_SET_ELEM_KEY_END
Message-ID: <20191203165642.309b9541@elisabeth>
In-Reply-To: <20191203110254.maczg7zs4wrcg6th@salvia>
References: <20191202131407.500999-1-pablo@netfilter.org>
        <20191202171952.2e577345@elisabeth>
        <20191203110254.maczg7zs4wrcg6th@salvia>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: i1iADWZfPGShuaRHTSHtGw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 3 Dec 2019 12:02:54 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> Hi Stefano,
> 
> On Mon, Dec 02, 2019 at 05:19:52PM +0100, Stefano Brivio wrote:
> [...]
> > On Mon,  2 Dec 2019 14:14:05 +0100
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:  
> [...]
> > > This patchset extends the netlink API to allow to express an interval
> > > with one single element.
> > > 
> > > This simplifies this interface since userspace does not need to send two
> > > independent elements anymore, one of the including the
> > > NFT_SET_ELEM_INTERVAL_END flag.
> > > 
> > > The idea is to use the _DESC to specify that userspace speaks the kernel
> > > that new API representation. In your case, the new description attribute
> > > that tells that this set contains interval + concatenation implicitly
> > > tells the kernel that userspace supports for this new API.  
> > 
> > Thanks! I just had a quick look, I think the new set implementation
> > would indeed look more elegant this way. As to design choices, I'm
> > afraid I'm not familiar enough with the big picture to comment on the
> > general idea, but my uninformed opinion agrees with this approach. :)
> > 
> > For what it's worth, I'd review this in deeper detail next.  
> 
> Thanks.
> 
> > > If you're fine with this, I can scratch a bit of time to finish the
> > > libnftnl part. The nft code will need a small update too. You will not
> > > need to use the nft_set_pipapo object as scratchpad area anymore.  
> > 
> > On my side, I'm almost done with nft/libnftnl/kernel changes for the
> > NFT_SET_DESC_CONCAT thing. How should we proceed? Do you want me to
> > share those patches so that you can add this bit on top, or should this
> > come first, or in a separate series?  
> 
> My suggestion is that you can take them and place them at the
> beginning of your batch since it will be the first client for this new
> netlink attribute, you will have to adapt pipapo to use the new
> key_end value too.

Okay, then I'll adjust the NFT_SET_DESC_CONCAT changes on top of your
changes.

> > I could also just share the new nft/libnftnl patches (I should have them
> > ready between today and tomorrow), and proceed adapting the kernel part
> > according to your changes.  
> 
> I still have to send you the libnftnl part for this.

If that's the order of changes you suggest, yes. Anyway, I guess I can
already proceed adjusting the kernel part meanwhile.

> > Related question: to avoid copying data around, I'm now dynamically
> > allocating a struct nft_data_desc in nf_tables_newset() with a
> > reference from struct nft_set: desc->dlen, desc->klen, desc->size would
> > all live there, together with the "subkey" stuff.
> > 
> > Is it a bad idea? I can undo it easily, I just don't know if there's a
> > specific reason why those fields are repeated in struct nft_set.  
> 
> Not sure I understand, probably some code sketch? From your words it
> does not look like a major issue though, but let me know.

Right now, nf_tables_newset() in nf_tables_api.c has:

	struct nft_set_desc desc;
[...]
	memset(&desc, 0, sizeof(desc));
[...]
	desc.klen = ntohl(nla_get_be32(nla[NFTA_SET_KEY_LEN]));
[and so on]

then values from desc are copied one by one into struct nft_set *set,
later in the same function:

	set->klen  = desc.klen;
	set->dlen  = desc.dlen;
	set->size  = desc.size;

and I don't see the point (well, we avoid one further dereference in
e.g. __nft_rbtree_lookup(), but is that worth it?). As I'm adding two
fields (field_len[] and field_count) to struct nft_set_desc, I would
instead allocate it dynamically:

	struct nlattr *desc;
[...]
	desc = kzalloc(sizeof(*desc), GFP_KERNEL);

fill it:
	desc->klen = ntohl(nla_get_be32(nla[NFTA_SET_KEY_LEN]));
[and so on]

and then store a reference to it in struct nft_set *set:
	set->desc   = desc;

instead of copying fields one by one, and having their declaration
duplicated in struct nft_set and struct nft_set_desc. I can also stick
to the current way, that is, add those fields to both struct nft_set
and struct nft_set_desc, and copy them.

It's mostly a matter of taste, unless there's a specific reason why we
shouldn't point to a struct nft_set_desc from struct nft_set.

> BTW, there is also one more pending issue: I can see there is a clone
> point in nft_set_pipapo, you mentioned some problems to make things
> fit in into the transaction infrastructure. Could you describe how you
> integrate with it?

Currently, there are no problems, and the description of how relevant
operations integrate with the API is in the kerneldoc comments for
nft_pipapo_activate(), _deactivate(), _flush(), _remove(). While the
operations are, per se, conceptually not atomic, atomicity is then
guaranteed by the genmask mechanism.

The problems would start once we want to add some specific
optimisations that rely on the fact there are no (entirely) overlapping
entries in current, live matching data. If we could rely on that, and
we opt to opportunistically coalesce per-field classifier regions, we
can reduce the complexity of some steps. Let's say we have a set
matching, separately, two entries:

 - 192.168.1.1:1024 -> x
 - 192.168.1.1:2048 -> y

then in the classifier region for the IPv4 address field we could
naturally have a single rule, that, if matched, would lead to
evaluation of the port bits against both 1024 and 2048, which would
then map to two different entries.

Let's name:
 - "192.168.1.1" rule #0 for the IPv4 address
 - "1024" rule #0 for the port (mapping to x)
 - "2048" rule #1 for the port (mapping to y)

Then rule #0 for the IPv4 address activates processing of rule #0 and
rule #1 for the port bits, and at each step we select up to one single
rule, that results in up to one single match.

However, we can have this situation:
 - 192.168.1.1:1024 -> x (active element reference)
 - 192.168.1.1:2048 -> y (active element reference)
 - 192.168.1.1:1024 -> z (inactive element reference)

so we need:
 - "1024" rule #0 for the port (mapping to x)
 - "2048" rule #1 for the port (mapping to y)
 - "1024" rule #2 for the port (mapping to z)

and once we have evaluated the port field, we might have n > 1 rules
selected, so we might need to check multiple elements before returning
a match, and this introduces complexity in the fast path. We also need
the nft_set_elem_active() check, which is quite expensive.

I wouldn't introduce this kind of optimisation right now, mostly because
of the complexity it adds for listing and deletion, and I'd rather
prefer the basic implementation to be reasonably mature before
proceeding with this.

In general, I find the current API a bit unnatural. As I mentioned, I
would have expected to implement a single insert operation, a single
delete operation, and a commit routine, instead of five operations that
can't be clearly defined in terms of a typical transaction/commit
model. I think that a clear distinction between insert/delete and
commit would also more naturally fit the publish/subscribe RCU model.

If we had a single commit callback, there couldn't be entirely
overlapping entries in live matching data, because if any such entry is
present in the commit phase, the commit would fail.

On top of that, the flush() operation would actually correspond to its
name.

> Probably there is a chance to extend the front-end
> API too to make it easier for pipapo.

I think that any change going in this direction, whether desirable or
not, is going to be quite invasive. In particular, I would first try to
figure out pros and cons for existing set implementations.

Some set implementations would probably benefit from having a
completely separated copy of matching data where pending operations are
performed. In general, we would be able to skip the
nft_set_elem_active() check in lookup functions, which looks expensive
in case the NFT_SET_MAP flag is not set, because just for that single
check we need to read data quite far away. Inserting elements directly
on live data might also result in some amount of false sharing, but I
wouldn't comment further on that without some actual test results.

In conclusion, I'd rather defer this kind of API change (again, if it
even makes sense) to a later time, I would start with some simplified
implementation to check how existing set types behave with it, and I
don't see any "quick" way to simplify pipapo's operations any further
right now.

-- 
Stefano

