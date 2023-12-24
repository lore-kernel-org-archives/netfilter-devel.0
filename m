Received: from smtp.forwardemail.net (smtp.forwardemail.net [149.28.215.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F09E809;
	Sun, 24 Dec 2023 02:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=faucet.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fe-bounces.faucet.nz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=faucet.nz header.i=@faucet.nz header.b="wInof650"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=faucet.nz;
 h=Content-Transfer-Encoding: MIME-Version: References: In-Reply-To:
 Message-Id: Date: Subject: Cc: To: From; q=dns/txt; s=fe-4ed8c67516;
 t=1703386128; bh=F8jSH+IjG8VuuDuvNGsnUR0Q70IsR9+kyvZL2HMi7f0=;
 b=wInof650V9xQy4r9+GiKQaGua1nHUoYFNZ0j1A7IpkM8wAQxnd6A8FGIiqmmYTNueb2U+wxwF
 zxCxxVS3QhoIEqPA5cTeSDmYTUB5cjiwv4gYZmnjxh7V1VxXYqbiVIadaNaxV9XQCA+IGl8KTQb
 iH/g8q/IOzowSvqn2aYW4lc=
From: Brad Cowie <brad@faucet.nz>
To: horms@kernel.org
Cc: aconole@redhat.com, brad@faucet.nz, coreteam@netfilter.org,
 davem@davemloft.net, dev@openvswitch.org, edumazet@google.com,
 fw@strlen.de, kadlec@netfilter.org, kuba@kernel.org,
 linux-kernel@vger.kernel.org, lucien.xin@gmail.com,
 netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 pabeni@redhat.com, pablo@netfilter.org
Subject: Re: [PATCH net] netfilter: nf_nat: fix action not being set for all ct states
Date: Sun, 24 Dec 2023 15:47:25 +1300
Message-Id: <20231224024725.80516-1-brad@faucet.nz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231223211306.GA215659@kernel.org>
References: <20231223211306.GA215659@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Report-Abuse-To: abuse@forwardemail.net
X-Report-Abuse: abuse@forwardemail.net
X-Complaints-To: abuse@forwardemail.net
X-ForwardEmail-Version: 0.4.40
X-ForwardEmail-Sender: rfc822; brad@faucet.nz, smtp.forwardemail.net,
 149.28.215.223
X-ForwardEmail-ID: 65879c1085a9bad88417ac0b

On Sun, 24 Dec 2023 at 10:13, Simon Horman <horms@kernel.org> wrote:
> Thanks Brad,
>
> I agree with your analysis and that the problem appears to
> have been introduced by the cited commit.

Thanks for the review Simon.

> I am curious to know what use case triggers this /
> why it when unnoticed for a year.

We encountered this issue while upgrading some routers from
linux 5.15 to 6.2. The dataplane on these routers is provided
by an openvswitch bridge which is controlled via openflow by
faucet. These routers are also performing SNAT on all traffic
to/from the wan interface via openvswitch conntrack openflow
rules.

We noticed that after upgrading the linux kernel, traceroute/mtr
no longer worked when run from clients behind the router.
We eventually discovered the reason for this is that the
ICMP time exceeded messages elicited by traceroute were
matching openflow rules with the incorrect destination ip,
despite there being an openflow rule to undo the nat.
Other packets in the established or new state matched the
expected openflow rules.

A git bisect between 5.15 and 6.2 showed that this change in
behaviour was introduced by commit ebddb1404900. After the
above patch is applied our routers perform nat correctly
again for traceroute/mtr.
