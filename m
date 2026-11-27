Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795760307;
	b=IPkZ8pB4aR/4+44AOrMZJ/n4teEG1N47heubZ2JDRqhApmmJoTywh8idFaxuh/QTF9Rq
	 ZXs9s9F8hX+TvcFhC94aJBOdI2xdpFLHz/NjXh7FMRJPPTC9EY0yttz5vGshumUdJJe9u
	 bAXfQBkyEOCNd9ofgR3te9zjldZ/fHuL7jHaLJ+eJDRTg51r36dONyFuQls3O8eEo84Vi
	 aHhVmqCibjXSrbKtmNEaJA28qh/K03SqY2KexGwTaXRn3TKJzgC+5hDl/O25HwiBcJnNl
	 XyzaANq7U74mM8lDUzhSRNTIHWxFIYdxBG23PPyl4VeG4356l0/tAPGnTYZpru6j/Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795760307;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Xall2LvYqrNEWJ3haGr3baDKY0fqS4yjvxamjxNnjGY=;
	b=FS4YDFoBjTGO4/zvJP293kX8aVjAWSBn0qGkeKnNUT4uvjM5XS3rLR+V1+NpuwpRxcor
	 mdHt03B/YOxWTTwqAGSBAXblmvi9u0NvtuZHTzxA+8AKG4Dwd+s/q0l049mdgeWY+pTem
	 2B0vEdbeUfJVEz02R5MXShavv3qOB5LSdNXZ5Ii0VauW1kTU4Q0eQGPcaEiyFT7zqvMlY
	 9o6qx3MEXg+YJJGG917SDZxwuOOjyH+DWu5gcTM3ql6TjB4siZyhjHKi2W/W0mJWBRdkA
	 S1XsJFNy+JqxQDnziyk4gjLuCnaV98z2SKnwh1m7+XXvX+7EELuq9JFWOsa4Br4K3DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sKr55MTO;
	arc=none smtp.remote-ip=91.218.175.55
Received: from mta0.migadu.com (out-55.mta0.migadu.com [91.218.175.55])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1F5606A321
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Nov 2026 06:18:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D1F5606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sKr55MTO
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=kS24aWEDVFAGZg9av7QpzpXRdTf89yuZQQWrd8Pe7YI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795760304; v=1; x=1796365104;
 b=sKr55MTON/+6jrOYoyP4mbHJKogHVXu9Sy8xuEmw89uAYd4PLeivI6FcOlRQwTBLAeu3cSVF
 uh7hEohrUeSmHTgPd+SFC4C0L1YiokNOradNPZrh86Ik6+ihBWo4j2q8XICHqB01t4IjwRlu1z1
 xSzqw+oyTwgaacapk//YEWLo=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7a6dd275991888ae;
	Fri, 27 Nov 2026 06:18:24 +0000
X-Mizu-Trace-ID: 7a6dd275991888ae
X-Migadu-Flow: FLOW_OUT
Message-ID: <d5c55d47-8651-4c75-a0b6-2734a1394a9e@linux.dev>
Date: Fri, 27 Nov 2026 15:18:02 +0900
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
Subject: Re: [PATCH net-next v1 0/6] net: avoid stack canaries in TCP/IPv4
 fast paths
To: gang.yan@linux.dev, netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.fastabend@gmail.com>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>, Matthieu Baerts
 <matttbe@kernel.org>, Mat Martineau <martineau@kernel.org>,
 Geliang Tang <geliang@kernel.org>, David Ahern <dsahern@kernel.org>,
 Ido Schimmel <idosch@nvidia.com>, Stanislav Fomichev <sdf@fomichev.me>,
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org, mptcp@lists.linux.dev,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 Xuanqiang Luo <luoxuanqiang@kylinos.cn>, david.laight.linux@gmail.com
References: <20261124130631.1886963-1-xuanqiang.luo@linux.dev>
 <133c1ca98af6beb48c0db1e6bb539a2a76ccda49@linux.dev>
From: Xuanqiang Luo <xuanqiang.luo@linux.dev>
In-Reply-To: <133c1ca98af6beb48c0db1e6bb539a2a76ccda49@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/11/26 at 17:48 gang.yan@linux.dev wrote:
> November 24, 2026 at 9:06 PM, "Xuanqiang Luo" <xuanqiang.luo@linux.dev mailto:xuanqiang.luo@linux.dev?to=%22Xuanqiang%20Luo%22%20%3Cxuanqiang.luo%40linux.dev%3E > wrote:
> 
> 
>>
>> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
>>
>> With CONFIG_STACKPROTECTOR_STRONG=y, a function that has a local array or
>> passes the address of one of its locals to another function needs a stack
>> canary. The canary is set up and checked on every call, also when the
>> local is only used on a path that almost never runs.
>>
>> This series removes the canary from functions of the TCP/IPv4 fast paths,
>> by returning results by value, by using storage that is not on the stack,
>> or by not calling a function that has nothing to do.
>>
>> Patch 1 returns the two mptcp_space() values in a structure, so that
>> __tcp_select_window() no longer needs a canary.
>>
>> Patch 2 changes ip_neigh_gw4() to take a pointer to the address, like
>> ip_neigh_gw6(), so that ip_finish_output2() no longer needs a canary.
>>
>> Patch 3 uses pskb_may_pull() in icmp_filter(), so that
>> raw_local_deliver() no longer needs a canary.
>>
>> Patch 4 turns skb_try_coalesce() into an inline wrapper over a function
>> returning its results by value, so that its callers no longer need a
>> canary because of it.
>>
>> Patch 5 returns the result of the TCP receive coalescing by value, so
>> that tcp_rcv_established() and tcp_data_queue() no longer need a canary.
>>
>> Patch 6 calls bpf_skops_write_hdr_opt(), which needs a canary, only if a
>> BPF program reserved room for TCP options.
>>
>> The bloat-o-meter numbers are from gcc 16.2 on x86_64. The functions
>> named in patches 1 to 5 also lose their canary with clang 23.1.6 on
>> x86_64, with and without ThinLTO, and on arm64.
>>
> 
> Hi Xuanqiang,
> 
> Thanks for this series. Besides the code size, do you have any runtime perf
> numbers (TCP_RR, cycles per packet...)? I think it may help the maintainers
> judge the real gain.
Hi Gang,

I omitted runtime numbers from the cover letter because earlier cross-NIC
TCP_RR runs were within boot-to-boot noise, and I did not want to overstate
the gain. I re-ran the full 6-patch series against its base commit
(a4c450594f5d) in a tighter setup on an x86_64 server (Hygon C86-4G,
ConnectX-5 10GbE mlx5, GCC 12.3, CONFIG_STACKPROTECTOR_STRONG=y, identical
.config, nokaslr, boost off, isolated CPUs/IRQs, busy_read=0, 3 alternating
boots per kernel x 4 runs):

1. Single-CPU loopback 1-byte TCP_RR (both endpoints on 1 CPU running the
    kernel under test, 99.9% busy with no cross-CPU lock contention; each
    RR counts 2 TX + 2 RX = 4 Tcp InSegs+OutSegs):
    - instructions:k / tx:  33,562.3 -> 33,410.6 (-151.8, -0.45%, CV 0.01%)
    - instructions:k / seg:  8,372.8 ->  8,336.1 ( -36.8, -0.44%, CV 0.02%)
    - branches:k / tx:       7,627.9 ->  7,604.4 ( -23.5, -0.31%, CV 0.03%)
    - cycles:k / tx:        48,883.8 -> 48,613.8 (-270.0, -0.55%)
    - throughput:           52,804   -> 53,068 tps (+0.50%)

2. Cross-host 10GbE mlx5 8-flow 1-byte TCP_RR (server CPU-bound on 1 app
    CPU + 1 IRQ CPU, client pinned on a fixed peer kernel):
    - instructions:k / pkt: 12,040.6 -> 11,946.0 ( -94.6, -0.79%, CV 0.43%)
    - cycles:k / pkt:       19,652.2 -> 19,450.1 (-202.1, -1.03%, CV 0.52%)
    - throughput:           79,455   -> 79,883 tps (+0.54%)

3. Loopback small-write TCP_STREAM (-m 512 -D, 2 CPUs):
    - instructions:k / seg:  5,805.6 ->  5,713.7 ( -91.9, -1.58%)
    - cycles:k / seg:        8,538.5 ->  8,416.8 (-121.7, -1.42%)
    - throughput:            641.8   ->  650.5 Mbit/s (+1.37%)
    (Note: in the 2-CPU / multi-flow cases above, perf shows part of the
     larger per-packet drop comes from fewer spinlock-slowpath and idle-loop
     samples in addition to the direct TCP path savings; test 1 isolates
     the direct instruction/branch reduction.)

4. perf record (cycles:k and instructions:k) confirms
    bpf_skops_write_hdr_opt() drops from 0.04-0.12% to 0.00% across all
    profiled workloads, with consistent drops in tcp_rcv_established(),
    __tcp_transmit_skb(), and __tcp_select_window().

One caveat to be transparent: on a loopback 1-byte UDP_RR control (which
only exercises patch 2's ip_finish_output2() canary removal),
instructions:k/tx changed by the expected -23.2 insns/tx (-0.07%) and
branches:k/tx was flat (+0.02%), yet wall-clock tps/cycles still shifted
by -0.80%/+0.68% due to fixed code-layout/IPC differences under nokaslr.

So the reliable runtime signal here is the deterministic drop in kernel
instructions and branches (~152 insns / ~23.5 branches per loopback TCP_RR)
and the disappearance of bpf_skops_write_hdr_opt() from the profile, while
wall-clock TCP_RR tps/cycles (~0.5%) remain in the same range as
code-alignment effects on this machine.

Thanks,
Xuanqiang
