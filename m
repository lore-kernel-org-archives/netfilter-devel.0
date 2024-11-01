Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFE786252;
	Fri,  1 Nov 2024 07:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730445967; cv=none; b=OkYXnNN13OHaqK4uHMMH3kiytH3cCe8oUyTnlzDL4gMqdnPnZxEnfiqYEOfvWm6Jt/EzzoykQUyDM5ltKZM0REKLlyioCW1bbR3W9u+37REMIFk6Fi/MJ2S8r9Idv6YJTLZi01xG+1QeVxYzwJRHk3Q724sDqfurDE7PHRCyZQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730445967; c=relaxed/simple;
	bh=9KsNjW73/rwnA/MCFDoVKZvKFbcg6J+eV9177kx9fzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iZcepl1DiKb4+6PK0UtR+OQDq61+kbXqGiqYYqc6lr96Mi28xmy7u7Nz//NIRLqAbq0Gdimm9TEZ3SM4qI5oYmUtBUFNr6AwINjvzF1R4a/OvrBKW08chQSM0qT8vLbWyJjq6j0JgVA3MGEiuSoLz4QQ2rbNmZcgqlJ00GZs/Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=48922 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t6m2W-001NQn-1M; Fri, 01 Nov 2024 08:25:50 +0100
Date: Fri, 1 Nov 2024 08:25:46 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Paul Moore <paul@paul-moore.com>, linux-security-module@vger.kernel.org,
	jmorris@namei.org, serge@hallyn.com, keescook@chromium.org,
	john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
	stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
	selinux@vger.kernel.org, mic@digikod.net, netdev@vger.kernel.org,
	audit@vger.kernel.org, netfilter-devel@vger.kernel.org,
	Todd Kjos <tkjos@google.com>
Subject: Re: [PATCH v3 2/5] LSM: Replace context+len with lsm_context
Message-ID: <ZySCeoe3kVqKTyUh@calendula>
References: <20241023212158.18718-3-casey@schaufler-ca.com>
 <68a956fa44249434dedf7d13cd949b35@paul-moore.com>
 <ZyQPfFvPD72rx4ME@calendula>
 <ZyQRgL_jWdvKgRl-@calendula>
 <dd727620-9823-4701-aaf1-080b03fb6ccd@schaufler-ca.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dd727620-9823-4701-aaf1-080b03fb6ccd@schaufler-ca.com>
X-Spam-Score: -1.9 (-)

On Thu, Oct 31, 2024 at 04:58:13PM -0700, Casey Schaufler wrote:
> On 10/31/2024 4:23 PM, Pablo Neira Ayuso wrote:
> > On Fri, Nov 01, 2024 at 12:15:16AM +0100, Pablo Neira Ayuso wrote:
> >> Hi Paul,
> >>
> >> This patch breaks nf_conntrack_netlink, Casey mentioned that he will
> >> post another series.
> 
> I have a fix, it is pretty simple. How about I send a 6/5 patch for it?

No idea. I don't know what is the status of this series. I would
suggest to repost a new series.

> Or, if you want to fix it yourself, in ctnetlink_secctx_size() remove the
> declaration of "len" and replace its use in the return with "ret".

No, sorry, I won't do that.

Thanks.

> > Please, see:
> >
> > https://lore.kernel.org/netfilter-devel/ZxpxZuErvXSLApsf@calendula/
> >
> >> On Thu, Oct 31, 2024 at 06:53:38PM -0400, Paul Moore wrote:
> >>> On Oct 23, 2024 Casey Schaufler <casey@schaufler-ca.com> wrote:
> >>>> Replace the (secctx,seclen) pointer pair with a single
> >>>> lsm_context pointer to allow return of the LSM identifier
> >>>> along with the context and context length. This allows
> >>>> security_release_secctx() to know how to release the
> >>>> context. Callers have been modified to use or save the
> >>>> returned data from the new structure.
> >>>>
> >>>> security_secid_to_secctx() and security_lsmproc_to_secctx()
> >>>> will now return the length value on success instead of 0.
> >>>>
> >>>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> >>>> Cc: netdev@vger.kernel.org
> >>>> Cc: audit@vger.kernel.org
> >>>> Cc: netfilter-devel@vger.kernel.org
> >>>> Cc: Todd Kjos <tkjos@google.com>
> >>>> ---
> >>>>  drivers/android/binder.c                |  5 ++-
> >>>>  include/linux/lsm_hook_defs.h           |  5 ++-
> >>>>  include/linux/security.h                |  9 +++---
> >>>>  include/net/scm.h                       |  5 ++-
> >>>>  kernel/audit.c                          |  9 +++---
> >>>>  kernel/auditsc.c                        | 16 ++++------
> >>>>  net/ipv4/ip_sockglue.c                  |  4 +--
> >>>>  net/netfilter/nf_conntrack_netlink.c    |  8 ++---
> >>>>  net/netfilter/nf_conntrack_standalone.c |  4 +--
> >>>>  net/netfilter/nfnetlink_queue.c         | 27 +++++++---------
> >>>>  net/netlabel/netlabel_unlabeled.c       | 14 +++------
> >>>>  net/netlabel/netlabel_user.c            |  3 +-
> >>>>  security/apparmor/include/secid.h       |  5 ++-
> >>>>  security/apparmor/secid.c               | 26 +++++++--------
> >>>>  security/security.c                     | 34 +++++++++-----------
> >>>>  security/selinux/hooks.c                | 23 +++++++++++---
> >>>>  security/smack/smack_lsm.c              | 42 +++++++++++++++----------
> >>>>  17 files changed, 118 insertions(+), 121 deletions(-)
> >>> See my note on patch 1/5, merging into lsm/dev.
