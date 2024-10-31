Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2552ECF;
	Thu, 31 Oct 2024 23:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416528; cv=none; b=jGFFFc22sUFKT/nkPHETjzNXP66D46+SeK5RhdHnkenVafc0VLmceeA7uYhrtfg3Y+gHtvKQnl83LKPIeZfY017yNp+4Y78q4ATV6gNE8LDByQQOM/GGp6Y7JSGylQnMaoGXsqBrn8umckXRSzdggAncOVcArspf2E4vM7xnfNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416528; c=relaxed/simple;
	bh=n+ofn+IZQGqt0nNbyFaFX0NIR/Sl6Ip5PYCmvfDHYD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G8GJ7AfMejFpCzndkTOhyhZMpUCnKEsdFjuMSV1RIhOrzwDcPj0qSTj6kDi1xcHkHp4kTTtwLTm+/+7UOyTV7ntrDJG+hP3IQJl+Iw2a7UP2RNmomwCYbpD3fLaJGfsXYNa5IOEcwiaVHDjxub6D8K1TrYoWD67w8783rY0Ew2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=40956 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t6eNh-00HKVf-Ac; Fri, 01 Nov 2024 00:15:15 +0100
Date: Fri, 1 Nov 2024 00:15:08 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paul Moore <paul@paul-moore.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
	linux-security-module@vger.kernel.org, jmorris@namei.org,
	serge@hallyn.com, keescook@chromium.org,
	john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
	stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
	selinux@vger.kernel.org, mic@digikod.net, netdev@vger.kernel.org,
	audit@vger.kernel.org, netfilter-devel@vger.kernel.org,
	Todd Kjos <tkjos@google.com>
Subject: Re: [PATCH v3 2/5] LSM: Replace context+len with lsm_context
Message-ID: <ZyQPfFvPD72rx4ME@calendula>
References: <20241023212158.18718-3-casey@schaufler-ca.com>
 <68a956fa44249434dedf7d13cd949b35@paul-moore.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <68a956fa44249434dedf7d13cd949b35@paul-moore.com>
X-Spam-Score: -1.9 (-)

Hi Paul,

This patch breaks nf_conntrack_netlink, Casey mentioned that he will
post another series.

On Thu, Oct 31, 2024 at 06:53:38PM -0400, Paul Moore wrote:
> On Oct 23, 2024 Casey Schaufler <casey@schaufler-ca.com> wrote:
> > 
> > Replace the (secctx,seclen) pointer pair with a single
> > lsm_context pointer to allow return of the LSM identifier
> > along with the context and context length. This allows
> > security_release_secctx() to know how to release the
> > context. Callers have been modified to use or save the
> > returned data from the new structure.
> > 
> > security_secid_to_secctx() and security_lsmproc_to_secctx()
> > will now return the length value on success instead of 0.
> > 
> > Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> > Cc: netdev@vger.kernel.org
> > Cc: audit@vger.kernel.org
> > Cc: netfilter-devel@vger.kernel.org
> > Cc: Todd Kjos <tkjos@google.com>
> > ---
> >  drivers/android/binder.c                |  5 ++-
> >  include/linux/lsm_hook_defs.h           |  5 ++-
> >  include/linux/security.h                |  9 +++---
> >  include/net/scm.h                       |  5 ++-
> >  kernel/audit.c                          |  9 +++---
> >  kernel/auditsc.c                        | 16 ++++------
> >  net/ipv4/ip_sockglue.c                  |  4 +--
> >  net/netfilter/nf_conntrack_netlink.c    |  8 ++---
> >  net/netfilter/nf_conntrack_standalone.c |  4 +--
> >  net/netfilter/nfnetlink_queue.c         | 27 +++++++---------
> >  net/netlabel/netlabel_unlabeled.c       | 14 +++------
> >  net/netlabel/netlabel_user.c            |  3 +-
> >  security/apparmor/include/secid.h       |  5 ++-
> >  security/apparmor/secid.c               | 26 +++++++--------
> >  security/security.c                     | 34 +++++++++-----------
> >  security/selinux/hooks.c                | 23 +++++++++++---
> >  security/smack/smack_lsm.c              | 42 +++++++++++++++----------
> >  17 files changed, 118 insertions(+), 121 deletions(-)
> 
> See my note on patch 1/5, merging into lsm/dev.

