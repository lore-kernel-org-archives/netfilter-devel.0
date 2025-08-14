Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59162E7BAF;
	Thu, 14 Aug 2025 12:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755175394; cv=none; b=KwLyklr6Ije+WUrnGrIxbS09H2ZbNBQgpvSg+F6vi4P4+4YB41QBZGwspL9DraYoJiqzxrjZskj7Xgik+WAM6mTdKhPHhCvM0q1u5Gw+6EdnKWRorLkXkm7//dRWsqVUV5I9wDi5tQhs/Uu/ecB1qraxIi2u/YUQOErKTkn+vN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755175394; c=relaxed/simple;
	bh=/7VemqUpz358TXgw0z5926OrXpJ16txRBJgcj0MK/WU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IpHya/ZUAiobI8a3QtWRHQ1UikyCG/t5LJhLTRKLoBgjm5Zzx3lATM+Z+Qj2IMn+tCzZ8iKZZeUvCEXJ9Skyog1ZkMH/YdWaSJrPCkFQaKfxxrgx3HVObGWeufMei8p2kYvzIKKl/uFZRwAcw58GUkjWHd+W7KDJW2jsseIb8bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CA35C60309; Thu, 14 Aug 2025 14:43:03 +0200 (CEST)
Date: Thu, 14 Aug 2025 14:43:03 +0200
From: Florian Westphal <fw@strlen.de>
To: gaoxingwang <gaoxingwang1@huawei.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net, bridge@lists.linux.dev,
	netfilter-devel@vger.kernel.org, idosch@nvidia.com,
	pablo@netfilter.org, kadlec@netfilter.org, yanan@huawei.com,
	xuchunxiao3@huawei.com, huyizhen2@huawei.com
Subject: Re: netfilter: br_netfilter:NS packet was incorrectly matched by the
 nftables rule
Message-ID: <aJ3Z1_-mm67LOID-@strlen.de>
References: <20250814120753.1374735-1-gaoxingwang1@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814120753.1374735-1-gaoxingwang1@huawei.com>

gaoxingwang <gaoxingwang1@huawei.com> wrote:
> Hello,everyone:
> In my test case, the container (with net.bridge.bridge-nf-call-ip6tables=1 set) attempts
> to ping the host's IPv6 address through a bridged network. Simultaneously, tcpdump is used to monitor
> the bridge, and it is observed that the ping fails.
> 
> The direct cause of the ping failure is that the NS packet matches the "ct state invalid drop"
> rule in nftables and is therefore discarded.
> 
> The commit 751de2012eafa4d46d80 introduced a modification to bridge traffic handling. When the bridge
> is in promiscuous mode, it resets the conntrack state of the packets. 
> >	if (promisc) {
> >		nf_reset_ct(skb);
> >		return NF_ACCEPT;
> >	}
> IPv6 NS packets are untracked by default.When an IPv6 NS packet passes through the bridge and the bridge
> is in promiscuous mode, the conntrack state of the packet is reset. If there is a firewall rule
> such as "ct state invalid drop," the IPv6 NS packet will be deemed invalid and dropped, leading to
> a ping failure issue.
> 
> Is this a bug, or is there an issue with my analysis? 

net.bridge.bridge-nf-call-ip6tables and bridge conntrack are
incompatible.

Either use ipv6 conntrack with net.bridge.bridge-nf-call-ip6tables or
disable net.bridge.bridge-nf-call-ip6tables.
