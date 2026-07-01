Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718B23546D0
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jul 2026 01:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782870278; cv=none; b=R2ib57U0Oi7SR4cPAzxETC+y/bCj1X3qcXjEqcn769wWoRZRqxlwzExmIW0cxOZ3Of6Hjl89TVPoUnEGr6VaNmSS9y9Y3IqmhLXDpT3peh6Ron1Qb2N1mxLDLDylDZC4aszEVDOihTtQsl5qAlaP+/+jBQmN5Owx+GJVkG5BsT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782870278; c=relaxed/simple;
	bh=jRsgJjmI+AqxcRvBxNnD5mY0TBLj9txQubLJDJ4h0F4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FHuRmSzBRjUC27TsykuwLadSJnuZpy2FF1QW6gjSxWYYCl7uyse+zfLPlb9+TD99KcibfFaoIkGW4U9Jyf8kSC7cdRUME5jIUZAZzA89he/iwJkGXvpaoaeYdxJuxdqH1vfzBwJkN0ouFWe0zq9FIu/mluz4ikN8Jhk102SLYWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zy4NJ57T; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zy4NJ57T"
Message-ID: <1813a806-9250-492a-981d-07eb7f597f68@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782870264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oftETWuBQk5FPaBT3WxYgeIOyr6diVTFSnP+/t/MngM=;
	b=Zy4NJ57T+/d+LI2HhA6NDGp9d3fCg8zWniOnp6Bu1Qp+3I7/sngzyWIMkKNNt56DO9kfDq
	A18Oj46/8g7yASB5VxD8iWgxohwE8D3tgoNBeqemT3PXNPrjZsdQbpW9XTmpcc2jW9bzdv
	YDaYd9bAqLXU+0W1eIkUlFmQjh2RbPY=
Date: Wed, 1 Jul 2026 09:44:12 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH net] netfilter: nf_nat_masquerade: recalculate TCP TS
 offset when port is randomized
To: xietangxin <xietangxin@h-partners.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Cc: gaoxingwang <gaoxingwang1@huawei.com>, huyizhen <huyizhen2@huawei.com>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260629093408.3927103-1-xietangxin@h-partners.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <20260629093408.3927103-1-xietangxin@h-partners.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


On 6/29/26 5:34 PM, xietangxin wrote:
> Problem observed in Kubernetes environments where MASQUERADE target with
> --random-fully is configured by default. after commit
> 165573e41f2f ("tcp: secure_seq: add back ports to TS offset") TCP short
> connection QPS dropped from ~20000 to ~10000. This added source and
> destination ports into TS offset calculation.
>
> However, with MASQUERADE --random-fully, when multiple internal connections
> (e.g sport 10000,20000) are mapped to the same external port (e.g 30000),
> their TS offsets are calculated as ts_offset(10000) and ts_offset(20000).
> If the server reuses the TIME_WAIT slot from the first connection, there is
> a chance that ts_offset(20000) < ts_offset(10000), breaking TSval
> monotonicity for the same 4-tuple and causing RST packets:
>    Client -> Server 24870 -> 80 [SYN] TSval=2294041168
>    Server -> Client 80 -> 24870 [ACK] TSecr=2846236456
>    Client -> Server 24870 -> 80 [RST] Seq=855605690
>
> After nf_nat_setup_info() successfully assigns a new randomized
> source port, recalculate the TS offset using the new port and
> update the SYN packet's TSval accordingly.
>
> Test results on 4U4G VM with
> `./wrk -t8 -c200 -H "Connection: close" -d10s --latency http://5.5.5.5:80`
> Before:
>    random:10712 req/s, random-fully:10986 req/s
> After:
>    random:21463 req/s, random-fully:19181 req/s
>
> Fixes: 165573e41f2f ("tcp: secure_seq: add back ports to TS offset")
> Cc: stable@vger.kernel.org


I'd treat it as a feature not a fix.


> Closes:https://lore.kernel.org/all/92935c00-e0be-4591-ac44-5978c7804d57@yeah.net/
> Signed-off-by: xietangxin <xietangxin@h-partners.com>
> ---
>   net/netfilter/nf_nat_masquerade.c | 91 ++++++++++++++++++++++++++++++-
>   1 file changed, 89 insertions(+), 2 deletions(-)
>
> diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
> index 4de6e0a51701..8c9ca5a051cc 100644
> --- a/net/netfilter/nf_nat_masquerade.c
> +++ b/net/netfilter/nf_nat_masquerade.c
> @@ -6,8 +6,11 @@
>   #include <linux/netfilter.h>
>   #include <linux/netfilter_ipv4.h>
>   #include <linux/netfilter_ipv6.h>
> +#include <linux/tcp.h>
>   
> +#include <net/tcp.h>
>   #include <net/netfilter/nf_nat_masquerade.h>
> +#include <net/secure_seq.h>
>   
>   struct masq_dev_work {
>   	struct work_struct work;
> @@ -24,6 +27,76 @@ static DEFINE_MUTEX(masq_mutex);
>   static unsigned int masq_refcnt __read_mostly;
>   static atomic_t masq_worker_count __read_mostly;
>   
> +static __be32 *tcp_ts_option_ptr(const struct sk_buff *skb)
> +{
> +	const struct tcphdr *th;
> +	unsigned char *ptr;
> +	unsigned char opsize;
> +	unsigned int optlen, offset;
> +
> +	th = tcp_hdr(skb);
> +	optlen = (th->doff - 5) * 4;
> +	ptr = (unsigned char *)(th + 1);
> +	offset = 0;
> +
> +	while (offset < optlen) {
> +		unsigned char opcode = ptr[offset];
> +
> +		if (opcode == TCPOPT_EOL)
> +			break;
> +		if (opcode == TCPOPT_NOP) {
> +			offset++;
> +			continue;
> +		}
> +
> +		if (offset + 1 >= optlen)
> +			break;
> +
> +		opsize = ptr[offset + 1];
> +		if (opsize < 2 || offset + opsize > optlen)
> +			break;
> +
> +		if (opcode == TCPOPT_TIMESTAMP && opsize == TCPOLEN_TIMESTAMP)
> +			return (__be32 *)(ptr + offset + 2);
> +
> +		offset += opsize;
> +	}
> +
> +	return NULL;
> +}
> +
> +static void masquerade_update_tcp_ts_offset(struct nf_conn *ct, struct sk_buff *skb)
> +{
> +	__be32 *tsptr;
> +	struct net *net;
> +	struct tcphdr *th;
> +	struct tcp_sock *tp;
> +	union tcp_seq_and_ts_off st;
> +	struct nf_conntrack_tuple *tuple;
> +
> +	th = tcp_hdr(skb);
> +	net = nf_ct_net(ct);
> +	tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
> +

why use reply not original, or do I miss something ?


