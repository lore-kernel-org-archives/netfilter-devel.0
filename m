Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2107E2BCFC;
	Fri,  6 Mar 2026 12:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772799775; cv=none; b=KPGomIc9QDhaiNVfA21Ra/+BNq1BV7shtClULd8BdB/rph+l8Y79HANANXI5sJlk7VoRapMZiSqlaLiBHi9RoNLAkgG9fTvV3frm60ChcQ2tFqcwyGxx4tJmd1UAfqIYhTiUFPC4vS1C2bS/lO9GK3tzGOGUeTMdUeeB65jKa24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772799775; c=relaxed/simple;
	bh=kXcegM4gjoj+B56EEf+aN41Lvez+9o32O1SEc1Ni4ls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GYJZjmLnTlzIBGaTVOTgANsjAL+WZv+mbSRIK0kV1IfjmKLvipvan1qW638GAAvq4pcILI5rY23sBxRIn6jHQOxs10hM4GwtmWdn+x0k5wroCxhe6sE5+RLurtedVfvIMou30186PMfkCvelMUHdFt6EcACGi1tglfAeDvRsN5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=N1NkhnUP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="N1NkhnUP"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id BC716602CA;
	Fri,  6 Mar 2026 13:22:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1772799763;
	bh=5PMSAtHMCOGTx0PCXWOxoZwmY9/tarHRvAGNLbxnpbQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N1NkhnUPdqryLaz8VSDAZxfFOTY9vpZOrdQEQgU/HYviz7b8dZZfdsBNPHuyzgsPl
	 K5K4PvWV/u3oTtmWfwzpn2aiGzfKuYT5Uk+EavnRYe9FZCcZBBl4MlAUsRI7o4LUVc
	 neTLKoqu99mvP4VOU54NIWNiO3h2bidI+O1X77mXa+A/MTfXGhWveKxTewNJPP6mmM
	 Di1QmTkR/tbZUK7PKehZgKyPJlV/otVI/gnSCCyw2dpeKHbnJHOQrlPTIggCIer0EG
	 oTywanZBVpXbXpFP09kuq0r41YtluFes/32hlOuNkzUeQReuFz7uFEptorXQk8CYO1
	 AKpEmqPI+JiyQ==
Date: Fri, 6 Mar 2026 13:22:41 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Chris Arges <carges@cloudflare.com>
Cc: Florian Westphal <fw@strlen.de>, stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, lwn@lwn.net,
	jslaby@suse.cz, kernel-team@cloudflare.com,
	netfilter-devel@vger.kernel.org
Subject: Re: [REGRESSION] 6.18.14 netfilter/nftables consumes way more memory
Message-ID: <aarHEfdMXDJ-Wq3V@chamomile>
References: <aahw_h5DdmYZeeqw@20HS2G4>
 <aaijcrM5Ke5-Zabx@chamomile>
 <aaij0XAgYRN40QdD@chamomile>
 <aamvQTTZu4-chpsS@20HS2G4>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Fow/fMevRuhir0mB"
Content-Disposition: inline
In-Reply-To: <aamvQTTZu4-chpsS@20HS2G4>


--Fow/fMevRuhir0mB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Chris,

On Thu, Mar 05, 2026 at 10:28:49AM -0600, Chris Arges wrote:
> I noticed after I sent, thanks for fixing.
> > Hi,
> > 
> > On Wed, Mar 04, 2026 at 11:50:54AM -0600, Chris Arges wrote:
> > > Hello,
> > > 
> > > We've noticed significant slab unreclaimable memory increase after upgrading
> > > from 6.18.12 to 6.18.15. Other memory values look fairly close, but in my
> > > testing slab unreclaimable goes from 1.7 GB to 4.9 GB on machines.
> > 
> > From where are you collecting these memory consumption numbers?
> > 
> 
> These numbers come from the cgroup's memory.stat:
> ```
> $ cat /sys/fs/cgroup/path/to/service/memory.stat | grep slab
> slab_reclaimable 35874232
> slab_unreclaimable 5343553056
> slab 5379427288
> ```
> 
> > > Our use case is having nft rules like below, but adding them to 1000s of
> > > network namespaces. This is essentially running `nft -f` for all these
> > > namespaces every minute.
> > 
> > Those numbers for only 1000? That is too little number of entries for
> > such increase in memory usage that you report.
> > 
> 
> For this workload that I suspect (since its in the cgroup) it has the following
> characteristics:
> - 1000s of namespaces
> - 1000s of CIDRs in ip list per namespace
> - Updating everything frequently (<1m)

I see what is going on, my resize logic is not correct. This is
increasing the size for each new transaction, then the array is
getting larger and larger on each transaction update.

Could you please give a try to this patch?

Thanks.

--Fow/fMevRuhir0mB
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="fix.patch"

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 853ff30a208c..4462ac48fdfa 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -646,7 +646,7 @@ static int nft_array_may_resize(const struct nft_set *set)
 	struct nft_array *array;
 
 	if (!priv->array_next) {
-		array = nft_array_alloc(nelems + NFT_ARRAY_EXTRA_SIZE);
+		array = nft_array_alloc(nelems);
 		if (!array)
 			return -ENOMEM;
 

--Fow/fMevRuhir0mB--
