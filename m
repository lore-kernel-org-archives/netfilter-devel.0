Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0561E4562BD;
	Thu, 17 Sep 2026 08:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789635316; cv=none; b=LuB2hCX19ORY8+g2zdSES08DFMTd0O3qdEVPLeqAv9lehxYuoZJoZ13Yiwu2e79O29jzfQYvU+JDrtNtz/ThnvgzrTJTXCZWUGgxUlMZn+g1KHrXYRqtbYvBElsfHvO/nEs7ELfGxG/fXwRV0W6MEl/QfwNf7DTV33CyvqB11FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789635316; c=relaxed/simple;
	bh=vn31ij5EjMpSY4fNULl9mNiHva1/BB4PcHzqjFUIWVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q4DZOt8IBiKZrMu54PXTXb6+KjEvPzUtx+fuO5Dvl7xrdrzDzrrEgnwHJbanKnbDOE10xoQ3+pSCYh5/3SXpfBwsUojkoypKWSgO6K0RoW9zB3IoY2qU6m324cO4ZeHioxtake93xa7ejPQuKxmZk/53DY/qJFzYxIf2mhvtVoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=E24bQLqZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="E24bQLqZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789635308;
	bh=VyrNncgMjLTsBvabQF8/YlHLzKKib3TBgXLmZZSfKgQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E24bQLqZqCbhYofFpFX5C/Yn90lZRe1Y1Sl92lkL5j5M0O9HmOV/qfTuszP+xhHMZ
	 PHgtIrJLt1Cmp9zNstWDEva8MV+TOpfIOOGS3+ge9KpPnCGTwcnq0yz+rlsZ1KlMyp
	 +vq4s4VZYDlux6eyjR9b7eMbj375oF+kgQXvTWbHA4pkLKuOhr3fom7iTZp0KNyE9I
	 yLDpyxv8KzYcp9FiUJju60ACYct+BWomEPCeqvjhM4j6ErtuYmYPrZsZMCAArGhFau
	 4xUQE97+l1D5vk3XmZBUshNUkKbwXKerlMtqkh4AKdD0+Nr95zNzHgTT4DuGfneKfl
	 cbtKQePrSd1nA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 9A1346005F;
	Thu, 17 Sep 2026 10:55:08 +0200 (CEST)
Date: Thu, 17 Sep 2026 10:55:05 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Hangbin Liu <hangbin.liu@linux.dev>,
	Matthieu Baerts <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, mptcp@lists.linux.dev,
	Hangbin Liu <liuhangbin@kylinos.cn>
Subject: Re: [PATCH net] selftests: net: update netfilter netlink config
Message-ID: <aquq6fEQiDq5Ey59@chamomile>
References: <20260917-selftest_config-v1-1-bf25ccbfb18e@kylinos.cn>
 <f557e44a-86b6-4ebb-ad35-d7bc5902929a@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f557e44a-86b6-4ebb-ad35-d7bc5902929a@suse.de>

On Thu, Sep 17, 2026 at 09:06:48AM +0200, Fernando Fernandez Mancera wrote:
> On 9/17/26 4:17 AM, Hangbin Liu wrote:
> > From: Hangbin Liu <liuhangbin@kylinos.cn>
> > 
> > Since commit d4349ba9872d ("netfilter: allow nfnetlink built-in only"),
> > NETFILTER_NETLINK was changed to a bool. Use 'y' instead of 'm'.
> > Otherwise the build emits:
> > 
> >    .config:5688:warning: symbol value 'm' invalid for NETFILTER_NETLINK
> > 
> > Fixes: d4349ba9872d ("netfilter: allow nfnetlink built-in only")
> > Signed-off-by: Hangbin Liu <liuhangbin@kylinos.cn>
> 
> Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.

> Thanks!
> 
> > ---
> > This is a simple update addressing the same issue, so I’d like to post it
> > directly to netdev instead of bothering two separate subsystems
> > (mptcp and netfilter).
> > ---
> >   tools/testing/selftests/net/mptcp/config     | 2 +-
> >   tools/testing/selftests/net/netfilter/config | 2 +-
> >   2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/net/mptcp/config b/tools/testing/selftests/net/mptcp/config
> > index 59051ee2a986..bb9c4c97c620 100644
> > --- a/tools/testing/selftests/net/mptcp/config
> > +++ b/tools/testing/selftests/net/mptcp/config
> > @@ -18,7 +18,7 @@ CONFIG_NET_CLS_ACT=y
> >   CONFIG_NET_CLS_FW=m
> >   CONFIG_NETFILTER=y
> >   CONFIG_NETFILTER_ADVANCED=y
> > -CONFIG_NETFILTER_NETLINK=m
> > +CONFIG_NETFILTER_NETLINK=y
> >   CONFIG_NETFILTER_XTABLES=m
> >   CONFIG_NETFILTER_XTABLES_LEGACY=y
> >   CONFIG_NETFILTER_XT_MATCH_BPF=m
> > diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
> > index c3c121b6f300..629b2b29ed1a 100644
> > --- a/tools/testing/selftests/net/netfilter/config
> > +++ b/tools/testing/selftests/net/netfilter/config
> > @@ -44,7 +44,7 @@ CONFIG_NET_CLS_U32=m
> >   CONFIG_NETDEVSIM=m
> >   CONFIG_NETFILTER=y
> >   CONFIG_NETFILTER_ADVANCED=y
> > -CONFIG_NETFILTER_NETLINK=m
> > +CONFIG_NETFILTER_NETLINK=y
> >   CONFIG_NETFILTER_NETLINK_QUEUE=m
> >   CONFIG_NETFILTER_SYNPROXY=m
> >   CONFIG_NETFILTER_XTABLES=m
> > 
> > ---
> > base-commit: 1dd85662fee6e2ac580b1c4f9a0c0a7ae6e31f0e
> > change-id: 20260917-selftest_config-286bdd44b22b
> > 
> > Best regards,
> 
