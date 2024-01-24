Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549A6132C25;
	Wed, 24 Jan 2024 19:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706125259; cv=none; b=R/5HLDB/xwW09BXaKYGWgVQYCXHmFEoB9URllE9akb27w0Y+FyV9OX9nR+FKWmc19fWVS21US44LaSOtrRY7CqSPVZZ9ZoxqMJHC9AMBdxG0YWAB5IFOCMpW8ZSjIEj0KSX9MV6M5PNCf6+9K74s+eK29QZySGbVTbRnMytA2os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706125259; c=relaxed/simple;
	bh=pqY2OeRBKAHbZTEwnB+CHG0H7XQtw6Do1NPg5x5BLvA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bb7u7802O6DAcv5bdFmykmkQ1sY+uQ/8kxWS4wjaFPThJd7zaqU42eSVaD6JRfNAxGR8hIVaTQVz5epEQxOiqzX7wBDtDxIW7f4jt6L8MBNVT/7ULA2PHjVSrIcTw9DAI+Uo7UTZZNaNQ/QUtgneNO6YZjcGRRNC7g7dlbM5nk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h6dcMgO3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h6dcMgO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F284C433F1;
	Wed, 24 Jan 2024 19:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706125258;
	bh=pqY2OeRBKAHbZTEwnB+CHG0H7XQtw6Do1NPg5x5BLvA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=h6dcMgO3WqlGoTkerCpx0ufw2nOB8j9pxw3rlnUfhe2cpmIAu2VA2nHH6K40ehlgI
	 1BpxRd8njMF0/YMXXkMzwD0fli44R/4ALU0jiLDthf81KgtfMbCsV3gA34Cgabd33T
	 sBA49wfMjgmNSvQHUubtwazHDJngIggNk+lk1pZdnlxCfxHkfwq9traZ60jGxJMMXA
	 yApUyoPK0/8+q5BYqjvRSFJgqtFsNxpRRjVsgG0QJlc5bl3AlD/uwqgUFxyDVzTSYp
	 gw08g41dmAcsVIcXBoPjUQegaPLmZed5n6DZTKkeojHOCkLc2UM+dH+x/AyD69lDL8
	 b1Q+nikbR47fg==
Date: Wed, 24 Jan 2024 11:40:57 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>, David Ahern
 <dsahern@kernel.org>, coreteam@netfilter.org,
 "netdev-driver-reviewers@vger.kernel.org"
 <netdev-driver-reviewers@vger.kernel.org>, Hangbin Liu
 <liuhangbin@gmail.com>, netfilter-devel@vger.kernel.org
Subject: Re: [netfilter-core] [ANN] net-next is OPEN
Message-ID: <20240124114057.1ca95198@kernel.org>
In-Reply-To: <ZbFiF2HzyWHAyH00@calendula>
References: <20240122091612.3f1a3e3d@kernel.org>
	<Za98C_rCH8iO_yaK@Laptop-X1>
	<20240123072010.7be8fb83@kernel.org>
	<d0e28c67-51ad-4da1-a6df-7ebdbd45cd2b@kernel.org>
	<65b133e83f53e_225ba129414@willemb.c.googlers.com.notmuch>
	<20240124082255.7c8f7c55@kernel.org>
	<20240124090123.32672a5b@kernel.org>
	<ZbFiF2HzyWHAyH00@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 Jan 2024 20:16:39 +0100 Pablo Neira Ayuso wrote:
> > Ah, BTW, a major source of failures seems to be that iptables is
> > mapping to nftables on the executor. And either nftables doesn't
> > support the functionality the tests expect or we're missing configs :(
> > E.g. the TTL module.  
> 
> I could only find in the listing above this:

Thanks for taking a look!

> https://netdev-2.bots.linux.dev/vmksft-net-mp/results/435141/37-ip-defrag-sh/stdout
> 
> which shows:
> 
>  ip6tables v1.8.8 (nf_tables): Couldn't load match `conntrack':No such file or directory
> 
> which seems like setup is broken, ie. it could not find libxt_conntrack.so

Hm, odd, it's there:

$ ls /lib64/xtables/libxt_conntrack.so
/lib64/xtables/libxt_conntrack.so

but I set a custom LD_LIBRARY_PATH, let me make sure that /lib64 
is in it (normal loaded always scans system paths)!

> What is the issue?

A lot of the tests print warning messages like the ones below.
Some of them pass some of them fail. Tweaking the kernel config
to make sure the right CONFIG_IP_NF_TARGET_* and CONFIG_IP_NF_MATCH_*
are included seem to have made no difference, which I concluded was
because iptables CLI uses nf_tables here by default..

[435321]$ grep -nrI "Warning: Extension" .
./6-fib-tests-sh/stdout:305:# Warning: Extension MARK revision 0 not supported, missing kernel module?
./6-fib-tests-sh/stdout:308:# Warning: Extension MARK revision 0 not supported, missing kernel module?
./6-fib-tests-sh/stdout:316:# Warning: Extension MARK revision 0 not supported, missing kernel module?
./6-fib-tests-sh/stdout:319:# Warning: Extension MARK revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:12:# No GRO                                  Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:13:# Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:14:# Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:16:# GRO frag list                           Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:17:# Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:18:# Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:19:# Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:21:# Warning: Extension DNAT revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:23:# GRO fwd                                 Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:24:# Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:38:# GRO frag list over UDP tunnel           Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:39:# Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:40:# Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:41:# Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:43:# Warning: Extension DNAT revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:45:# GRO fwd over UDP tunnel                 Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:46:# Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:61:# No GRO                                  Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:62:# Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:63:# Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:65:# GRO frag list                           Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:66:# Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:67:# Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:68:# Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:72:# GRO fwd                                 Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:73:# Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:88:# GRO frag list over UDP tunnel           Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:89:# Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:90:# Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:91:# Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:95:# GRO fwd over UDP tunnel                 Warning: Extension udp revision 0 not supported, missing kernel module?
./18-udpgro-fwd-sh/stdout:96:# Warning: Extension udp revision 0 not supported, missing kernel module?
./37-big-tcp-sh/stdout:17:# Warning: Extension length revision 0 not supported, missing kernel module?
./37-big-tcp-sh/stdout:19:# Warning: Extension length revision 0 not supported, missing kernel module?
./37-big-tcp-sh/stdout:22:# Warning: Extension length revision 0 not supported, missing kernel module?
./37-big-tcp-sh/stdout:24:# Warning: Extension length revision 0 not supported, missing kernel module?
./56-xfrm-policy-sh/stdout:11:# Warning: Extension policy revision 0 not supported, missing kernel module?
./56-xfrm-policy-sh/stdout:13:# Warning: Extension policy revision 0 not supported, missing kernel module?
./54-amt-sh/stdout:94:# Warning: Extension TTL revision 0 not supported, missing kernel module?

