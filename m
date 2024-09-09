Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E871CAA6;
	Mon,  9 Sep 2024 18:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725906649; cv=none; b=LIoKUrFIJol7r68ahjrn3yHp9n2RRPA1SZ6RTQ7gr1cU6GZq1Hum/feygovk9UCnk7PktTuGro0ePiJnCBmmNfC3ntqJFkhkt2fue7Eyks5JqINfTnAWRu9iMNKJ73ek/q5527GGs4TPoDcofAMeMf5DP+hCN3zZNC4d0AsioRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725906649; c=relaxed/simple;
	bh=f+cNg6Y/JZEaSDG9EamgmiQzQ33gJhjd1g2B3Oa2+po=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vAAvA4pAm1xuKZj6oqFyz8akpxhd6hQYQZvybifZQPC3uCRNg9qVhpQ5IQaLSh9zeHcIDcowoiF4NLTtxaTZ2u0dp2LSksxVVK2d1bsLWA6Zg814eswzFKGJfYrvG++i+D4X7r95mD0l04QVBZxmV67NSe2GWuqwt04SyAdb5ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JcfrvxY3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JcfrvxY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB93FC4CEC5;
	Mon,  9 Sep 2024 18:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725906649;
	bh=f+cNg6Y/JZEaSDG9EamgmiQzQ33gJhjd1g2B3Oa2+po=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JcfrvxY3mvCXtn0YuYrZvN2FRtkIlKEZs374pTatmcWofWq551EyoENxNOyd8jiEW
	 wXb+kO+C4wDO30qc1tNw+D15eW0U6vj8HcccaGNzPDylyYPeGgMOKNdNJdohFWCAoM
	 YQiSsaM9/0ixdFCO0CSbIP/5UHcO53pVcx1ga4G1DGjxvLoaRzbjTHeresx+3iCuli
	 s0KT+xOmHE5HUvt3HDqfNTMMZZSQHRPoRZ4KgSYHLRY9Ks4rAGKS2GF8tdAJrqllvM
	 6+VIewKBQZSSn0WiIjfR1D8TN89QI/PCb4XHk3Nlq+hu+2Vf+txchpNClDh0Wim+5x
	 DJ6EKd+Wlj7Lg==
Date: Mon, 9 Sep 2024 19:30:43 +0100
From: Simon Horman <horms@kernel.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Felix Huettner <felix.huettner@mail.schwarz>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH net v1 1/1] netfilter: conntrack: Guard possoble unused
 functions
Message-ID: <20240909183043.GE2097826@kernel.org>
References: <20240905203612.333421-1-andriy.shevchenko@linux.intel.com>
 <20240906162938.GH2097826@kernel.org>
 <Zt7B79Q3O7mNqrOl@smile.fi.intel.com>
 <20240909151712.GZ2097826@kernel.org>
 <Zt8V5xjrZaEvR8K5@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zt8V5xjrZaEvR8K5@smile.fi.intel.com>

On Mon, Sep 09, 2024 at 06:36:07PM +0300, Andy Shevchenko wrote:
> On Mon, Sep 09, 2024 at 04:17:12PM +0100, Simon Horman wrote:
> > On Mon, Sep 09, 2024 at 12:37:51PM +0300, Andy Shevchenko wrote:
> > > On Fri, Sep 06, 2024 at 05:29:38PM +0100, Simon Horman wrote:
> > > > On Thu, Sep 05, 2024 at 11:36:12PM +0300, Andy Shevchenko wrote:
> > > 
> > > > Local testing seems to show that the warning is still emitted
> > > > for ctnetlink_label_size if CONFIG_NETFILTER_NETLINK_GLUE_CT is enabled
> 
> Hold on, this is not related to the patch.
> It might be another issue.

Yes, sorry, I see that now too.

Perhaps it can be fixed separately, something like this:

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 8fd2b9e392a7..fcd1b800b2c1 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -383,6 +383,7 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 #endif
 
 #ifdef CONFIG_NF_CONNTRACK_LABELS
+#ifdef CONFIG_NETFILTER_NETLINK_GLUE_CT
 static inline int ctnetlink_label_size(const struct nf_conn *ct)
 {
 	struct nf_conn_labels *labels = nf_ct_labels_find(ct);
@@ -391,6 +392,7 @@ static inline int ctnetlink_label_size(const struct nf_conn *ct)
 		return 0;
 	return nla_total_size(sizeof(labels->bits));
 }
+#endif
 
 static int
 ctnetlink_dump_labels(struct sk_buff *skb, const struct nf_conn *ct)

> 
> > > > but CONFIG_NF_CONNTRACK_EVENTS is not.
> > > 
> > > Can you elaborate on this, please?
> > > I can not reproduce.
> > 
> > Sure, let me retest and get back to you.
> 
> -- 
> With Best Regards,
> Andy Shevchenko
> 
> 
