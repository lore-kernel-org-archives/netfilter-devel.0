Return-Path: <SRS0=IqR4=4O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4236AC4BA0E
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 10:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EB6424684
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 10:59:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BFuOtQon"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgBZK7l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Feb 2020 05:59:41 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22011 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726408AbgBZK7l (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 05:59:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582714779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UKElxHorB8g6Kuhk8qytKh/UIQW1yAK/Q8mUeePCXXw=;
        b=BFuOtQongP0NtE6NI3B/4WoYiLBg3AHPHM5eJ+6T3h/HNQ7w44gVLvhsc3MbO3KKTMP9Ol
        gqHHFemicp73yx/I7U3J2DjiqEl5o7dZuwrtwwGerf8E1TkfkEEsMjdZFjThHk6jL+7TAs
        esB5lmIy1hesWGxSKqnSdOFmfI4DBaM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-KfK2MSL1POi3EtxWUTxRjA-1; Wed, 26 Feb 2020 05:59:32 -0500
X-MC-Unique: KfK2MSL1POi3EtxWUTxRjA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9848B101FC70;
        Wed, 26 Feb 2020 10:59:30 +0000 (UTC)
Received: from localhost (ovpn-200-34.brq.redhat.com [10.40.200.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DEC786315B;
        Wed, 26 Feb 2020 10:59:28 +0000 (UTC)
Date:   Wed, 26 Feb 2020 11:59:24 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 0/2] nft_set_pipapo: Fix crash due to dangling
 entries in mapping table
Message-ID: <20200226115924.461f2029@redhat.com>
In-Reply-To: <20200225205847.s5pjjp652unj6u7v@salvia>
References: <20200221211704.GM20005@orbyte.nwl.cc>
        <20200221232218.2157d72b@elisabeth>
        <20200222011933.GO20005@orbyte.nwl.cc>
        <20200223222258.2bb7516a@redhat.com>
        <20200225123934.p3vru3tmbsjj2o7y@salvia>
        <20200225141346.7406e06b@redhat.com>
        <20200225134236.sdz5ujufvxm2in3h@salvia>
        <20200225153435.17319874@redhat.com>
        <20200225202143.tqsfhggvklvhnsvs@salvia>
        <20200225213815.3c0a1caa@redhat.com>
        <20200225205847.s5pjjp652unj6u7v@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/_zO+M7nx1OnCMew0Hx3YC2a"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--MP_/_zO+M7nx1OnCMew0Hx3YC2a
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, 25 Feb 2020 21:58:47 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Tue, Feb 25, 2020 at 09:38:15PM +0100, Stefano Brivio wrote:
> > On Tue, 25 Feb 2020 21:21:43 +0100
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >   
> > > Hi Stefano,
> > > 
> > > On Tue, Feb 25, 2020 at 03:34:35PM +0100, Stefano Brivio wrote:
> > > [...]  
> > > > This is the problem Phil reported:    
> > > [...]  
> > > > Or also simply with:
> > > > 
> > > > # nft add element t s '{ 20-30 . 40 }'
> > > > # nft add element t s '{ 25-35 . 40 }'
> > > > 
> > > > the second element is silently ignored. I'm returning -EEXIST from
> > > > nft_pipapo_insert(), but nft_add_set_elem() clears it because NLM_F_EXCL
> > > > is not set.
> > > > 
> > > > Are you suggesting that this is consistent and therefore not a problem?    
> > > 
> > >                         NLM_F_EXCL      !NLM_F_EXCL
> > >         exact match       EEXIST             0 [*]
> > >         partial match     EEXIST           EEXIST
> > > 
> > > The [*] case would allow for element timeout/expiration updates from
> > > the control plane for exact matches.  
> > 
> > A-ha. I didn't even consider that.
> >   
> > > Note that element updates are not
> > > supported yet, so this check for !NLM_F_EXCL is a stub. I don't think
> > > we should allow for updates on partial matches
> > > 
> > > I think what it is missing is a error to report "partial match" from
> > > pipapo. Then, the core translates this "partial match" error to EEXIST
> > > whether NLM_F_EXCL is set or not.  
> > 
> > Yes, given what you explained, I also think it's the case.
> >   
> > > Would this work for you?  
> > 
> > It would. I need to write a few more lines in nft_pipapo_insert(),
> > because right now I don't have a special case for "entirely
> > overlapping". Something on the lines of:
> > 
> > 	dup = pipapo_get(net, set, start, genmask);
> > 	if (PTR_ERR(dup) == -ENOENT) {
> >   
> > -->		compare start and end key for this entry with  
> > 		start and end key from 'ext'
> > 
> > Let me know if you want me to post a patch with a placeholder for
> > whatever you have in mind, or if I can help implementing this, etc.  
> 
> Please, go ahead with the placeholder, it might be faster. I'll jump
> on it.

Attached, reasonably tested, the placeholder is 'return -ENOTTY':

# nft add table t
# nft add set t s '{ type ipv4_addr . ipv4_addr ; flags interval ; }'
# nft add element t s '{ 1.1.1.1-2.2.2.2 . 3.3.3.3 }'
# nft add element t s '{ 1.1.1.1-2.2.2.3 . 3.3.3.3 }'
Error: Could not process rule: Inappropriate ioctl for device
add element t s { 1.1.1.1-2.2.2.3 . 3.3.3.3 }
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

One detail, unrelated to this patch, that I should probably document in
man pages and Wiki (I forgot, it occurred to me while testing): it is
allowed to insert an entry if a proper subset of it, with no
overlapping bounds, is already inserted. The reverse sequence is not
allowed. This can be used without ambiguity due to strict guarantees
about ordering. That is:

# nft add element t s '{ 1.0.0.20-1.0.0.21 . 3.3.3.3 }'
# nft add element t s '{ 1.0.0.10-1.0.0.100 . 3.3.3.3 }'
# nft list table ip t
table ip t {
	set s {
		type ipv4_addr . ipv4_addr
		flags interval
		elements = { 1.0.0.20/31 . 3.3.3.3,
			     1.0.0.10-1.0.0.100 . 3.3.3.3 }
	}
}

But:

# nft add element t s '{ 1.0.0.10-1.0.0.100 . 3.3.3.3 }'
# nft add element t s '{ 1.0.0.20-1.0.0.21 . 3.3.3.3 }'
Error: Could not process rule: Inappropriate ioctl for device
add element t s { 1.0.0.20-1.0.0.21 . 3.3.3.3 }
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This is because least generic entries are only allowed to be added
after more generic ones, and match in that order.

-- 
Stefano

--MP_/_zO+M7nx1OnCMew0Hx3YC2a
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=pipapo_overlap_placeholder.patch

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 4fc0c924ed5d..fc5e347bfeba 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1098,21 +1098,41 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	struct nft_pipapo_field *f;
 	int i, bsize_max, err = 0;
 
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END))
+		end = (const u8 *)nft_set_ext_key_end(ext)->data;
+	else
+		end = start;
+
 	dup = pipapo_get(net, set, start, genmask);
-	if (PTR_ERR(dup) == -ENOENT) {
-		if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END)) {
-			end = (const u8 *)nft_set_ext_key_end(ext)->data;
-			dup = pipapo_get(net, set, end, nft_genmask_next(net));
-		} else {
-			end = start;
+	if (!IS_ERR(dup)) {
+		/* Check if we already have the same exact entry */
+		const struct nft_data *dup_key, *dup_end;
+
+		dup_key = nft_set_ext_key(&dup->ext);
+		if (nft_set_ext_exists(&dup->ext, NFT_SET_EXT_KEY_END))
+			dup_end = nft_set_ext_key_end(&dup->ext);
+		else
+			dup_end = dup_key;
+
+		if (!memcmp(start, dup_key->data, sizeof(*dup_key->data)) &&
+		    !memcmp(end, dup_end->data, sizeof(*dup_end->data))) {
+			*ext2 = &dup->ext;
+			return -EEXIST;
 		}
+
+		return -ENOTTY;
+	}
+
+	if (PTR_ERR(dup) == -ENOENT) {
+		/* Look for partially overlapping entries */
+		dup = pipapo_get(net, set, end, nft_genmask_next(net));
 	}
 
 	if (PTR_ERR(dup) != -ENOENT) {
 		if (IS_ERR(dup))
 			return PTR_ERR(dup);
 		*ext2 = &dup->ext;
-		return -EEXIST;
+		return -ENOTTY;
 	}
 
 	/* Validate */

--MP_/_zO+M7nx1OnCMew0Hx3YC2a--

