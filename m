Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793562555;
	b=UdaftiApaEiTpU8vTXsRdfTtwxb2uQh4MqjT5aG1RbU/cASmAcjL/R4wOAaFSDCWpEbA
	 SJmcee61lJAhwnH/izgCiBys1Uz5PUS2f4J2giD9pqGlKUXwcJmJY327oYuBwJRh+Aetc
	 pnTKXaNdRd8wi5TSqjzNTio41Nm8G37Wv9xOlG52sFfYdG7BzIA2TMiRYLFhwl2y9YiyP
	 mNQfD1hwjMO1YgOINn/SYWvqE3h2ndGw5PdIj4lOs7zcpoBW+gKvihVS2QPYs2G8r1kKd
	 6veyj6fWDaPbz5cyUwSBoivJMIz9yFD8msDk3Ch9s3MyoMRbuk+gnEbEbLfP9ZkKEqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793562555;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=t2kNU5eG9QrJEzeC8yKEV+ni5mThHmejJFQTAhEp1T0=;
	b=px4LluH02e/bL0g7tHapEGwvqstTpNp/sMtrsw8kOt7kXRYEgPdqIzVf8QfWz02Y/WXb
	 YufdTzzvBUFXdicEvpiUcVjeILKvNiu1LawDJMl95BCr/sr/MAm6ZkrnNAm8hhWx6bOZj
	 B9Kd+djw8TmTKFWLbKfKJYvblCJnIBRfSvoO35j9XRMAhNo3reDcTV12I3uxJt0+GPz9X
	 kQBqy2XKIwT/sDyMaGlRN/SqVWH+JmQHc2Igb4v5PdVS98SJxClmWB16tmH5QqTeoSyGm
	 C1nmnTA5ImQDgp526Hplkl/ztoC08kcFtJ1FhVqZLqkzZ8RBdqYL+Dv9ZdCJfg2IwzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kkAPwX7w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1877606A32C;
	Sun,  1 Nov 2026 19:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kkAPwX7w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957661F000C1;
	Sun,  1 Nov 2026 19:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793562554;
	bh=t2kNU5eG9QrJEzeC8yKEV+ni5mThHmejJFQTAhEp1T0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=kkAPwX7wcgBQ4GT8jmKhEYthktZIaA6Xoog79U+SEb38yctjj9/plNjCkqYm175dD
	 s3LH/QieZwXm21k0j7aqRtJhWmx88VXUYRrVMcpGAVkliEClSaunn9+dsupUKzgiku
	 n9Ir+2KmhZUuZuhXBx6Fyq696yhFTeBW8PO1Qw345VDdwcDrd9s5QjxAfjVnnZObSa
	 7Ez+6bT6jYjqytPa5ebvAbqP1611aMjGVBCLs8XG/oPlSBF8YJLNjeLitTUvcTT0xB
	 6ylFgxCcK90USH/ARdzzILgDjrBSRxqhrpT94mpbC4j0VAlTakLzCeiZCAJNlDt4y0
	 kXDkgej2hX6OA==
Subject: Re: [PATCH net v3 1/3] net/ipv6: add ipv6_chk_addr_namespace
From: netdev-bot+sashiko@kernel.org
To: ihuguet@riseup.net
Cc: ast@kernel.org, andrew+netdev@lunn.ch, andrii@kernel.org,
 daniel@iogearbox.net, dsahern@kernel.org, davem@davemloft.net,
 eddyz87@gmail.com, edumazet@kernel.org, fw@strlen.de, idosch@nvidia.com,
 kuba@kernel.org, memxor@gmail.com, ncardwell@google.com, pablo@netfilter.org,
 pabeni@redhat.com, shuah@kernel.org, willemdebruijn.kernel@gmail.com,
 bpf@vger.kernel.org, leitao@debian.org, coreteam@netfilter.org,
 emil@etsalapatis.com, fmancera@suse.de, ihor.solodrai@linux.dev,
 jlayton@kernel.org, jolsa@kernel.org, joe@dama.to, john.fastabend@gmail.com,
 zirajs7@gmail.com, kees@kernel.org, kuniyu@google.com, leon.hwang@linux.dev,
 lirongqing@baidu.com, linux-kselftest@vger.kernel.org, martin.lau@linux.dev,
 netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, phil@nwl.cc,
 tpluszz77@gmail.com, bigeasy@linutronix.de, horms@kernel.org, song@kernel.org,
 sdf@fomichev.me, willemb@google.com, luoxuanqiang@kylinos.cn,
 yonghong.song@linux.dev, ihuguet@redhat.com, dcaratti@redhat.com
Date: Sun, 01 Nov 2026 19:49:11 +0000
Message-ID: <179356255114.3131.8560122434212545006@kernel.org>
In-Reply-To: <20261028191103.623156-2-ihuguet@riseup.net>
References: <20261028191103.623156-2-ihuguet@riseup.net>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message says the patch clarifies how ipv6_chk_addr()
  and related functions behave, but two of the new comments describe the…
- [Low] ipv6_chk_addr_namespace() is exported with EXPORT_SYMBOL, but no
  module uses it.

--

net/ipv6: add ipv6_chk_addr_namespace

This patch adds a skip_l3mdev_check argument to ipv6_chk_addr_and_flags()
and a new ipv6_chk_addr_namespace() helper. The helper looks for an address
in every L3 domain of the namespace. The patch also rewrites the comments
that describe how ipv6_chk_addr() and related functions behave when dev is
NULL.

> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index c8c0dd04982d9..b13a5846ec95a 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c

[ ... ]

> @@ -2026,7 +2013,7 @@ __ipv6_chk_addr_and_flags(struct net *net, const struct in6_addr *addr,
>  			    : ifp->flags;
>  		if (ipv6_addr_equal(&ifp->addr, addr) &&
>  		    !(ifp_flags&banned_flags) &&
> -		    (!dev || ndev == dev ||
> +		    (skip_dev_check || ndev == dev ||
>  		     !(ifp->scope&(IFA_LINK|IFA_HOST) || strict))) {
>  			rcu_read_unlock();
>  			return ndev;
> @@ -2037,15 +2024,46 @@ __ipv6_chk_addr_and_flags(struct net *net, const struct in6_addr *addr,
>  	return NULL;
>  }
>  
> +/* The 'dev' argument is used to match the exact device or find the L3 domain of
> + * interest.
> + * The 3 cases for addresses checks are:
> + *   1. With 'skip_dev_check == false': check if 'addr' exists on 'dev'.
> + *   2. With 'skip_dev_check == true && skip_l3mdev_check == false': check if
> + *      'addr' exists on the same L3 domain as 'dev'.
> + *   3. With 'skip_dev_check == true && skip_l3mdev_check == true': check if
> + *      'addr' exists in the entire namespace.
> + * For the purpose of searching in a specific L3 domain, 'dev == NULL' means
> + * "search in the main L3 domain".
> + */

[Severity: Low]
Is the description of case 1 accurate? The commit message says the patch
clarifies the behaviour, but the match condition in
__ipv6_chk_addr_and_flags() quoted above is looser:

    (skip_dev_check || ndev == dev ||
     !(ifp->scope&(IFA_LINK|IFA_HOST) || strict))

With skip_dev_check == false and strict == 0, a global scope address on any
other device in the same L3 domain also matches. Only link-local or host
scope addresses, or strict == 1, are tied to the exact device.

Existing callers depend on this. ip6_route_info_create() checks prefsrc
with ipv6_chk_addr(net, &cfg->fc_prefsrc, dev, 0). ip6_tnl_rcv_ctl() and
ip6_tnl_xmit_ctl() pass (ldev, false, false, 0, ...).

The new comment on ipv6_chk_addr() below has the same problem ("Check if
'addr' is configured on 'dev'"), because ipv6_chk_addr() passes the
caller's strict value through.

The ipv6_chk_addr_namespace() comment also says "exists in the entire
namespace". It leaves out that tentative addresses are skipped because of
IFA_F_TENTATIVE, while optimistic ones are accepted.

Could these comments mention the strict and scope exception, and the
tentative filtering?

>  int ipv6_chk_addr_and_flags(struct net *net, const struct in6_addr *addr,
>  			    const struct net_device *dev, bool skip_dev_check,

[ ... ]

> +/* Check if 'addr' is configured on 'dev'. If 'dev' is NULL, check the entire
> + * main L3 domain
> + */
> +int ipv6_chk_addr(struct net *net, const struct in6_addr *addr,
> +		  const struct net_device *dev, int strict)
> +{
> +	return ipv6_chk_addr_and_flags(net, addr, dev, !dev, false,
> +				       strict, IFA_F_TENTATIVE);
> +}
> +EXPORT_SYMBOL(ipv6_chk_addr);
> +
> +/* Check if 'addr' exists in the entire namespace, in any L3 domain */
> +int ipv6_chk_addr_namespace(struct net *net, const struct in6_addr *addr)
> +{
> +	return ipv6_chk_addr_and_flags(net, addr, NULL, true, true, 0,
> +				       IFA_F_TENTATIVE);
> +}
> +EXPORT_SYMBOL(ipv6_chk_addr_namespace);

[Severity: Low]
Is this export needed? CONFIG_IPV6 is bool in net/ipv6/Kconfig, so
addrconf.c is always built in.

The only user in the series is ip6_is_local_saddr() in
net/ipv6/ip6_output.c. It is added by the follow-up patch "net/ipv6: don't
route packets with unknown source address", and that file is also always
built in.

Could the EXPORT_SYMBOL be dropped? If a modular user is planned, could it
be EXPORT_SYMBOL_GPL instead?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261028191103.623156-1-ihuguet%40riseup.net
