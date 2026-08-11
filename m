Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AB53B71C5;
	Tue, 11 Aug 2026 10:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786445366; cv=none; b=rPWEs9jhRkVIwTOSD/wuJ1zgyr6x0KPeBVkg4+ZJBtcCsccw2Fks8Q+Keht2k7Co86OV2RoVsVxz/O3966R+I4g4rpZDCcWQv1hkkprcCts05kSfH7XziLaEplC6yv3pwuAqqoniJ0jRJaVnI8CWfkv1j+YzLSbPBQvPfyZTmS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786445366; c=relaxed/simple;
	bh=irp/DMMQZM7IMe5fqnLNYtQUZtbJpxdl9oqnr58z160=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fSz90muR58O1e1oglwWJWkhZ+vznnwH3woadBaADw/jGVZS2bPbW27AUyhbUEsJDJuScva4mDGEstB5EtU3FfAQ0RAmoaPNLCCuvUWwoxU7bCIEuv2h5kOJ6WASLatAZxD01o3pmbHHJJ7MmsXeOcPfwo0oEd3kXIEJHrmOX+GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 043B860291; Tue, 11 Aug 2026 12:49:21 +0200 (CEST)
Date: Tue, 11 Aug 2026 12:49:21 +0200
From: Florian Westphal <fw@strlen.de>
To: Wei Fang <void0red@gmail.com>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, k.chen@smail.nju.edu.cn
Subject: Re: [nf_tables] pipapo: inserting an interval that strictly contains
 an existing one is accepted; rbtree rejects the same insert
Message-ID: <anr-MVb8okTwL1X2@strlen.de>
References: <CANE+tVp8_NhE+KL6ZNPGjaGMLPxrCWw_A5sY0jotrvThB6idXg@mail.gmail.com>
 <anr3YZJrnS_2RbEp@strlen.de>
 <CANE+tVr69qqyreBbWWk_2FqpMfQAqde-JF=weECditGJF=uZ3g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANE+tVr69qqyreBbWWk_2FqpMfQAqde-JF=weECditGJF=uZ3g@mail.gmail.com>

Wei Fang <void0red@gmail.com> wrote:
> On Tue, Aug 11, 2026 at 6:20 PM Florian Westphal <fw@strlen.de> wrote:
> >
> > Wei Fang <void0red@gmail.com> wrote:
> > > -------------------
> > > expected: both backends reject the overlapping insert (-EEXIST)
> >
> > Why?

Maybe I was too terse.  Default behaviour for interval sets (Rbtree) is
auto-merge: if we have 10.0.0.1-10.0.0.5, add for 10.0.0.2 will work
(no-op).

Behaviour for pipapo is to accept a new element that is fully contained
in an existing entry (no add takes place).

Sure, it could be changed to reject but that would alter user-visible
behaviour, so I would expect complaints.
