Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E5F2FFF90;
	Fri, 11 Sep 2026 00:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789087613; cv=none; b=o2bYaEFU6DVJ6eekzvgMSsc169hBDbdgN/+u2dRmEz5XUwKsMIN3M++klittAVlXMzGREffGgk+6uQsPrmncrZOTkicpfpjKCLf4gVLgm2/f7F89Pjpnuu/AIyrG4t/6AZAz2GSXhE2GnuJuyIMmo1AFhj0gxr70Iknu8YhbtSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789087613; c=relaxed/simple;
	bh=/vDTYmVLNC1j41eJJr7ckmNtd7VjF3nRSi8Cj1JNbGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJO2wKX9kzMsnSjFkcpI9t+y+8Mxa9k/+N+S79Y5w4O7mGM/UtO3Sv4yDg7zFe+qpiQgRaSf7YazD1Mz3iLddVRett49oMUbQ1kj12c9CPf1Z4O7xmfzlaMS+DUMYLKL8MNh9D/i1VfrYJJkUuYXviyIA/2vYi7FT5iYduDed3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PiZJVQYC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PiZJVQYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412371F00898;
	Fri, 11 Sep 2026 00:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789087611;
	bh=+rDy5NQQmc/6557YW2vfYUSn82y+tcN7Jk0vdiehq+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PiZJVQYCZdpPN7/RpD42gdG6GqBTi+yS6sqTpuvK42xGvD6R9oVT6em0fZz8M5M71
	 Hy/HkcuwG75snyql4ATjwYe+BJTEEtQyaLI/rHr5ELICiU5ivANCXm/OvVhEvzg8hy
	 Eb+fMDGaWX0MCohl8l3XWsIdfDZ1ica+xOTxR9+BI7x+qW30nNUvipodADLQ7y+r5D
	 QA3wQryL0c3TptLZQiMTM/nJAMgMqwSlCxQGIQKusAci3tUhsOh0CYryEJSiilURPB
	 NTuoID/F/fBbwgCoZJ1rYmXxOqaIVnKpma+jepkas2W3c6FBQfsOZ5RUuLNNchxFaB
	 pTZGObseTAHMg==
From: Jakub Kicinski <kuba@kernel.org>
To: pablo@netfilter.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: Re: [PATCH net 7/7] netfilter: hold reference on module during netlink dump
Date: Thu, 10 Sep 2026 17:46:50 -0700
Message-ID: <20260911004650.2877989-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909221844.1650275-8-pablo@netfilter.org>
References: <20260909221844.1650275-8-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
netfilter: hold reference on module during netlink dump

This adds .module = THIS_MODULE to the struct netlink_dump_control
initializers in ip_set_core.c, nf_conntrack_netlink.c, nfnetlink_acct.c,
nfnetlink_cthelper.c and nfnetlink_cttimeout.c, with five Fixes: tags
referencing the original netfilter netlink dump implementations.

No Link: tags were present in the commit header.

> netfilter: hold reference on module during netlink dump
>
>     Modules can be removed in the middle of a netlink dump. Set .module to
>     THIS_MODULE in struct netlink_dump_control to hold a reference on the
>     module while netlink dump is in progress.
>
>     See commit 6dc878a8ca39 ("netlink: add reference of module in
>     netlink_dump_start") which describes this problem.
>
>     Fixes: a7b4f989a629 ("netfilter: ipset: IP set core support")
>     Fixes: c1d10adb4a52 ("[NETFILTER]: Add ctnetlink port for nf_conntrack")
>     Fixes: 50978462300f ("netfilter: add cttimeout infrastructure for fine timeout tuning")
>     Fixes: 9413902796f5 ("netfilter: add extended accounting infrastructure over nfnetlink")
>     Fixes: 12f7a505331e ("netfilter: add user-space connection tracking helper infrastructure")

[Severity: High]

Do any of these assignments change behaviour?  The wrapper in
include/linux/netlink.h already fills in .module when the caller left it
unset:

  static inline int netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
                                      const struct nlmsghdr *nlh,
                                      struct netlink_dump_control *control)
  {
          if (!control->module)
                  control->module = THIS_MODULE;

          return __netlink_dump_start(ssk, skb, nlh, control);
  }

Since this is a static inline in a header, THIS_MODULE expands in the
caller's translation unit, so it already resolved to ip_set.ko,
nf_conntrack_netlink.ko, nfnetlink_acct.ko, nfnetlink_cthelper.ko and
nfnetlink_cttimeout.ko respectively.

Every touched call site builds a local struct netlink_dump_control with
designated initializers (so .module was NULL on entry) and then calls the
inline netlink_dump_start(), never __netlink_dump_start() directly.  So
__netlink_dump_start() was already doing:

  /* add reference of module which cb->dump belongs to */
  if (!try_module_get(control->module)) {
          ret = -EPROTONOSUPPORT;
          goto error_unlock;
  }
  ...
  cb->module = control->module;

with the matching module_put() in netlink_dump(), in the error_put path and
in netlink_sock_destruct().

Given that, can a module actually be removed in the middle of one of these
dumps, as the changelog states?  If not, are the five Fixes: tags correct?
They point stable and CVE triage at a use-after-free in five netfilter
subsystems, and commit 6dc878a8ca39 cited in the changelog is what
introduced the implicit default precisely so that individual callers would
not need to set .module.

Would it make sense to either drop the patch, or drop the Fixes: tags and
describe it as an explicitness cleanup?  Alternatively, if there is a path
where the wrapper default does not apply (for example a dump callback living
in a different module than the caller), could the changelog name it?

On that last point, ip_set_dump() is the one site with a plausible
cross-module concern, but a reference on the ip_set core does not cover the
separate ip_set_hash_* / ip_set_list_* set type modules whose ->list()
callbacks run during the dump; those are pinned separately at set creation
time.  Does the change help there either?

> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index 0a86a170ba906..624c5f14acf69 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -1733,6 +1733,7 @@ static int ip_set_dump(struct sk_buff *skb, const struct nfnl_info *info,
>  			.start = ip_set_dump_start,
>  			.dump = ip_set_dump_do,
>  			.done = ip_set_dump_done,
> +			.module = THIS_MODULE,
>  		};
>  		return netlink_dump_start(info->sk, skb, info->nlh, &c);
>  	}
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 579ada063b1bb..2340885b2076d 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1682,6 +1682,7 @@ static int ctnetlink_get_conntrack(struct sk_buff *skb,
>  			.start = ctnetlink_start,
>  			.dump = ctnetlink_dump_table,
>  			.done = ctnetlink_done,
> +			.module = THIS_MODULE,
>  			.data = (void *)cda,
>  		};
>  

[ ... remaining ctnetlink, nfnetlink_acct, nfnetlink_cthelper and
nfnetlink_cttimeout hunks snipped, the same question applies to each ... ]
