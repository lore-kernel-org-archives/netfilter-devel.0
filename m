Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C615159565
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Oct 2024 10:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728037820; cv=none; b=tMxbCs4E+8fdVMscsVBGuyadqNb9rYQXca3uXMokiD7mqifPxsV+aNZd9QX7dMJW1odjTyRHwsaFhB1qdAMPtFpb/wq6U/qPQ8p7v9+0hZNePpYM3KO/BtGolLBClQel2zVmuDiiQvOpLPUhIjfGZkFYUPu5u/a1ws/BXPc0phs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728037820; c=relaxed/simple;
	bh=hh1yIlzGXXxoQQ04PCYvd7k2KZBsi2kEUhi+D9EU0gs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NdO+HHnzr97Zamc3Zlt1C5zRCXJGfpL4N9Q7vq9aY1gHINIAUKbx2i5LGajgTsb8NT58C1atZbaFb8/POxQd495X2KqNpT6+KlcrdXLPxXJl0Mizhpy+P2Oh2wQ2R8hULxb0EnccSuahjxdyNTjow35OS53yTRCP16C2BQRgHqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=53964 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1swfZZ-00F7Pa-0V; Fri, 04 Oct 2024 12:30:10 +0200
Date: Fri, 4 Oct 2024 12:30:08 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <ej@inai.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	syzbot+256c348558aa5cf611a9@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: xt_cluster: enable ebtables operation?
Message-ID: <Zv_DsCw1P0UcQvCU@calendula>
References: <20241003183053.8555-1-fw@strlen.de>
 <0n89n176-p660-1953-3sn7-0q4rn8359sso@vanv.qr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0n89n176-p660-1953-3sn7-0q4rn8359sso@vanv.qr>
X-Spam-Score: -1.9 (-)

On Thu, Oct 03, 2024 at 08:50:12PM +0200, Jan Engelhardt wrote:
> 
> On Thursday 2024-10-03 20:30, Florian Westphal wrote:
> >
> >Module registers to NFPROTO_UNSPEC, but it assumes ipv4/ipv6 packet
> >processing.  As this is only useful to restrict locally terminating
> >TCP/UDP traffic, reject non-ip families at rule load time.
> >
> >@@ -124,6 +124,14 @@ static int xt_cluster_mt_checkentry(const struct xt_mtchk_param *par)
> > 	struct xt_cluster_match_info *info = par->matchinfo;
> > 	int ret;
> > 
> >+	switch (par->family) {
> >+	case NFPROTO_IPV4:
> >+	case NFPROTO_IPV6:
> >+		break;
> >+	default:
> >+		return -EAFNOSUPPORT;
> >+	}
> 
> I wonder if we could just implement the logic for it.
> Like this patch [untested!]:

Thanks, I considered this too, I don't think it is worth to support
this for ebtables, I don't have a use case for this.
