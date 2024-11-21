Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F256427447;
	Thu, 21 Nov 2024 15:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.238.174.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732202669; cv=none; b=uEwHfaVehNapKqUmQpwstFAMGMcyuN1PLojm5tPKIxF9BuoQBmBFpHil03AINqc6id3bS42FrCRHjMTwgb9OcACbDTYPaGNIr04PMfJxc0CQ7qG4cfYhIIsSh6nix7XXvZTALRam+3F22pC6y0ZKSS3kriPrsL7gsEbYgVXZwrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732202669; c=relaxed/simple;
	bh=7Zx2yBPzpQPZys9FtYhLvm+JYV+pYduZxHC4bcYUS3o=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=UCyyZbjsEts3NcYtIUfFwwZ3JAUPAE1mZgPI0zpM60KNmrq9wUnjQBq4LlTfdLMI3Xrrqz9q6EF0SfmYIDZ8H5qkwHQGqsdzgxq6wSL80dy2FewKQsZ7eEN7RvDdrBIYtzjVfiDJxLxUeGEqSNSzQlJuyNNcjMk5SeAaIk8Hhyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg; spf=pass smtp.mailfrom=ssi.bg; dkim=pass (1024-bit key) header.d=ssi.bg header.i=@ssi.bg header.b=F/EpqzNP; arc=none smtp.client-ip=193.238.174.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ssi.bg header.i=@ssi.bg header.b="F/EpqzNP"
Received: from mg.ssi.bg (localhost [127.0.0.1])
	by mg.ssi.bg (Proxmox) with ESMTP id 4CD9980CD9;
	Thu, 21 Nov 2024 17:24:19 +0200 (EET)
Received: from ink.ssi.bg (ink.ssi.bg [193.238.174.40])
	by mg.ssi.bg (Proxmox) with ESMTPS;
	Thu, 21 Nov 2024 17:24:18 +0200 (EET)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by ink.ssi.bg (Postfix) with ESMTPSA id 15AC53027E6;
	Thu, 21 Nov 2024 17:24:09 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=ssi.bg; s=ink;
	t=1732202650; bh=7Zx2yBPzpQPZys9FtYhLvm+JYV+pYduZxHC4bcYUS3o=;
	h=Date:From:To:cc:Subject:In-Reply-To:References;
	b=F/EpqzNPvknBT/zP/P8tPlKwkcFc4obCKi/QHVU+SI1KO7MEFJJyL605Y+UMCxVSU
	 pKUA3vmyX4jiJPq5gMITmhAI3alvrroyZ/2IBJ5W+nfbMhwg2mgWSXJ+knywvLyLBJ
	 wJbAUz55kZ2tALxP685UyhBueV5mhMHWPImme+YI=
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.1/8.17.1) with ESMTP id 4ALFNuTQ040696;
	Thu, 21 Nov 2024 17:23:58 +0200
Date: Thu, 21 Nov 2024 17:23:56 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
To: Jinghao Jia <jinghao7@illinois.edu>
cc: Simon Horman <horms@verge.net.au>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Bill Wendling <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel <linux-kernel@vger.kernel.org>, llvm@lists.linux.dev,
        kernel test robot <lkp@intel.com>, Ruowen Qin <ruqin@redhat.com>
Subject: Re: [PATCH] ipvs: fix UB due to uninitialized stack access in
 ip_vs_protocol_init()
In-Reply-To: <a271e479-2a78-44b5-868d-3edc1f6c102a@illinois.edu>
Message-ID: <10eddab8-ebc3-083d-f912-d4aebcf9f9e6@ssi.bg>
References: <20241111065105.82431-1-jinghao7@illinois.edu> <f97ef69b-a15e-03ab-5e24-c1dfd3c4542b@ssi.bg> <a271e479-2a78-44b5-868d-3edc1f6c102a@illinois.edu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


	Hello,

On Tue, 19 Nov 2024, Jinghao Jia wrote:

> On 11/18/24 6:41 AM, Julian Anastasov wrote:
> > 
> > On Mon, 11 Nov 2024, Jinghao Jia wrote:
> > 
> >> Under certain kernel configurations when building with Clang/LLVM, the
> >> compiler does not generate a return or jump as the terminator
> >> instruction for ip_vs_protocol_init(), triggering the following objtool
> >> warning during build time:
> >>
> >>   vmlinux.o: warning: objtool: ip_vs_protocol_init() falls through to next function __initstub__kmod_ip_vs_rr__935_123_ip_vs_rr_init6()
> >>
...
> >> This gives later passes (SCCP, in particular) to more DCE opportunities
> 
> One small request: if you could help us remove the extra "to" in the above
> sentence when committing this patch, it would be great.
> 
...
> > 	Looks good to me, thanks! I assume it is for
> > net-next/nf-next, right?
> 
> I am actually not familiar with the netfilter trees. IMHO this should also be
> back-ported to the stable kernels -- I wonder if net-next/nf-next is a good
> tree for this?

	Then may be it is better to send [PATCHv2 net] after fixing
the above "to" and selecting proper commit for a Fixes line (probably
the initial commit 1da177e4c3f4 ?).

> >> -	char protocols[64];
> >> +	char protocols[64] = { 0 };
> >>  #define REGISTER_PROTOCOL(p)			\
> >>  	do {					\
> >>  		register_ip_vs_protocol(p);	\
> >> @@ -348,8 +348,6 @@ int __init ip_vs_protocol_init(void)
> >>  		strcat(protocols, (p)->name);	\
> >>  	} while (0)
> >>  
> >> -	protocols[0] = '\0';
> >> -	protocols[2] = '\0';
> >>  #ifdef CONFIG_IP_VS_PROTO_TCP
> >>  	REGISTER_PROTOCOL(&ip_vs_protocol_tcp);
> >>  #endif

Regards

--
Julian Anastasov <ja@ssi.bg>

