Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BEB017543;
	Sun,  5 Jan 2025 21:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736111422; cv=none; b=czKhSQr6A0warzp+KEKwA6PW0TWFYKjy9GXkaDvGgK2PSaDEHBB3wcoa0z8NSjOW3X/uR5sYWDx/7dLE3wgHvG0crUhCmxsn2HCSSXLbYF2+T0ljer3HvA7DbO7P/p2TKSGKuw6O8SMnEnCThw7tiPhzcepxhuvkRRDPRIq7y1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736111422; c=relaxed/simple;
	bh=aHPljPt8h3pU2n0kbF0r8XQt36idFVN9h/thMj0KMTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UvqTrBzOd2jSx4JaisXPyHsAVEBDB0B1j4CW3gVlthQxF1/F8Vx2lPOVoZrV0Xf9Xav4xz2aL1bgMtu+lnUBF0OVjyBNmSldnJBj6qnDXFQFSt4oawP7OKskuiJRhAqxc+8zi1JkuqZCgGs4oXsjb71LAbDdsftiZdtbxsRSr70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
X-Spam-Level: 
Date: Sun, 5 Jan 2025 22:10:07 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cheung wall <zzqq0103.hey@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: "WARNING in nf_ct_alloc_hashtable" in Linux kernel version
 6.13.0-rc2
Message-ID: <Z3r1L69XacwS0_Ce@calendula>
References: <CAKHoSAtDrR9kkrVZufEYqPoKZpT7WyLC9DH8gCx9cox3oSNPaQ@mail.gmail.com>
 <20250103180150.4c4d1f30220720ba7f1a133b@linux-foundation.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9kpNbaPKe2hx3gvx"
Content-Disposition: inline
In-Reply-To: <20250103180150.4c4d1f30220720ba7f1a133b@linux-foundation.org>


--9kpNbaPKe2hx3gvx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi,

On Fri, Jan 03, 2025 at 06:01:50PM -0800, Andrew Morton wrote:
> On Fri, 3 Jan 2025 17:12:53 +0800 cheung wall <zzqq0103.hey@gmail.com> wrote:
> 
> > Hello,
> > 
> > I am writing to report a potential vulnerability identified in the
> > Linux Kernel version 6.13.0-rc2. This issue was discovered using our
> > custom vulnerability discovery tool.
> > 
> > HEAD commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4 (tag: v6.13-rc2)
> > 
> > Affected File: mm/util.c
> > 
> > File: mm/util.c
> > 
> > Function: __kvmalloc_node_noprof
> 
> (cc netfilter-devel)
> 
> This is
> 
> 	/* Don't even allow crazy sizes */
> 	if (unlikely(size > INT_MAX)) {
> 		WARN_ON_ONCE(!(flags & __GFP_NOWARN));
> 		return NULL;
> 	}
> 
> in __kvmalloc_node_noprof().

Ok, then I assume this is a WARN_ON_ONCE splat.

I'm attaching a patch to address this.

--9kpNbaPKe2hx3gvx
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 8666d733b984..13a2097b56e2 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2516,7 +2516,7 @@ void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
 	BUILD_BUG_ON(sizeof(struct hlist_nulls_head) != sizeof(struct hlist_head));
 	nr_slots = *sizep = roundup(*sizep, PAGE_SIZE / sizeof(struct hlist_nulls_head));
 
-	hash = kvcalloc(nr_slots, sizeof(struct hlist_nulls_head), GFP_KERNEL);
+	hash = kvcalloc(nr_slots, sizeof(struct hlist_nulls_head), GFP_KERNEL | __GFP_NOWARN);
 
 	if (hash && nulls)
 		for (i = 0; i < nr_slots; i++)

--9kpNbaPKe2hx3gvx--
