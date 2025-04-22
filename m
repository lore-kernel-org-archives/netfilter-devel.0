Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33739A59
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Apr 2025 05:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745300656; cv=none; b=C1m1z0RM0eIONAjMuFej+6gT7nnwKN98wNQIZQVMKfqs0GM+rkMK1pycGNbwZ9C6q/JWWbyvkKhRh/8L1Yy9g7NSPj/usg+JFdlICGJ9YcZZlUu+dt2WHorHQVAZL1AAdC0o5KK+cBW7evPHtxrUzXQtFh3AIR+GWfuVLG79xhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745300656; c=relaxed/simple;
	bh=W4zuCjeS7cHmO4OBDLPOGOfsZ2aNksxQZYLhXxP2zmg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=esK1BOwhiLWGp7MOegoYbAV0oNZYYcx0qm7EXM4G6q0NPUbbVEDp0pbRuu0f17pqTM6OU/M04DB/JcU+cHzBN0hbS6QeK0OB2pyr1SR1VDXcR2dl7CYPD8hkLRLTQlutEj2bq/Ib1jTBjaz7vgukpeGelJriqhVn8ZtZn9jhIW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u76QU-0006ko-Jm; Tue, 22 Apr 2025 07:44:10 +0200
Date: Tue, 22 Apr 2025 07:44:10 +0200
From: Florian Westphal <fw@strlen.de>
To: Shaun Brady <brady.1345@gmail.com>
Cc: netfilter-devel@vger.kernel.org, ppwaskie@kernel.org
Subject: Re: [PATCH] netfilter: nf_tables: Implement jump limit for
 nft_table_validate
Message-ID: <20250422054410.GA25299@breakpoint.cc>
References: <20250422001643.113149-1-brady.1345@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422001643.113149-1-brady.1345@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Shaun Brady <brady.1345@gmail.com> wrote:
> The compile time limit NFT_DEFAULT_MAX_TABLE_JUMPS of 8192 was chosen to
> account for any normal use case, and when this value (and associated
> stressing loop table) was tested against a 1CPU/256MB machine, the
> system remained functional.

Keep in mind that one can register 1024 base chains, and that we have
at least 5 hook points (ingress -> prerouting -> forward -> postrouting
-> egress), so one could create a ruleset where a packet visits 41943040
chain jumps while in softirq context.

Furthermore, the largest ruleset I have archived here (iptables-save
kubernetes ruleset dump) has 27k jumps (many who are mutually exclusive
and user-defined chains that are always terminal), but nf_tables_api.c
lacks the ability to detect either of these cases).

With the proposed change, the ruleset won't load anymore.

> +u32 sysctl_nf_max_table_jumps __read_mostly = NFT_DEFAULT_MAX_TABLE_JUMPS;
> +EXPORT_SYMBOL(sysctl_nf_max_table_jumps);

Why is this exported?

> +static int netfilter_limit_control_sysctl_init(struct net *net)
> +{
> +	if (net_eq(net, &init_net)) {
> +		net->nf.nf_limit_control_dir_header = register_net_sysctl(
> +				net,
> +				"net/netfilter",
> +				nf_limit_control_sysctl_table);
> +		if (!net->nf.nf_limit_control_dir_header)
> +			goto err_alloc;
> +	}
> +	return 0;

I think you can just make this a global variable.
Or, thats the alternative, make this a pernet tunable as long as
the owning user_ns is the initial user namespace.

I think the idea is fine, but I'm not sure its going to work as-is.

Possible solutions to soften the impact/breakage potential:
- make the sysctl only affect non-init-net namespaces.
- make the sysctl only affect non-init-user-ns owned namespaces.

- Add the obseved total jump count to the table structure
Then, when validating, do not start from 0 but from the sum
 of the total jump count of all registered tables in the same family.
netdev family will need to be counted unconditionally.

This will allow to reject ruleset that create 1k base chains for each
family:hook point combination, which in turn would allow to increase the
default upper limit.
