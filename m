Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AF9315F309;
	Mon, 27 May 2024 14:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716821830; cv=none; b=bOD/r2cWjj2t7cNHo0WAdgsm20UexrG68xRsZbR8PNh+LEAZpPqFtX4u0LgzZh3+wIZmhVCDaZXdWoM6Oy2BoOKuZ/c/pjaY6PR5sGlAOOoUhjmes/w1fo0fEaCV1JaZafrG/I3OMfePgD5d+IQZKWWHFMpr8/8F+QvDHWdfaUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716821830; c=relaxed/simple;
	bh=b4utjzmZdkWdzfxNrECx4ATh8uEdmBG28Y4/P1O57VE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uwB5gpPQbVDr6z2wK6FyVfag5CUQnsN5NXZHlWpb13IRh77DNvL4l5+mlgIvGCAPJMp+qMJIWVx606k0Sgfug4LhQY0oodU7ei0CQqR9GPvrBSh+zD8RaMgmYfFQbaIRb5olT71iEVp8DkBsXBSUajcnkQPfzFcybOox7MT0f4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Mon, 27 May 2024 16:56:57 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
	fw@strlen.de
Subject: Re: [PATCH net 0/6,v2] Netfilter fixes for net
Message-ID: <ZlSfOTdWzbDGBgsj@calendula>
References: <20240523162019.5035-1-pablo@netfilter.org>
 <ZlJYT2-sjA8gypwO@calendula>
 <57354e03b78f382e48b3bbc1eeec9dd14c3e940f.camel@redhat.com>
 <63b7281b10c5491fbb02ba3f01328765b88a6271.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <63b7281b10c5491fbb02ba3f01328765b88a6271.camel@redhat.com>

On Mon, May 27, 2024 at 12:12:39PM +0200, Paolo Abeni wrote:
> On Mon, 2024-05-27 at 11:59 +0200, Paolo Abeni wrote:
> > On Sat, 2024-05-25 at 23:29 +0200, Pablo Neira Ayuso wrote:
> > > Hi,
> > > 
> > > On Thu, May 23, 2024 at 06:20:13PM +0200, Pablo Neira Ayuso wrote:
> > > > v2: fixes sparse warnings due to incorrect endianness in vlan mangling fix
> > > >     reported by kbuild robot and Paolo Abeni.
> > > 
> > > I realized checkpatch complains on use of spaces instead of
> > > indentation in patch 4/6.
> > > 
> > > I can repost the series as v3. Apologies for this comestic issue.
> > 
> > I think the overhead of a repost would offset the benefit of cleaning-
> > up that minor format issue.
> 
> I'm sorry for being so self-contradictory in a very short period of
> time, but before I misread the report.
> 
> I think this specific format violation is worth fixing. Could you
> please send a v3?

Sure, preparing a v3. Thanks
