Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9577E4438B
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 22:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756334062; cv=none; b=r9lHV0R07btVJi/QFINpdxS7hg7WDlsxMZmnDoH73wxUqMdsMEjoeTiHzuJAm9XOE2bpPZJ8cMGZqgBFrPTpPRQ5oyMQOj3PVll9qWhPNIXRukewcYwuqUgZDh5lCdAJ2ic5z0F1llx3r7VmwDUQy28eAk8GVHX7EptRYyB0dw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756334062; c=relaxed/simple;
	bh=tQSlb7O6f2mPIaCXhP6G+aYk7pHQ7HNfbutUWSpS780=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QZFCniITAhKdXik1T9KuuNiessh9lIcdjX9Cf5MzvliBam25my1CTxeGnyP9ToM4pkgVXgrqEkt1qlqZYrMdGMw8qOXaTCUMI+K2X3CAL7TrkJP/CKDyWvBpPflzmu+TPvV42VyKYPFCv4dIw8nCxTTlbSRcQHyqex+QA4BJRnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pYhKwC9w; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=G8IMROwv; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pYhKwC9w";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="G8IMROwv"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id BDE5D607B4; Thu, 28 Aug 2025 00:34:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756334058;
	bh=YQTdlFPkumEjHBosU9sUmPwkPNReiRH3Xawc1ZcWHX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pYhKwC9wDWO1LqX0uhX81CdWHV8ljHuSqswMqiWpZtpbdSEb70dHNrjNeQ7IJ3DVg
	 IMnd58PbhoZiIU0MyHhUJdkoDb+xb6NQsDzMwynIMNaYDJIGJZbFGjyLhDfO9x8WbZ
	 AJqb85mHoSS57WtR7PnuXJ3f+QlhIXlOqkBvNMOlfo2I3hjSuN3BqKPNjxrVpd6m1w
	 bjPG1XF2v4Y6p8TUfL6yuEnyl4J+uFiXWrYec66licsrlJybeFQwb7MTKjAbc0RPdI
	 Tu0hVgpDeJqWKFn72PT05ZM+pc2O8JZLepAifEPCEksSWgFTn5iQwBucFjtIOLUWXD
	 pZ92LXt5nx4YQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6C449607B0;
	Thu, 28 Aug 2025 00:34:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756334057;
	bh=YQTdlFPkumEjHBosU9sUmPwkPNReiRH3Xawc1ZcWHX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G8IMROwvNCb79Ig2SzIU7E0WqY9OfYErm/kbMSlMxwWK3FJytwsCl61NyCa1BGBtw
	 v6uOTQaYmY91yy08wEZsKU4H9fUwZcw0r7VAvFjgTerPPYoLLrs6XG0k82O2RM+DRG
	 WVB66UPgsyJLliw1BP8yBcXb+1FAVVDJctMIJOCYuCWixes0G+nuVysIU+UmZHAU0a
	 lv1pO2VmlTb/gr/xgp7c1mdMZvhp0Zv17n+j1Ggl4C04oOE1Vhzn5LTYoAB/TfHqzp
	 LHl3g4DpFRP7Th/So78JEL9DZhxsp7IJxxnmd545hgnUhfuYYumhHTNMnixfMfKUMv
	 N4v+WF1dSYj6Q==
Date: Thu, 28 Aug 2025 00:34:15 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Yi Chen <yiche@redhat.com>
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	fw@strlen.de
Subject: Re: [conntrack-tools PATCH] nfct: helper: Extend error message for
 EEXIST
Message-ID: <aK-H5xydGbsYIvBU@calendula>
References: <20250815155750.21583-1-phil@nwl.cc>
 <CAJsUoE2zCJYSvm9_=784BtH26GsRDJGBTn8930wW4ZSU8nTjYA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJsUoE2zCJYSvm9_=784BtH26GsRDJGBTn8930wW4ZSU8nTjYA@mail.gmail.com>

On Mon, Aug 18, 2025 at 11:47:08AM +0800, Yi Chen wrote:
> This patch adds a hint when:
> 
> # modprobe nf_conntrack_ftp
> # nfct helper del ftp inet tcp
> # nfct helper add ftp inet tcp
> *nfct v1.4.8: netlink error: File exists*
> 
> or other type of helper.

This patch changes EEXIST by EBUSY:

  https://patchwork.ozlabs.org/project/netfilter-devel/patch/20250818112220.26641-1-phil@nwl.cc/

This userspace patch is not very useful after this.

So maybe a follow up fix to retain EEXIST for nfnetlink_cthelper in
the kernel is needed?

I mean, return EEXIST in nfnetlink_cthelper but EBUSY in case of
insmod, ie. add a bool insmod flag to the helper register/unregister
functions to return EBUSY for insmod and EEXIST for
nfnetlink_cthelper.
