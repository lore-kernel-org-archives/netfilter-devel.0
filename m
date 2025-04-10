Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C774690;
	Thu, 10 Apr 2025 10:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744282446; cv=none; b=jy4Dm455BeBm7YwSxqHzvukGSuUyPOMV7elMnVxLCLHe7eu3IAsSN9sv6+JJbFbZDPNJixVgT/0SjDReLdKHUQFEC+jA/2Ic1wWbPlNQCKjF0S5+sRnKj8AZ4R8hSQgCSdmibxKANLEPOB4d6FYwQrBNZ6HzsLj2m9nqJt5KDD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744282446; c=relaxed/simple;
	bh=T0Eo6RBz2cS1tU44dJiO8W8b0KC+LupLMrZspOvecns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q8RRL0ZOHyN00H/lgYQbZiLCmZh4Ue5au1HczQprY4iu5H48RM6qxc6PcSdA2CjuhWnPJE+7rnfRhnB14k4CYolo3NG4RVd+teEvprTvHCKKy0tcDbTbub41hM3wWtfX3ZrMSnAXhUhSSa0VOGAgfjMCqEjwBTJptM3//Kt2w4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u2pXc-0003K3-9W; Thu, 10 Apr 2025 12:53:52 +0200
Date: Thu, 10 Apr 2025 12:53:52 +0200
From: Florian Westphal <fw@strlen.de>
To: lvxiafei <xiafei_xupt@163.com>
Cc: fw@strlen.de, coreteam@netfilter.org, davem@davemloft.net,
	edumazet@google.com, horms@kernel.org, kadlec@netfilter.org,
	kuba@kernel.org, linux-kernel@vger.kernel.org,
	lvxiafei@sensetime.com, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com,
	pablo@netfilter.org
Subject: Re: [PATCH V3] netfilter: netns nf_conntrack: per-netns
 net.netfilter.nf_conntrack_max sysctl
Message-ID: <20250410105352.GB6272@breakpoint.cc>
References: <20250409094206.GB17911@breakpoint.cc>
 <20250410100227.83156-1-xiafei_xupt@163.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410100227.83156-1-xiafei_xupt@163.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

lvxiafei <xiafei_xupt@163.com> wrote:
> > in any case.
> >
> > Also:
> >
> > -       if (nf_conntrack_max && unlikely(ct_count > nf_conntrack_max)) {
> > +       if (net->ct.sysctl_max && unlikely(ct_count > min(nf_conntrack_max, net->ct.sysctl_max))) {
> >
> >
> > ... can't be right, this allows a 0 setting in the netns.
> > So, setting 0 in non-init-net must be disallowed.
> 
> Yes, setting 0 in non-init-net must be disallowed.
> 
> Should be used:
> unsigned int net_ct_sysctl_max = max(min(nf_conntrack_max, net->ct.sysctl_max), 0);
> if (nf_conntrack_max && unlikely(ct_count > net_ct_sysctl_max)) {

That would work.  Alternative, probably preferrable, is to do
something like this:

@@ -615,10 +615,10 @@ enum nf_ct_sysctl_index {
 static struct ctl_table nf_ct_sysctl_table[] = {
-               .proc_handler   = proc_dointvec,
+               .proc_handler   = proc_douintvec_minmax,
+               .extra1         = SYSCTL_ZERO, /* 0 == no limit */
        },
        [NF_SYSCTL_CT_COUNT] = {
                .procname       = "nf_conntrack_count",
@@ -1081,9 +1082,11 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)

        /* Don't allow non-init_net ns to alter global sysctls */
        if (!net_eq(&init_net, net)) {
                table[NF_SYSCTL_CT_EXPECT_MAX].mode = 0444;
                table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
+
+               /* 0 means no limit, only allowed in init_net */
+               table[NF_SYSCTL_CT_MAX].extra1 = SYSCTL_ONE;
        }

That will make setting a 0 value illegal for non-init net case:

sysctl net.netfilter.nf_conntrack_max=0
sysctl: setting key "net.netfilter.nf_conntrack_max": Invalid argument

> min(nf_conntrack_max, net->ct.sysctl_max) is the upper limit of ct_count
> At the same time, when net->ct.sysctl_max == 0, the original intention is no limit,
> but it can be limited by nf_conntrack_max in different netns.

Sounds good to me.
