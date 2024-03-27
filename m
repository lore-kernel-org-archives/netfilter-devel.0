Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A57512E1E3;
	Wed, 27 Mar 2024 14:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711548260; cv=none; b=h7pva0Rg78SLAsgHFguI869ze6Rh417XI06/8oRlgdOjnk98ts/d43d/m++6PFLZ97RCoF2Ea7T4G9Ct1v6BWSRuCnzzTO5RN3cpA2Bit3OOtkOPDCEJqy0KxPxwWEjsK9YHlcJchMGQNpc+8xWhKy5ybXIjmkh68lrWG6NCZfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711548260; c=relaxed/simple;
	bh=DqrslppWQirH3WLvNAHhXmZGAY9viAu3iV+BThcsJb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ComuIVMbPqmF0m7ZkVk+hUvL6Nv0Xml9c7n8ZKtN07LEKKvl8kpc4NmTggL3KqgZg229UmUzcUw1inmoYwz5EqKInrFLZ5IHxXrbcZ3QqhxSzJHlHLeJqgYNjeTzFn3vv+mMay6HT0Iuz8vZoMNCRo7a9PWBOSNen9zMejVUNek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fkZ4ZzMM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fkZ4ZzMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48161C433C7;
	Wed, 27 Mar 2024 14:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711548260;
	bh=DqrslppWQirH3WLvNAHhXmZGAY9viAu3iV+BThcsJb0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fkZ4ZzMMjaqBuJiYxlOM/67p/g9Uml62Y6jnTGncz7q35Cu/Vgpm+lMryFKOthJyq
	 bKo4Exa8cm1LMXbN6fYBtVhQbcWc263QEo8gau4OmpfiBo4Y4nahJMKSEPKA72ykYa
	 AOOgcl7p5t5mHOOYk02TfuK6KgHCRkFtVsWc1K92hocPUlXfNi1Yee9D+iFr7UL0TG
	 3LuusH6h0frAfQGYnik4WwWj2CCm+qe44xcGesMvpHFg2ariHJS7Ks+/X+2N+ULgMY
	 yEFWOFrOgGOklWZfdxjqj7WZsTBGlt2iviGAsN1nDGRD3s+5zxuBF0TqVCSKY4vPQg
	 kg77AOlJKEQzg==
Date: Wed, 27 Mar 2024 14:04:15 +0000
From: Simon Horman <horms@kernel.org>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Kuniyuki Iwashima <kuni1840@gmail.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, syzkaller <syzkaller@googlegroups.com>
Subject: Re: [PATCH v1 nf] netfilter: arptables: Select NETFILTER_FAMILY_ARP
 when building arp_tables.c
Message-ID: <20240327140415.GH403975@kernel.org>
References: <20240326041552.19888-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240326041552.19888-1-kuniyu@amazon.com>

On Mon, Mar 25, 2024 at 09:15:52PM -0700, Kuniyuki Iwashima wrote:
> syzkaller started to report a warning below [0] after consuming the
> commit 4654467dc7e1 ("netfilter: arptables: allow xtables-nft only
> builds").
> 
> The change accidentally removed the dependency on NETFILTER_FAMILY_ARP
> from IP_NF_ARPTABLES.
> 
> If NF_TABLES_ARP is not enabled on Kconfig, NETFILTER_FAMILY_ARP will
> be removed and some code necessary for arptables will not be compiled.
> 
>   $ grep -E "(NETFILTER_FAMILY_ARP|IP_NF_ARPTABLES|NF_TABLES_ARP)" .config
>   CONFIG_NETFILTER_FAMILY_ARP=y
>   # CONFIG_NF_TABLES_ARP is not set
>   CONFIG_IP_NF_ARPTABLES=y
> 
>   $ make olddefconfig
> 
>   $ grep -E "(NETFILTER_FAMILY_ARP|IP_NF_ARPTABLES|NF_TABLES_ARP)" .config
>   # CONFIG_NF_TABLES_ARP is not set
>   CONFIG_IP_NF_ARPTABLES=y
> 
> So, when nf_register_net_hooks() is called for arptables, it will
> trigger the splat below.
> 
> Now IP_NF_ARPTABLES is only enabled by IP_NF_ARPFILTER, so let's
> restore the dependency on NETFILTER_FAMILY_ARP in IP_NF_ARPFILTER.

...

> Fixes: 4654467dc7e1 ("netfilter: arptables: allow xtables-nft only builds")
> Reported-by: syzkaller <syzkaller@googlegroups.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Reviewed-by: Simon Horman <horms@kernel.org>

...
