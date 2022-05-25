Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 120C8C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 May 2022 12:15:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242711AbiEYMPX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 May 2022 08:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234608AbiEYMPX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 May 2022 08:15:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 62B012C67B
        for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2022 05:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653480914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3h9LTTxuGSB2e8s2hP2vQh5IAvIKf6jvtfBoPsPuiU4=;
        b=ZKXE54sn6+xItrYe2H+RrTDQCC7ekVPKswq7+o3ufx5xRoq4eGWWMh4IhAn+zYjpRgsoOC
        udg09vHvPhsIcuu9sZa60OBkjodZQOl6fQfuJYqFPV6bqHeyz9WS99lE7seh/6jdK6kACJ
        vzqnnXNE+DXk6PasfacvIK/mxQ8XRZ0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-MG_lGCScOCOeaCJ-HGN3ew-1; Wed, 25 May 2022 08:15:11 -0400
X-MC-Unique: MG_lGCScOCOeaCJ-HGN3ew-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B54EF811E7A;
        Wed, 25 May 2022 12:15:10 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 601D48287E;
        Wed, 25 May 2022 12:15:10 +0000 (UTC)
Date:   Wed, 25 May 2022 14:15:07 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_rbtree: Move clauses for expired nodes, last
 active node as leaf
Message-ID: <20220525141507.69c37709@elisabeth>
In-Reply-To: <YouhUq09zfcflOnz@salvia>
References: <20220512183421.712556-1-sbrivio@redhat.com>
        <YoKVFRR1gggECpiZ@salvia>
        <20220517145709.08694803@elisabeth>
        <20220520174524.439b5fa2@elisabeth>
        <YouhUq09zfcflOnz@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 23 May 2022 16:59:30 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Fri, May 20, 2022 at 05:45:24PM +0200, Stefano Brivio wrote:
> > On Tue, 17 May 2022 14:57:09 +0200
> > Stefano Brivio <sbrivio@redhat.com> wrote:
> >  =20
> > > On Mon, 16 May 2022 20:16:53 +0200
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >  =20
> > > > Hi Stefano,
> > > >=20
> > > > On Thu, May 12, 2022 at 08:34:21PM +0200, Stefano Brivio wrote:   =
=20
> > > > > In the overlap detection performed as part of the insertion opera=
tion,
> > > > > we have to skip nodes that are not active in the current generati=
on or
> > > > > expired. This was done by adding several conditions in overlap de=
cision
> > > > > clauses, which made it hard to check for correctness, and debug t=
he
> > > > > actual issue this patch is fixing.
> > > > >=20
> > > > > Consolidate these conditions into a single clause, so that we can
> > > > > proceed with debugging and fixing the following issue.
> > > > >=20
> > > > > Case b3. described in comments covers the insertion of a start
> > > > > element after an existing end, as a leaf. If all the descendants =
of
> > > > > a given element are inactive, functionally, for the purposes of
> > > > > overlap detection, we still have to treat this as a leaf, but we =
don't.
> > > > >=20
> > > > > If, in the same transaction, we remove a start element to the rig=
ht,
> > > > > remove an end element to the left, and add a start element to the=
 right
> > > > > of an existing, active end element, we don't hit case b3. For exa=
mple:
> > > > >=20
> > > > > - existing intervals: 1-2, 3-5, 6-7
> > > > > - transaction: delete 3-5, insert 4-5
> > > > >=20
> > > > > node traversal might happen as follows:
> > > > > - 2 (active end)
> > > > > - 5 (inactive end)
> > > > > - 3 (inactive start)
> > > > >=20
> > > > > when we add 4 as start element, we should simply consider 2 as
> > > > > preceding end, and consider it as a leaf, because interval 3-5 ha=
s been
> > > > > deleted. If we don't, we'll report an overlap because we forgot a=
bout
> > > > > this.
> > > > >=20
> > > > > Add an additional flag which is set as we find an active end, and=
 reset
> > > > > it if we find an active start (to the left). If we finish the tra=
versal
> > > > > with this flag set, it means we need to functionally consider the
> > > > > previous active end as a leaf, and allow insertion instead of rep=
orting
> > > > > overlap.     =20
> > > >=20
> > > > I can still trigger EEXIST with deletion of existing interval. It
> > > > became harder to reproduce after this patch.
> > > >=20
> > > > After hitting EEXIST, if I do:
> > > >=20
> > > >         echo "flush ruleset" > test.nft
> > > >         nft list ruleset >> test.nft
> > > >=20
> > > > to dump the existing ruleset, then I run the delete element command
> > > > again to remove the interval and it works. Before this patch I could
> > > > reproduce it by reloading an existing ruleset dump.
> > > >=20
> > > > I'm running the script that I'm attaching manually, just one manual
> > > > invocation after another.   =20
> > >=20
> > > Ouch, sorry for that.
> > >=20
> > > It looks like there's another case where inactive elements still affe=
ct
> > > overlap detection in an unexpected way... at least with the structure
> > > of this patch it should be easier to find, I'm looking into that now.=
 =20
> >=20
> > ...what a mess. I could figure that part out (it was a case symmetric
> > to what this patch fixed, in this case resolving to case b5.) but
> > there's then another case (found by triggering a specific tree topology
> > with 0044interval_overlap_1) where we first add a start element, then
> > fail to add the end element because the start element is completely
> > "hidden" in the tree by inactive nodes.
> >=20
> > I tried to solve that with some backtracking, but that looks also
> > fragile. If I clean up the tree before insertion, instead, that will
> > only deal with expired nodes, not inactive nodes -- I can't erase
> > non-expired, inactive nodes because the API expects to find them at
> > some later point and call nft_rbtree_remove() on them.
> >=20
> > Now I'm trying another approach that looks more robust: instead of
> > descending the tree to find overlaps, just going through it in the same
> > way nft_rbtree_gc() does (linearly, node by node), marking the
> > value-wise closest points from left and right _valid_ nodes, and
> > applying the same reasoning. I need a bit more time for this, but it
> > looks way simpler. Insertion itself would keep working as it does now.
> >=20
> > In hindsight, it looks like it was a terrible idea to try to fix this
> > implementation. I really underestimated how bad this is. Functionally
> > speaking, it's not a red-black tree because:
> >=20
> > - we can't use it as a sorted binary tree, given that some elements
> >   "don't matter" for some operations, or have another colour. We might
> >   try to think of it as some other structure and rebuild from there
> >   useful properties of sorted binary trees, but I'm not sure a
> >   "red-brown-black" tree would have any other use making it worth of
> >   any further research
> >=20
> > - end elements being represented as their value plus one also break
> >   assumptions of sorted trees (this is the issue I'm actually facing
> >   with backtracking)
> >=20
> > - left subtrees store keys greater than right subtrees, but this
> >   looks consistent so it's just added fun and could be fixed
> >   trivially (it's all reversed)
> >=20
> > By the way, I think we _should_ have similar issues in the lookup
> > function. Given that it's possible to build a tree with a subtree of at
> > least three levels with entirely non-valid nodes, I guess we can hide a
> > valid interval from the lookup too. It's just harder to test. =20
>=20
> Thanks for the detailed report.
>=20
> Another possibility? Maintain two trees, one for the existing
> generation (this is read-only) and another for the next generation
> (insertion/removals are performed on it), then swap them when commit
> happens?

It sounded like a good idea and I actually started sketching it, but
there's one fundamental issue: it doesn't help with overlap detection
because we also want to check insertions that will be part of the live
copy. If, within one transaction, you delete and create elements, the
"dirty" copy is still dirty for the purposes of overlaps.

For the lookup, that might help. Is it worth it right now, though? At
the moment I would go back and try to get overlap detection work
properly, at least, with my previous idea.

> pipapo has similar requirements, currently it is relying on a
> workqueue to make some postprocess after the commit phase. At the
> expense of consuming more memory.

Well, it keeps two copies already: all the insertions and removals are
done on the dirty copy. The two problems we have there are:

- the clean copy might also contain inactive elements (because on a
  "commit" operation the API doesn't guarantee that all inserted
  elements are active), so we need to check for those during lookup,
  which is quite heavy (in my tests that was 4% of the clock cycles
  needed for lookup in a set with 30 000 "port, protocol" entries)

- on every _activate() call, we also need to commit the dirty copy onto
  a clean one, instead of having one commit per transaction (because if
  there's a newly activated item, we need to see it from the lookup),
  so every transaction translates to a number of commit operations for
  the back-end.

  That also makes things a bit complicated and it might very well be
  related to point 3. below

...there's no actual workqueue: garbage collection (for timed out
entries) only happens on commit, I don't see a particular problem with
it.

I think both issues would be solved if we had a more natural API, that
is, having a single call to the back-end implementing a commit
operation, instead of separately activating single entries. I don't
know how complicated this change would be.

=46rom a set back-end perspective it looks trivial (pipapo would be
greatly simplified, hash would also need to keep two copies but we
would remove some complexity by getting rid of some checks).

> > In the perspective of getting rid of it, I think we need:
> >=20
> > 1. some "introductory" documentation for nft_set_pipapo -- I just
> >    got back to it (drawing some diagrams first...)
> >=20
> > 2. to understand if the performance gap in the few (maybe not
> >    reasonable) cases where nft_set_rbtree matches faster than
> >    nft_set_pipapo is acceptable. Summary:
> >      https://lore.kernel.org/netfilter-devel/be7d4e51603633e7b88e4b0dde=
54b25a3e5a018b.1583598508.git.sbrivio@redhat.com/ =20
>=20
> IIRC pipapo was not too far behind from rbtree for a few scenarios.

Perhaps it would be good enough (minus points 1. and 3. here) to start
offering it as a default option (the change is trivial, setting
NFT_PIPAPO_MIN_FIELDS to 1) and see if regressions are reported (actually,
I doubt it).

> > 3. a solution for https://bugzilla.netfilter.org/show_bug.cgi?id=3D1583,
> >    it's an atomicity issue which has little to do with nft_set_pipapo
> >    structures themselves, but I couldn't figure out the exact issue
> >    yet. I'm struggling to find the time for it, so if somebody wants to
> >    give it a try, I'd be more than happy to reassign it... =20
>=20
> OK, a different problem, related to pipapo.

Yes, I included it here because I wouldn't offer pipapo as rbtree
replacement as long as that issue is there.

--=20
Stefano

