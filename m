Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794195203;
	b=sdauk6hFxf6iZm6dbUkAfYAH0nyzWXhSA3Y9MslOdxQKYDwPFpCDcffbO+ot06S9xGrv
	 vBSCGo03jUlz0JdNvZ6qPRSeVr45LsUtg8Jip8Hq+V2bqwb//PSR0Ul7PJzL2bxubVHrr
	 ngUUkFb4tZ1+0m7gbyFFxHJZ3Yz2ScXm0YNe1vFclOTV9DiPveFmUlDJj4NRPW43JUN8y
	 edSqJDBZAG/tJvLCTazcSkvsmpDoGYHCcxOnHCBGMApWdAPXDXgv9ho5oW0vblSsYkeI/
	 17iXzEP+2abxfpArhfQZwdVyoUaHC7a5XN/iNdWuZ1HdENrmk8FIBgiEWsO7XBmXnyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794195203;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=fSXkQFvYokTP7/zdJJbPcVi6eQ2VnCwRvk+/9wXmlm4=;
	b=DT8oPqXmCm2V6zaQdpvIlcR4Ap4KhH4aKuMZNl5bsSd3TZp1UIXi/f2urWEW4a0qyYac
	 XuuGq28T4XTtHE9ZY046kkoyT4z1GSVhxiZcsA9SJ+oR0cg/G82wqTJoHhL8xNvTAgmNN
	 y+h9m9SIcGlYnr2NoE/cUJMbHKJ4+8eUS6mQ6Ay66N9WtlLI7Pj/HjJ3g9EEdAydctztT
	 rwT8399Lq2MHN4tMQn5HPW5KqmXl6CwIWWH5EQiOcgYbo60D5UV7uom0tXEGwCBLFxTa2
	 ugrlDH66w7r9YJ5QkYDt2x8zSdoAPW2BAJ8xaumYMaJKvtPCJQkpBO8N7KkO7d4MgAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=r16QktDB;
	arc=none smtp.remote-ip=95.215.58.198
Received: from mta1.migadu.com (out-198.mta1.migadu.com [95.215.58.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E68606A322
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Nov 2026 03:33:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85E68606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=r16QktDB
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=fSXkQFvYokTP7/zdJJbPcVi6eQ2VnCwRvk+/9wXmlm4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794195200; v=1; x=1794800000;
 b=r16QktDBtgrve2lJtXf+k6gXH2JSF2UEsOe+NTp+H98CZ49wJ1Z7BJczkYK9T6Di3A8RlBwI
 ZmVorwwBFY77q8no22m3Of4AAcVaDARx6SWh9e1i206khZ08QONc2ddINsWniDSlUhMtxdUeT3n
 JGi03KI7efrxXB4Ev5FI0UVQ=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1b12e287425c2338;
	Mon, 09 Nov 2026 03:33:19 +0000
X-Mizu-Trace-ID: 1b12e287425c2338
X-Migadu-Flow: FLOW_OUT
Message-ID: <dbdb9385-89cd-4e4f-bfb8-b72510e8801b@linux.dev>
Date: Mon, 9 Nov 2026 11:33:09 +0800
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 00/14] net: annotate data-races around sysctl
 knobs
To: Jason Xing <kerneljasonxing@gmail.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
 Ido Schimmel <idosch@nvidia.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, Nikolay Aleksandrov <razor@blackwall.org>,
 Paul Moore <paul@paul-moore.com>, Matthieu Baerts <matttbe@kernel.org>,
 Mat Martineau <martineau@kernel.org>, Geliang Tang <geliang@kernel.org>,
 Julian Anastasov <ja@ssi.bg>, Allison Henderson <achender@kernel.org>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Xin Long <lucien.xin@gmail.com>, "D. Wythe" <alibuda@linux.alibaba.com>,
 Dust Li <dust.li@linux.alibaba.com>, Sidraya Jayagond
 <sidraya@linux.ibm.com>, Mahanta Jambigi <mjambigi@linux.ibm.com>,
 Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev,
 linux-security-module@vger.kernel.org, mptcp@lists.linux.dev,
 lvs-devel@vger.kernel.org, linux-rdma@vger.kernel.org,
 rds-devel@oss.oracle.com, linux-sctp@vger.kernel.org,
 linux-s390@vger.kernel.org
References: <20261109025425.328445-1-jiayuan.chen@linux.dev>
 <CAL+tcoDvFNAZubOjw9+Z1eyaVeiBzt_Xg3KMNucY879bg-ZLow@mail.gmail.com>
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <CAL+tcoDvFNAZubOjw9+Z1eyaVeiBzt_Xg3KMNucY879bg-ZLow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 11/9/26 11:11 AM, Jason Xing wrote:
> On Mon, Nov 9, 2026 at 10:55 AM Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
>> While testing the recent sysctl range fixes I noticed that a lot of our
>> sysctl knobs are read with plain loads while the handlers update them
>> with WRITE_ONCE() and no lock, so KCSAN reports them as data races. I
>> then used an LLM to go through every ctl_table under net/ and list the
>> readers that were left behind. This series annotates them with
>> READ_ONCE(), and adds WRITE_ONCE() to a few custom handlers and netlink
>> paths that store to the same fields with plain writes. Most of it is a
>> plain READ_ONCE() at each read; where a function reads the same knob
>> twice to make one decision, it now reads it once into a local, so the
>> comparison and the value it acts on cannot come from two different
>> writes.
>>
>> There are no Fixes tags. Done one knob per patch this would be well over
>> a hundred commits, so I grouped them by subsystem and feature instead to
>> keep the review manageable. If maintainers prefer, I can split it up
>> further with a Fixes tag on each one, as several smaller series.
> Over the last year, I've been thinking about the annotation stuff
> especially around sysctls, which, I suppose, shouldn't actually affect
> the real workload but does affect the outcome of the syzbot.
>
> Out of sheer curiosity, my question would be what is the point of
> trying to change all of them? Or what kind of benefits can we get from
> the big series?


Three things:

1. A plain load may be emitted twice by the compiler. ip_error() compares
peer->rate_tokens against ip_rt_error_cost and then subtracts it again;
if the sysctl changes in between, the u32 wraps. A few readers have that
shape and now read the knob once into a local.

2. Tearing is not involved here, all the fields are at most word sized.

3. The rest is the memory model: a lockless read of a field written with
WRITE_ONCE() is a data race unless it is marked
(tools/memory-model/Documentation/access-marking.txt). That is what KCSAN
reports, and why most of the series is plain READ_ONCE().


I think the benefit is doing it in one pass.


