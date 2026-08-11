Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9CC4248C8
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2026 09:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786440136; cv=pass; b=E0b49LuAUzaYKdhUv0EoAuSlkAwPXBzDy+qmxlc+ivhr9TuEuEKOZN8nxjjoFL1WwbcTyMhL9hy2YUxYfl0LRd5PX0SjKTC3N1oLrdNCFoRb+UPjdoU8jlcccuOKLOpFHrQYEfBRHLkbRVc8pKFiOsk7QevjjotrVhOJeMmxAJA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786440136; c=relaxed/simple;
	bh=UyqOqTXfdCKJJ8uu1rhMMIWAc76R/YHa+u/4VTr2ttA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=RdUrSSfVb1fqglJ4xLimNnk6km6T0iND7iHH5LOdvTruZRVNP+KTAYxrqy3i1/TAZ2om65G87KKo88iWzQTHljay1WWS5CEFSp3SdvEAWcvHi1BEqC9SmmJpuhzg/FkPMGD2GLB1IhlaqpebD/GQMz+a4r2yfWl587rGaKqXzGo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KSRutBxz; arc=pass smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KSRutBxz"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-82113c53aeaso7788197b3.1
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2026 02:22:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786440133; cv=none;
        d=google.com; s=arc-20260327;
        b=r+DFsLPH/I3CjhDniqXJqlhhPoKTbmX7eSE2NJb2V731rd4IJOyDyMob9C2fnqftX/
         9Dk6fjhmjk4rIJWNg0hnzV7vCGiCx2s6yV2oHhgJripGKf7NwyuVGS2BEbuZDVV+qPbw
         VRf4F1geLYT7hk8g5eUwHRFMeKPKoh8eAXqobhdAF4r6DOr3r1qrFeBJusogOLbzCkKY
         lpGDPGOPvEhCUJkdDzPC2noqzXddSmLonf8G9KbJWpCzV7mAGucLnmrUJrQLLmeiEiCR
         gxo2Q29WbTJpA3EqC13QKGnMNTl4GxPv4tJyupo1GgXl55d4L/atBpR2L5pvqqEiTlDB
         79LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=r5O6k0DY9DjFJdDFPov26RfyitfELd8eUk6GOPlDyJk=;
        fh=cLe/kE8DnlMTRpQBnl5xbUCeOm+0+18VcHsWldvcgeo=;
        b=JPq1IExOFR6zuLmT6kMtHhRYimdsByXMfTBvifwL2QWbEaKsLzZanvAU4XL9MmjmXL
         /+2bp/qyU47bjqjjfEGDrCCcfV7B9BkQspcJdot6DqlyMuavFK8Tt7ib3cbgMkzhqPIb
         +J3ucfrevQOUBzQuAifBX3HaSF1c673hcn+4oqK5VXI0jWbTodiTQViAJyncIJYZDe7X
         fRq+snDcM1mm/P3J8IePuB1COzcfd48/oONKpwFB0NqqJXENgUkd9tksXX2DAMn64so5
         Yeoia2eXTqArb1lBSFYKdWu+gW6b+9F43SwW5clGDACG++cPx44ADd7FozT6PeL7MwBl
         l0Lg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786440133; x=1787044933; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=r5O6k0DY9DjFJdDFPov26RfyitfELd8eUk6GOPlDyJk=;
        b=KSRutBxzfT3FTzf2Y5ZUXkd/SlQGkecvxrFCS5NIIEFOsL5J/yMl9VpMRyGBwAr6Nd
         4AJRwPuGQGf7Kw29vr4Wf9JEWvR/ApfmkR1MN3JrOCn/EQK+xfliKyf13sICLQTPs6TX
         uvG7ibtIyImwJYB2AboxC3KLQBaU80oE9/r8mZLepQzxXVdVh6XOsbam8/i3aRhgTFNX
         64tACae6m7t3LI7og59CQDnpme/D7Jh96vGqEoCnB3ZHzn45zZqvV+JJRb9Tb4e5f6iL
         opq5x855hG9f7jpQO8Yly1c6L7Q7RazxX3ZrUjDFTZFNgSPss2U5gj6ociuhwNJ0TOMb
         nq5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786440133; x=1787044933;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=r5O6k0DY9DjFJdDFPov26RfyitfELd8eUk6GOPlDyJk=;
        b=Owiey1VCmOFjfq2rXKPRNo9Xl/jHq1BXyCX8F3Z6PkImcrdURgyJAGdHkVrZrIqQ7H
         ztEHNu4ZVkltkTmxtsXzupVf9MP4I05TxLybcIZunQ/xAsDFEtJ9xDpsqUiMpG9ol35I
         D4woGq98lIO/QPlWKTYQlrn4uAkDjO6BIaZ2c4ExEPhkSuwlgtmBoz6SW9kCpPCLdWRf
         L/jq3blUna/eOpN2whtq9lLtqwwQSkrHIu7zOfTvEIkhLXG4Xn906TuF56QJbpuP0Gnf
         gF8yTvkw6h+CskCe2n+JZt7lCVrNK15Rg85kKXl8GHx6lDJPah89R5WKT7CXUWaZ/HoQ
         Rqvw==
X-Forwarded-Encrypted: i=1; AHgh+RrZq+nMHp37e6au28h8zw6K21BNsqPUkEiEtj7tjAe/4c9ZNi9QsWgyTRqc/qXUKZQPvVioCsUMs/qCNC+4weY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoZpNng50ZsvCaJs5ae/emGTjYOOg+91sRc8ceqp6qsgjFAEf0
	+PxgaJNpmi40WqZWURcYX+cnGi5wGZMW287CezZ3AmuqcesWYp8FKGfmkbzWDgXu9E302NiwK0w
	W4Z/z3RzvaJgoAyrg0S9AwNImYL4ft6ngI0Xk9jQ=
X-Gm-Gg: AR+sD11pgKPfkIMS9fs63IwEl0yYj+OkXVHs5gCPY2bavPWFpbrSrBzySuXDRspR98B
	1l70RFoGNHtDHX0GqAW48yu4E3XRiGscxOgHNAZsSTx0M2VXyccUGJDXK9B15S9iAVX70zx4cEG
	1bJJRuMA+zd1KrtjIjlkG3tCSsN39R8f8vRLk2lXr9JC9DJIeuvX8Sp8Zj3KfkQSRCQZwu3ZGS8
	6KwXknhgn9OC02ZMvo5qc4cULztFZAWok4R724XCBCGoFvh5kTMudJhJN4sy12yORiSMClGwkFy
	eQp8LZlvDQ4aHExvTr8KPUpgHVsoRsUksDOv7DTT4li7U5B5qilks6U=
X-Received: by 2002:a05:690c:6f13:b0:81f:2403:9e70 with SMTP id
 00721157ae682-82f2bd7db37mr11977607b3.19.1786440132469; Tue, 11 Aug 2026
 02:22:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Wei Fang <void0red@gmail.com>
Date: Tue, 11 Aug 2026 17:22:01 +0800
X-Gm-Features: AUfX_mw6DXV6ALe86hJnt2ujmDRPJLESx9Gd6gB9mL0xlFkmVOGKSvMQ_9A0Mgk
Message-ID: <CANE+tVpU7gL3ZJ9ro4oNKsqdN01mDMBpUou0ABakiO2WrT5gSw@mail.gmail.com>
Subject: [nf_tables] rbtree interval set: in one batch, re-adding element E0
 makes deleting an unrelated interval E1 fail with -ENOENT
To: pablo@netfilter.org
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, 
	k.chen@smail.nju.edu.cn
Content-Type: text/plain; charset="UTF-8"

The following nf_tables issue was found by metamorphic testing on
linux-next 7.2.0-rc6-next-20260803 (x86_64) and reproduced on four
independent VMs.  The reproducer is a single self-contained C program
that uses only the raw netlink API (no nft CLI involved).

This report is about the rbtree interval-set backend: re-adding an
existing interval element in the same batch as deleting an unrelated
interval makes the delete fail with -ENOENT, although the same two
operations succeed when sent separately.

Problem
-------
On an interval set that already contains two intervals, one batch
that does both of the following fails on the second operation:

1. re-add element E0 without NLM_F_EXCL (update semantics);
2. delete a different interval E1.

The delete returns -ENOENT.  Sending the same two operations in
separate messages succeeds.  A transaction must not change what an
operation does: batched and unbatched execution must behave the same.

Steps to reproduce
------------------
One batch on an ipv4_addr INTERVAL set with two existing intervals:

1. re-add E0 = [10.0.1.0..10.0.2.0) without NLM_F_EXCL;
2. delete E1 = [10.0.2.0..10.0.3.0).

Raw netlink is required: the nft CLI re-sorts interval elements and
hides the ordering.

Expected vs. actual
-------------------
expected (observed when sent separately): all operations ack 0
actual (single batch): [0, 0, 0, 0, -2] - the delete of E1 fails
with -ENOENT

Root cause
----------
net/netfilter/nft_set_rbtree.c: when the re-add takes the in-batch
EEXIST path, nft_rbtree_insert() records the matched start element
in priv->start_rbe_cookie (nft_rbtree_set_start_cookie()).  Later in
the same batch, deleting E1 reaches the END node of the interval
being deleted and calls nft_rbtree_deactivate_same_interval(), which
compares against that cookie.  The cookie still points at E0's start
element instead of E1's, the comparison fails, the deactivate
returns NULL, and __nft_setelem_deactivate() (nf_tables_api.c)
turns that into -ENOENT.

Reproducer
---------------

#include <arpa/inet.h>
#include <errno.h>
#include <fcntl.h>
#include <linux/netfilter/nf_tables.h>
#include <linux/netfilter/nfnetlink.h>
#include <linux/netlink.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <time.h>
#include <unistd.h>

/* NFT_MSG_* enum values come directly from <linux/netfilter/nf_tables.h>
 * (NEWTABLE=0, GETTABLE=1, DELTABLE=2, NEWCHAIN=3, ..., NEWRULE=6) --
 * do not #define the same names; that would break the header enum. */
#define NFT_MSG_TYPE(s, m) (((s) << 8) | (m))

/* ---------------- encoding helpers (wire format matches the Python
version) ---------------- */

static void put_u16(char **p, uint16_t v) { memcpy(*p, &v, 2); *p += 2; }
static void put_u32(char **p, uint32_t v) { memcpy(*p, &v, 4); *p += 4; }

/* attr: little-endian len/type header + payload, 4-byte tail
alignment (len excludes pad) */
static void put_attr(char **p, uint16_t type, const void *data, uint16_t len)
{
    put_u16(p, 4 + len);
    put_u16(p, type);
    if (len)
        memcpy(*p, data, len);
    *p += len;
    while ((uintptr_t)*p % 4) {
        **p = 0;
        (*p)++;
    }
}

static void put_attr_be32(char **p, uint16_t type, uint32_t v)
{
    uint32_t be = htonl(v);
    put_attr(p, type, &be, 4);
}

static void put_attr_str(char **p, uint16_t type, const char *s)
{
    put_attr(p, type, s, strlen(s) + 1);
}

static void put_nfgenmsg(char **p, uint8_t family, uint16_t res_id)
{
    char *q = *p;
    q[0] = family;
    q[1] = 0;
    uint16_t be = htons(res_id);
    memcpy(q + 2, &be, 2);
    *p += 4;
}

/* nlmsghdr + nfgenmsg + attrs; returns total length including header */
static int build_msg(char *buf, uint16_t type, uint16_t flags, uint32_t seq,
                     uint8_t family, uint16_t res_id, char *attrs, int alen)
{
    char *p = buf;
    put_u32(&p, 0);
    put_u16(&p, type);
    put_u16(&p, flags);
    put_u32(&p, seq);
    put_u32(&p, 0);
    put_nfgenmsg(&p, family, res_id);
    memcpy(p, attrs, alen);
    p += alen;
    int total = (int)(p - buf);
    memcpy(buf, &total, 4);
    return total;
}

/* BEGIN/END: nlmsghdr(type=0x10/0x11) + nfgenmsg(res=htons(10)) */
static int build_batch_frame(char *buf, uint16_t type, uint16_t flags,
                             uint32_t seq)
{
    return build_msg(buf, type, flags, seq, 0, NFNL_SUBSYS_NFTABLES, NULL, 0);
}

/* ---------------- netlink session (same as b16.c) ---------------- */

static int nl_fd = -1;

static void nl_open(void)
{
    nl_fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_NETFILTER);
    if (nl_fd < 0) { perror("socket"); exit(1); }
    struct sockaddr_nl sa = { .nl_family = AF_NETLINK };
    if (bind(nl_fd, (struct sockaddr *)&sa, sizeof(sa)) < 0) {
        perror("bind"); exit(1);
    }
    int fl = fcntl(nl_fd, F_GETFL, 0);
    fcntl(nl_fd, F_SETFL, fl | O_NONBLOCK);
}

static int collect_acks(uint32_t *wanted, int nwanted, int *errs,
                        int wait_ms)
{
    int got = 0;
    struct timeval tv = { .tv_sec = wait_ms / 1000,
                          .tv_usec = (wait_ms % 1000) * 1000 };
    setsockopt(nl_fd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));
    int deadline = (int)time(NULL) + wait_ms / 1000 + 1;
    while (got < nwanted && time(NULL) < deadline) {
        char buf[65536];
        int n = recv(nl_fd, buf, sizeof(buf), 0);
        if (n < 0) {
            if (errno == EAGAIN || errno == EWOULDBLOCK) continue;
            break;
        }
        for (int off = 0; off + 16 <= n;) {
            struct nlmsghdr *h = (struct nlmsghdr *)(buf + off);
            int len = h->nlmsg_len;
            if (len < 16 || off + len > n) break;
            if (h->nlmsg_type == NLMSG_ERROR && len >= 20) {
                struct nlmsgerr *e = (struct nlmsgerr *)(h + 1);
                for (int i = 0; i < nwanted; i++) {
                    if (wanted[i] == h->nlmsg_seq && errs[i] == 0x7fffffff) {
                        errs[i] = e->error;
                        got++;
                        break;
                    }
                }
            }
            off += NLMSG_ALIGN(len);
        }
    }
    return got;
}

static int E(int v) { return v == 0x7fffffff ? -1 : v; }

/* send batch (BEGIN + n body msgs + END); collect body acks into errs[] */
static void send_and_collect(char msgs[][512], int *lens, uint32_t *seqs,
                             int n, uint32_t begin_seq, uint32_t end_seq,
                             int *errs, int wait_ms)
{
    char blob[4096], *p = blob;
    int b = build_batch_frame(p, NFNL_MSG_BATCH_BEGIN, NLM_F_REQUEST,
                              begin_seq);
    p += b;
    for (int i = 0; i < n; i++) { memcpy(p, msgs[i], lens[i]); p += lens[i]; }
    int e = build_batch_frame(p, NFNL_MSG_BATCH_END, NLM_F_REQUEST, end_seq);
    p += e;
    send(nl_fd, blob, (int)(p - blob), 0);
    for (int i = 0; i < n; i++) errs[i] = 0x7fffffff;
    collect_acks(seqs, n, errs, wait_ms);
}

/* DELTABLE inside a batch; deleting a nonexistent table is harmless
(-ENOENT), used to clean leftovers */
static void del_table(uint8_t family, const char *tbl)
{
    char blob[1024], *p = blob;
    int b = build_batch_frame(p, NFNL_MSG_BATCH_BEGIN, NLM_F_REQUEST, 900);
    p += b;
    char attrs[64], *q = attrs;
    put_attr_str(&q, NFTA_TABLE_NAME, tbl);
    int len = build_msg(p, NFT_MSG_TYPE(NFNL_SUBSYS_NFTABLES, NFT_MSG_DELTABLE),
                        NLM_F_REQUEST | NLM_F_ACK, 901, family, 0, attrs,
                        (int)(q - attrs));
    p += len;
    int e = build_batch_frame(p, NFNL_MSG_BATCH_END, NLM_F_REQUEST, 902);
    p += e;
    send(nl_fd, blob, (int)(p - blob), 0);
    uint32_t w = 901;
    int er = 0x7fffffff;
    collect_acks(&w, 1, &er, 500);
}

/* ---------------- scenario construction ---------------- */

/* interval endpoints (network-order bytes, same as v_a1.py) */
static const uint8_t E0[4]     = { 0x0a, 0x00, 0x01, 0x00 };  /* 10.0.1.0 */
static const uint8_t E0_END[4] = { 0x0a, 0x00, 0x02, 0x00 };  /* 10.0.2.0 */
static const uint8_t E1[4]     = { 0x0a, 0x00, 0x02, 0x00 };  /* 10.0.2.0 */
static const uint8_t E1_END[4] = { 0x0a, 0x00, 0x03, 0x00 };  /* 10.0.3.0 */

/* Single interval element: attr type (1+idx), payload = [FLAGS(3)=1 for END
 * only] + KEY(1){ DATA(1)=4-byte key } (elems_raw_interval encoding).
 * Containers never set NLA_F_NESTED (kernel nla_parse_nested_deprecated
 * does not check the flag). */
static void put_interval_elem(char **p, int idx, const uint8_t key[4],
                              int is_end)
{
    char inner[64], *q = inner;
    if (is_end)
        put_attr_be32(&q, NFTA_SET_ELEM_FLAGS, NFT_SET_ELEM_INTERVAL_END);
    char kd[16], *k = kd;
    put_attr(&k, NFTA_DATA_VALUE, key, 4);
    put_attr(&q, NFTA_SET_ELEM_KEY, kd, (int)(k - kd));
    put_attr(p, 1 + idx, inner, (int)(q - inner));
}

/* install batch: table t + set s(interval, ipv4_addr) + 4 interval elements */
static void mk_install(char (*msgs)[512], int *lens, uint32_t *seqs)
{
    char attrs[256], *p;
    int alen;

    p = attrs;
    put_attr_str(&p, NFTA_TABLE_NAME, "t");
    alen = (int)(p - attrs);
    lens[0] = build_msg(msgs[0], NFT_MSG_TYPE(NFNL_SUBSYS_NFTABLES,
                        NFT_MSG_NEWTABLE),
                        NLM_F_REQUEST | NLM_F_ACK | NLM_F_CREATE, seqs[0], 2,
                        0, attrs, alen);

    /* NEWSET: TABLE(1) NAME(2) FLAGS(3)=INTERVAL KEY_TYPE(4)=7 KEY_LEN(5)=4
     * ID(10)=0 (NFTA_SET_ID is mandatory) */
    p = attrs;
    put_attr_str(&p, NFTA_SET_TABLE, "t");
    put_attr_str(&p, NFTA_SET_NAME, "s");
    put_attr_be32(&p, NFTA_SET_FLAGS, NFT_SET_INTERVAL);
    put_attr_be32(&p, NFTA_SET_KEY_TYPE, 7);      /* ipv4_addr */
    put_attr_be32(&p, NFTA_SET_KEY_LEN, 4);
    put_attr_be32(&p, NFTA_SET_ID, 0);
    alen = (int)(p - attrs);
    lens[1] = build_msg(msgs[1], NFT_MSG_TYPE(NFNL_SUBSYS_NFTABLES,
                        NFT_MSG_NEWSET),
                        NLM_F_REQUEST | NLM_F_ACK | NLM_F_CREATE, seqs[1], 2,
                        0, attrs, alen);

    /* NEWSETELEM: TABLE(1) NAME(2) ELEMENTS(3){ elems type=1..4 } */
    p = attrs;
    put_attr_str(&p, NFTA_SET_ELEM_LIST_TABLE, "t");
    put_attr_str(&p, NFTA_SET_ELEM_LIST_SET, "s");
    {
        char elems[256], *q = elems;
        const uint8_t *keys[4] = { E0, E0_END, E1, E1_END };
        int ends[4] = { 0, 1, 0, 1 };
        for (int i = 0; i < 4; i++)
            put_interval_elem(&q, i, keys[i], ends[i]);
        put_attr(&p, NFTA_SET_ELEM_LIST_ELEMENTS, elems, (int)(q - elems));
    }
    alen = (int)(p - attrs);
    lens[2] = build_msg(msgs[2], NFT_MSG_TYPE(NFNL_SUBSYS_NFTABLES,
                        NFT_MSG_NEWSETELEM),
                        NLM_F_REQUEST | NLM_F_ACK | NLM_F_CREATE, seqs[2], 2,
                        0, attrs, alen);
}

/* re-add e0 (single point, no EXCL -> update semantics, errno 0) */
static void mk_readd(char *buf, int *len, uint32_t seq)
{
    char attrs[256], *p = attrs;
    put_attr_str(&p, NFTA_SET_ELEM_LIST_TABLE, "t");
    put_attr_str(&p, NFTA_SET_ELEM_LIST_SET, "s");
    {
        char elems[64], *q = elems;
        put_interval_elem(&q, 0, E0, 0);
        put_attr(&p, NFTA_SET_ELEM_LIST_ELEMENTS, elems, (int)(q - elems));
    }
    *len = build_msg(buf, NFT_MSG_TYPE(NFNL_SUBSYS_NFTABLES,
NFT_MSG_NEWSETELEM),
                     NLM_F_REQUEST | NLM_F_ACK | NLM_F_CREATE, seq, 2, 0,
                     attrs, (int)(p - attrs));
}

/* delete interval 2 (END element first, then start, same order as v_a1.py) */
static void mk_del(char *buf, int *len, uint32_t seq)
{
    char attrs[256], *p = attrs;
    put_attr_str(&p, NFTA_SET_ELEM_LIST_TABLE, "t");
    put_attr_str(&p, NFTA_SET_ELEM_LIST_SET, "s");
    {
        char elems[64], *q = elems;
        put_interval_elem(&q, 0, E1_END, 1);
        put_interval_elem(&q, 1, E1, 0);
        put_attr(&p, NFTA_SET_ELEM_LIST_ELEMENTS, elems, (int)(q - elems));
    }
    *len = build_msg(buf, NFT_MSG_TYPE(NFNL_SUBSYS_NFTABLES,
NFT_MSG_DELSETELEM),
                     NLM_F_REQUEST | NLM_F_ACK, seq, 2, 0, attrs,
                     (int)(p - attrs));
}

/* ---------------- main ---------------- */

int main(void)
{
    char msgs[5][512];
    int lens[5];
    uint32_t seqs[5];
    int errs[5];

    nl_open();
    del_table(2, "t");              /* clean up leftovers from previous run */

    /* control batch: install only -> all errno 0 */
    seqs[0] = 11; seqs[1] = 12; seqs[2] = 13;
    mk_install(msgs, lens, seqs);
    send_and_collect(msgs, lens, seqs, 3, 10, 14, errs, 1500);
    printf("control ack errno: [%d, %d, %d] (expected all 0)\n",
           E(errs[0]), E(errs[1]), E(errs[2]));
    del_table(2, "t");

    /* variant batch: install + re-add e0 + delete interval 2 -> readd
0, delete should be 0; bug: delete -2 */
    seqs[0] = 101; seqs[1] = 102; seqs[2] = 103;
    mk_install(msgs, lens, seqs);
    seqs[3] = 104;
    mk_readd(msgs[3], &lens[3], seqs[3]);
    seqs[4] = 105;
    mk_del(msgs[4], &lens[4], seqs[4]);
    send_and_collect(msgs, lens, seqs, 5, 100, 106, errs, 2000);
    int readd = E(errs[3]), dele = E(errs[4]);
    printf("variant ack errno: [%d, %d, %d, %d, %d] (last two =
re-add/delete)\n",
           E(errs[0]), E(errs[1]), E(errs[2]), readd, dele);
    del_table(2, "t");

    if (readd == 0 && dele == -2)
        printf("REPRODUCED: in-batch re-add of e0 makes deleting interval 2 "
               "fail with -ENOENT (rbtree start_rbe_cookie intra-batch
pollution)\n");
    else if (readd == 0 && dele == 0)
        printf("NOT_REPRODUCED: delete succeeds after the re-add "
               "(no pollution)\n");
    else
        printf("UNAVAILABLE: unexpected observation (readd=%d, del=%d)\n",
               readd, dele);

    close(nl_fd);
    return 0;
}
