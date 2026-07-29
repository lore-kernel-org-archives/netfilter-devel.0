Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D13E47ECDF
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 14:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785334791; cv=none; b=aN/UDxKbVFldd80Porg3W5AkoxGzptYJzuJb7Re2O8NHy1g3BGpyx3M9rGTV1E87EB3cGaC9J1ty2EoQhTh+4gs9jhrGRZfL/pGHkj0rPT/o5O+AW9Yl4vXDHUkFNKA7Otn61xPRX/iCCaSCUfHATRxHB6KTI7Q1bepR4C8ZrU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785334791; c=relaxed/simple;
	bh=KjUX/oS3dXqyNyo4ykzCPVpTMh9Z2U6J0sEbNluoT9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q4KJITbIOCM7t1Z9c3+ZAh+wNipuEGDXuIgttsSqBXVG/HlJ8V+pDD42nPr7EPLO8/ELVhBuRcz4iNZwdwLadhlskybAOF3atyjNtNTa6cxqGuTgHFoQJnPzcRwtmgCKBHo/XKE3xRsc6waqnUdbMcoE+MDNrulofnVFyCCrIpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=PA9KmGYd; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="PA9KmGYd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=s/zB8oLqYZWER353yeHtffPCMEgjfxOH0a2KDORsixg=; b=PA9KmGYdy4vGVTKBUL2kPzxdTU
	eBk+/q4zrf8zMnaTZN/nS+VUAghli7G2NWchPT6zvS+0mOdamZH4NDges6e6a5gjod7j9DM6qjg9k
	qDiZ4ktcl8kmnN4jOJANZeCVqwUnkgSsybEDQ8HEP6XafiQmPgycYa05lcvFazH48tDf0ARundvku
	UpgrMqybqk0y41OUVHSAWCYtBi/2YNBJqK9sYbiDJZRH3KNm57STeUyn6beaSCXznde4e8zJDcOnd
	BysL2GURhx2ch8jEp/zzn/AnFrFJ1Gm12SlGJnn9OPVM0mZgnMSq/jlhRKFSA2rKxOjAm3hCuldcj
	a82LfvwA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wp58G-000000002Lr-2mMj;
	Wed, 29 Jul 2026 16:19:40 +0200
Date: Wed, 29 Jul 2026 16:19:40 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Avinash Duduskar <avinash.duduskar@gmail.com>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] datatype: accept a numeric cgroupsv2 id on input
Message-ID: <amoL_B5Y3sC0JCug@orbyte.nwl.cc>
References: <20260727082427.740789-1-avinash.duduskar@gmail.com>
 <amjWjTkt1Dsh66Xv@orbyte.nwl.cc>
 <amkAJuVZmpGy7pvY@chamomile>
 <amnES354HC-zVZJQ@orbyte.nwl.cc>
 <20260729100356.387951-1-avinash.duduskar@gmail.com>
 <amnndnoOMoR05sJK@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amnndnoOMoR05sJK@chamomile>

On Wed, Jul 29, 2026 at 01:43:50PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jul 29, 2026 at 03:33:56PM +0530, Avinash Duduskar wrote:
> > On Wed, Jul 29, 2026 at 11:13:47AM +0200, Phil Sutter wrote:
> > > Is it true that integer_type_parse respects negative values as such?
> > > Because that void avoid the mentioned issue of '-1' becoming '1'.
> > > Negative values would just not match.
> > 
> > No, the sign parses but is dropped on export: "-1" stores as element 1
> > and "-2" then lists as "cgroup.procs". Garbage in, garbage out either
> > way, as you say, so v2 delegates to integer_type_parse().
> > 
> > For the metainfo dump test I will take the jq route, as a follow-up.
> 
> Regarding this misparsing of -1, I think this issue is related to the
> integer parser, which can be revisited in a follow up patch.
> 
> I'd suggest to fix the removal of cgroupsv2 by inode id, then look
> into improving the integer parser.

ACK, this thread is slowly going off-topic. Sorry for exacerbating it.
Avinash, no veto from my side for your proposed v2. Feel free to
formally submit it and anything else will happen as follow-ups.

Thanks, Phil
