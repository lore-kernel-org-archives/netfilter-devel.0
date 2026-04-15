Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFC0199FAB
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 14:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776264190; cv=none; b=VbJRbuO7cMBJyBUJ9TLZ9C1O/iCenaeO5HjNsBzAzoW7WlvroAQqWSTd4SUtnaiuwYb/U7eHbHu65nQPvUdhad9ps99KQ1ZfH2eLlgxygR1UIrlV8B1hwpg47M/xUNSuAoYWEppDDRhxjzDQMMnIcecyXJpBL2UJllnaQaxTkXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776264190; c=relaxed/simple;
	bh=gO9LghzNSNvQPuJKSpRfW8Iem+en2fzkZjygbU3URTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O89RvM8xmTwWiUCYEtsxof8OfURBQm9D6wBmFUsTD+zEHXMVy+fASGzrKSYZ5As2FTyTJHbkDJnbZh1WTZwvAS5l3qcZmt3JUkZGkEwulWDtmMGawx5asVPgksqKJDc5Ps/j9/6Yr4SInq8GO9Y7HF3sHJdCUxvfYkxiK+Jiw/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D4BD560490; Wed, 15 Apr 2026 16:43:06 +0200 (CEST)
Date: Wed, 15 Apr 2026 16:43:06 +0200
From: Florian Westphal <fw@strlen.de>
To: Vladimir Vdovin <deliran@verdict.gg>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	coreteam@netfilter.org, phil@nwl.cc
Subject: Re: [PATCH nf-next] netfilter: nf_conncount: make number of hash
 slots configurable
Message-ID: <ad-j-nLF-2TvicY9@strlen.de>
References: <20260413123712.42993-1-deliran@verdict.gg>
 <adz9CyDXi2wSwvjM@strlen.de>
 <DHTRLCVFNCOG.3VDTTB7NRAZFX@verdict.gg>
 <ad-WSA87e6Ukfi3M@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad-WSA87e6Ukfi3M@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Vladimir Vdovin <deliran@verdict.gg> wrote:
> > > Maybe change the code to size the array dynamically
> > > based on e.g. number of online cpus?
> > Hi Florian,
> > 
> > May be we could move it to module params?
> > (not sure that this params have to depend on number of cpu)
> > May be use number of cpus as default value?
> 
> I would prefer autotuning based on online cpus so this doesn't have to
> be changed at all.

And we should also do something like this.
As-is, different netns will block same slot if the key is the same.
As OVS uses conntrack zones and those can easily overlap, they hash
to same slot internally even if they use different data structures
and could run in parallel.

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 00eed5b4d1b1..ab28b47395bd 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -58,6 +58,7 @@ static spinlock_t nf_conncount_locks[CONNCOUNT_SLOTS] __cacheline_aligned_in_smp
 
 struct nf_conncount_data {
 	unsigned int keylen;
+	u32 initval;
 	struct rb_root root[CONNCOUNT_SLOTS];
 	struct net *net;
 	struct work_struct gc_work;
@@ -65,7 +66,6 @@ struct nf_conncount_data {
 	unsigned int gc_tree;
 };
 
-static u_int32_t conncount_rnd __read_mostly;
 static struct kmem_cache *conncount_rb_cachep __read_mostly;
 static struct kmem_cache *conncount_conn_cachep __read_mostly;
 
@@ -496,7 +496,7 @@ count_tree(struct net *net,
 	struct nf_conncount_rb *rbconn;
 	unsigned int hash;
 
-	hash = jhash2(key, data->keylen, conncount_rnd) % CONNCOUNT_SLOTS;
+	hash = jhash2(key, data->keylen, data->initval) % CONNCOUNT_SLOTS;
 	root = &data->root[hash];
 
 	parent = rcu_dereference_raw(root->rb_node);
@@ -630,8 +630,6 @@ struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int keylen
 	    keylen == 0)
 		return ERR_PTR(-EINVAL);
 
-	net_get_random_once(&conncount_rnd, sizeof(conncount_rnd));
-
 	data = kmalloc_obj(*data);
 	if (!data)
 		return ERR_PTR(-ENOMEM);
@@ -641,6 +639,7 @@ struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int keylen
 
 	data->keylen = keylen / sizeof(u32);
 	data->net = net;
+	data->initval = get_random_u32();
 	INIT_WORK(&data->gc_work, tree_gc_worker);
 
 	return data;
