Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21734A4984;
	Mon, 19 Oct 2026 09:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792401310; cv=none; b=JUGg3otjGMeB8CsjGwntn3viDN9lCTYdlu424bLYtvu/ncN/QOm9mqb5NFeXlQCKxImZp9cDvDmhAojCZB8iTMnfM+UZ1kK7euvFLv26Foz8GiZId25Ycgys4WKxiDTB9avrX615QF94CW/NDV/KJZYMrHYBqRKZLrxcmeXoKGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792401310; c=relaxed/simple;
	bh=FZL7ndYeOHdmTovZ6tAYZwENLqvM43NyZjkv3QJMFTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YbKke/p90+r18I5SID/q2B9vRHhtDCnMNvojIeI1mBzklK9/m8mzbZcvdV1aQxLmAIm83Nycx5BoEOK3cUwdinXctlTvNNau0p53c0iqatVry7FCtlv5Glp2sTNGoxay2L6ytPvGFMyVQReNQr8B8k2AngKjtSJQA081Qk9RGRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=srJt6LDO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="srJt6LDO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792401305;
	bh=T6y3g5J7ds/r2QjU0764xaxxnThaXEnzlpWsniGgi3o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=srJt6LDOzi2OcqtQBUYfAn1oFyeNoHtjl4/5Um/1qRFicCFRa21TbkFpntXLYsEu9
	 gohLYAY40MbRbfA9LiZp6ne8rmIVDuQD+cCFB4yXjDcZ+yq64X+5sR6+2l69AKqRN2
	 sgBlnyzBBM9Oh+/AjV1elT4KBtcO/p5Km0dB22tXBXZt11ni1EaUHoytOKMbiUV9L1
	 rW/taUnYbxyyFtsfVicoQwyIJYwA6gQew49Id41j6mrTjSNVuZ24aRD3Kas5uugBAt
	 u+B9KlIoT425nybR3D7nAAqjcfgnoX1vqYZB+Gx6ZqnTPm8U3Zb0oL26o1jSqb7gEH
	 wTR2rRpcBOGsw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 9984860077;
	Mon, 19 Oct 2026 11:15:05 +0200 (CEST)
Date: Mon, 19 Oct 2026 11:15:02 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sashiko@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 01/15] netfilter: disable br_netfilter in user
 namespaces
Message-ID: <atXfltTumi0mbcME@chamomile>
References: <20261018005638.1776148-2-pablo@netfilter.org>
 <179237288041.3135.11774275051307629447@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <179237288041.3135.11774275051307629447@kernel.org>

On Mon, Oct 19, 2026 at 01:21:20AM +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 0
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] tools/testing/selftests/net/netfilter/br_netfilter_queue.sh
>   re-execs itself under `unshare -n` (line 40) and then runs `sysctl…
> 
> --
> 
> netfilter: disable br_netfilter in user namespaces
> 
> This commit disables br_netfilter in network namespaces that are not
> owned by init_user_ns. In those namespaces it skips registration of the
> bridge-nf sysctls and of the br_netfilter hooks. It also adds a boot-time
> warning that the module is slated for removal in 2027, and updates the
> bridge documentation to match.
> 
> > diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
> > index 0a394e5f43916..e15355ff215a7 100644
> > --- a/net/bridge/br_netfilter_hooks.c
> > +++ b/net/bridge/br_netfilter_hooks.c
> 
> [ ... ]
> 
> >  static int __net_init brnf_init_net(struct net *net)
> >  {
> > +	if (net->user_ns != &init_user_ns) {
> > +		struct brnf_net *brnet = net_generic(net, brnf_net_id);
> > +
> > +		brnet->in_userns = true;
> > +		pr_warn_once("br_netfilter no longer supported in user namespaces\n");
> > +		return 0;
> > +	}
> > +
> >  	return br_netfilter_sysctl_init_net(net);
> >  }
> 
> [Severity: Medium]
> Should tools/testing/selftests/net/netfilter/br_netfilter_queue.sh be
> updated along with this change?
> 
> That script re-execs itself in a new netns via unshare -n. The new netns
> inherits the caller's user namespace:
> 
>     [ "${1}" != "run" ] && { unshare -n "${0}" run; exit $?; }
> 
> It then treats a missing sysctl as a hard failure:
> 
>     modprobe -q br_netfilter
> 
>     sysctl net.bridge.bridge-nf-call-iptables=1 || exit 1
> 
> Suppose the selftests run inside a non-initial user namespace, for
> example a rootless container or a CI job under unshare -r.

This patch is disabling br_netfilter for userns, so it is normal to me
that such script run under these assumptions do not work anymore.
