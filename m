Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E539F4219FF;
	Wed,  1 Jul 2026 11:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782903721; cv=none; b=p3KCgX7uhSU5+FSLDmO+KT/ewXhK/yJY8qW3w7eepvoKTcX0EIhhN0d/5EkPXSDQORpiqwWhExMZKIbiZQX1/76FRYbhsMxmaUuu1ompeOsqP2jdGVZ2rz4SZ8KDtKb0G9mMGSKA7qPMIifrUoHliHx5YjC23M7ypf/yFXAgdEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782903721; c=relaxed/simple;
	bh=XaYWtMGNgt5FOX7HON74P5yka1JQED5HVnel31HcEoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Da1VhmmHGg/lHK5MEmyPTTkrwJI3f4XJSy9U+LYD/5FlUB38xeFFqx8FlBho83TeE44WGC53EBtqc2eeT957Bb2RdMKUpZg4gjhthxJKpLsi4457oXNUq/1RrRZWCdWqtfDLTDsi91qfAXG3Ql1IDmttfaSmDW7ZJmQ3JM6uWMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=o8lzDtNE; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="o8lzDtNE"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3C62760588;
	Wed,  1 Jul 2026 13:01:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782903717;
	bh=QxPuanMrXViRFbZ/7f1IxjQONUCuWhm+IzkoyoL4DB0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o8lzDtNER8nYIuqXeHHb6FJZAoZ1lRZirWcx1tp/q8AMbha2SITBChlZS4ziyGKGp
	 aqyqES01Q5lveMQMsxf4YHS3Jw4XdlktfQ3j17pwDqM2nPk7cr5bvecsQsd3NNOsqP
	 iz8d1J+IPCrfZpe5tOdE9UDvq0MwE6pXnZWeEIWmT57Os/m3p9ac0rGqZakxpfhLys
	 tho6eubVUprj5Xy5SGQ/HzT6bZuzLvwFzkPwq03TYb8B3yu506Y8uyyCxQday+PDO1
	 q7E2kxxxLQEBAwDXnmMTy4mGOit3bbXxPqiKSaCE6aX/aH5VkbzxZ5WHl+yyBp/BBy
	 F7vCwrNfn/QlQ==
Date: Wed, 1 Jul 2026 13:01:54 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net 4/9] netfilter: nf_conntrack_sip: validate skb_dst()
 before accessing it
Message-ID: <akTzomC4Qz8u8teJ@chamomile>
References: <20260630045243.2657-1-fw@strlen.de>
 <20260630045243.2657-5-fw@strlen.de>
 <akS1W7XGQ3LiP0LC@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <akS1W7XGQ3LiP0LC@strlen.de>

On Wed, Jul 01, 2026 at 08:36:11AM +0200, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > tc ingress and openvswitch do not guarantee routing information to be
> > available. These subsystems use the conntrack helper infrastructure, and
> > the SIP helper relies on the skb_dst() to be present if
> > sip_external_media is set to 1 (which is disabled by default as a module
> > parameter).
> 
> The sashiko drive-by appears real, I submitted a patch for it.
> Its not a regression added by this patch but a unrelated issue.
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260701062922.9660-1-fw@strlen.de/

Is skb_ensure_writable() bogus here?

As you said, skb is already linearized. As for clones, they should
only happen in br_netfilter? In such case, it should be br_netfilter
that should be audited not to pass cloned skbuffs before calling the
inet hooks.
