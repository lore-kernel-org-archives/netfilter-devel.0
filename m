Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C0D41D655
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2026 09:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786442314; cv=pass; b=DwGzw1RNk/INzO9riyJySzX/eMZU/KQovJMoRV0PQHscoJ/pr0ErxW5ThubjYnXkDYiQIXI5BIonDwMZBJ41eEN1ktm3kdCqG5cWiykwQ2Ccgxul/ICctwwHETWikmGfG3NALT5hfAlZKFHb7KstzoTl44YfYnqIiQZg8s/bMmY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786442314; c=relaxed/simple;
	bh=d6RYoB4Uiv+lGRgZMBX13TnfD3IWzzfZnhpWnoV3Pes=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=lMTUCFx4RXhdVyCkpVlth15lMWIzREG1k5O7ljn04uQRi0s2p+OHI9gnBZKo864yVgQN6YzlCCB9mVK8kCcEPuTuLuV4s4dT8jHrS5Zru6rVpdZ9GUN/gFPZcNLDka/3jUZMbJ2jGshrn5WGdg+BX6jWK4LHlYvJk0njopHOsZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z/Ks06c2; arc=pass smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z/Ks06c2"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8201447e8cdso44557237b3.3
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2026 02:58:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786442311; cv=none;
        d=google.com; s=arc-20260327;
        b=X5CphH9B8Abvirk3hJ5yKvwjVeSByR9PKhA48yzw5qfzzzWdNn97UUJXiC1v15GJkI
         pex4howj0MPNXnInmz1IxIw5m6Qw+EedZKhxMqq5aKjejp10Fqja0LWSLD8NqPlUJFiF
         0tHI8z+uoBcXX+atp2GVYSt9qZ19ROPIhU6A+PhGGCQp4LempnMdI7VlEEQp5MkCyZFK
         OEO8LX7/pfYZczOVa1xZkg364sAw33NkCqFCxyC+tqV6nNDfX2I+5zF0ae0jbN2r1fX3
         duFPcMXi+evWn3GNf5V/REngRRPOzMbf/qmRu9K7kQlkFXS5d2S13fFdCklUvQumOm3W
         U4Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=o5NGtSqMw5cDWljS6WDYTXG7/aYChPFYlMJBTyzLkN0=;
        fh=XGifei1neXJ3CAQ6yqDhdTJD6hobOgXFIlmWI/Jun3E=;
        b=j6y0NbyDRFrBCLsRgAOw5OdRD75Hfas1gmu7abXTd38r5MQTVWev39hGyO1GB15vjX
         RrXzW1ix6mgfN2UlVQ6ug+AiwcQ5Q1G/TqTe3t7AsjKT5W2Ydyvmmf8ReHZjftK4TOsH
         t2pzRi1STJpclWSK2UCkiB85GEf50AJEMtPSjBIwU1etgrQoaYGgtT0nhFgXcDy93ABV
         GEka0Hi3Kl1YmpxkpqC9n7F64tL22Frz1D+BpH/lUsN+8JSrVOrJz9Ce0OpYIxtT9G+/
         n5NhthX3hMwe8xTEValSwwRfTrE3g8hA4P9Fp1cfDafh7qTAX/eESIjrooDZwTIL4tcj
         PADQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786442311; x=1787047111; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=o5NGtSqMw5cDWljS6WDYTXG7/aYChPFYlMJBTyzLkN0=;
        b=Z/Ks06c2ADUZ2vbNdHo6xctjqxLesfcbd94s/ZR4HgsQ/TxfzR0jmz2PQSM4E05l/q
         QHlDTF/fWxiB1XjCNIgJgIWKEi0BycU5f1B7uzEIXPbKiu1gb5+s9DHFktEKnqCFUc+q
         Dpp7jaNVcYIE9miBtXljPOtxAKc2Z73O11+Xpg9locP+3CZDt1YQb4MUdd00m557c5iW
         X5gBSxRGwZ5R1QinwG5zArGrxtjLGgsVU8eZ3EXwV6Y6H5jDpEjjXuWjbwfMXQCM9ufb
         ybDynaaQ6PZ0AGKVoUPC0k0ysY5+EM+BUcxLvwyjcDYFi78nEGukyZG1Ml94DHf0dNDD
         Ywjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786442311; x=1787047111;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=o5NGtSqMw5cDWljS6WDYTXG7/aYChPFYlMJBTyzLkN0=;
        b=aUNmzQOg0tU1hUQrA18+ipEfQ/Z+6Zu2LZnAkmYP28YxV582fJ2P6WQ3+OBvePCCLW
         Qw9HIl6szowYDyeBlsavC9zEEwTlX9Uk6qiciXcwYnK+/t2f4PpHnmRG7fPLnoNTOmg8
         9OQigIZY+jKB9Wz9d66pImho7iGbfDUXrKaqqml3A8QcWT6gYgpZJgYK+UeHPmEoIKme
         6bxOX5OSzF1M/CFBcWxCfpoRRdSkPBhXiUtNXqO9qCBVBjtBy+vcNjP4/jeTEgsaYyhc
         EIbw5uEI/rDnYWqLwohFpWKFhjzT9m+jRN7k3NFMfXRPkjaKEsLFCeG07alHa//NO+na
         QLfg==
X-Forwarded-Encrypted: i=1; AHgh+Rr474E9zwsLxcqnE8XrK//wo9/1O/+s56cHOuQ4nS7XEP6ULIte1/dIjsZyGo6ppuNOz7HCAxSIPz9G0jHgqcM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeonLMkyZ0p9V+kmRpCXz85bNopt7MWH8dzEQ9qZW5hqHLlJTx
	sykxVHQI+LpopwkRmBl7wiHe6p1L6FYMJcRZi3Yn6K251XKtO/RADDO+ugNwo5aSDwrpIur677s
	p2wgSneKfZVXHQArD82QaeJY6rJHrViE=
X-Gm-Gg: AR+sD12xDV5DYh2S7dmwzGVk2xhoWe+LZ6CfRWmPOa2KmJnoyQuTwvkayGk4Pj4s9QF
	LvOv+43eJP7ZJghEbfRylnrsKo5xkawHBhAXqVOURvtA4+4TuHmAqZN3Pz60W4qV5i6UjnzqNSY
	aMbrgOaoeQyUXherYnIK0SQ+OEQ9ToHx9LVBuxv5rW8WM6Dk6jR29P2VgjJRND/ScamS1qD0HoI
	cz9Q13epxIefnHYv86idyBjq70BoJwAYSRLp3U6XSKU04SmYbntXypJB//yZO7PfhlI96TOdg/a
	2B1IKgDFZQUdOLZmEG2CMp9FNROHLyNcG/kGTmtuMylg
X-Received: by 2002:a05:690c:e3c9:b0:80d:c2cc:f673 with SMTP id
 00721157ae682-82f2b3cee5cmr12466067b3.20.1786442310416; Tue, 11 Aug 2026
 02:58:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Wei Fang <void0red@gmail.com>
Date: Tue, 11 Aug 2026 17:58:18 +0800
X-Gm-Features: AUfX_mzd1mxLM3yaKzSytCFyiC_bWnMF9SelQt4TpORyeAT0GL_ciOF9XvA5RhA
Message-ID: <CANE+tVp8_NhE+KL6ZNPGjaGMLPxrCWw_A5sY0jotrvThB6idXg@mail.gmail.com>
Subject: [nf_tables] pipapo: inserting an interval that strictly contains an
 existing one is accepted; rbtree rejects the same insert
To: pablo@netfilter.org
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, 
	k.chen@smail.nju.edu.cn
Content-Type: text/plain; charset="UTF-8"

Hi netfilter-devel,

The following nf_tables issue was found by metamorphic testing on
linux-next 7.2.0-rc6-next-20260803 (x86_64) and reproduced on four
independent VMs.  The reproducer is a single self-contained C program
that uses only the raw netlink API (no nft CLI involved).

This report is about interval-set overlap validation: inserting an
interval that strictly contains an existing one is rejected with
-EEXIST on the rbtree backend but silently accepted on pipapo, so
interval-set semantics depend on which backend the kernel picks.

Problem
-------
The same overlapping-insert sequence gives different results
depending on which backend the kernel picks: inserting an interval
that strictly contains an existing interval is rejected with -EEXIST
on rbtree but silently accepted on pipapo.  The nft CLI hides this -
it performs its own userspace overlap check and refuses to send
overlapping elements.

Steps to reproduce
------------------
Two sets with identical elements, differing only in backend
selection:

1. rbtree: set s, INTERVAL, key_len 4 - insert
   [1.1.1.1..1.1.1.11), then [1.1.1.0..1.1.1.12);
2. pipapo: set s, INTERVAL|CONCAT, key_len 8 (two 4-byte fields) -
   the same two elements.

Expected vs. actual
-------------------
expected: both backends reject the overlapping insert (-EEXIST)
actual:   rbtree rejects (-17); pipapo accepts (0)

Root cause
----------
net/netfilter/nft_set_pipapo.c, nft_pipapo_insert(): the overlap
check probes only the two endpoints of the new interval
(pipapo_get(start) and pipapo_get(end) -> -ENOTEMPTY) plus an exact
duplicate (-EEXIST).  A new interval that strictly contains an
existing one has both endpoints outside the existing interval, so
both probes miss and the insert is accepted.  (The reverse case - a
new interval strictly inside an existing one - is caught, because
the start endpoint hits.)


Reproducer
----------------
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

/* NFT_MSG_* enum comes from <linux/netfilter/nf_tables.h>
 * (NEWTABLE=0, GETTABLE=1, DELTABLE=2, NEWCHAIN=3, ..., NEWRULE=6) --
 * do not #define the same names; it would break the header enum. */
#define NFT_MSG_TYPE(s, m) (((s) << 8) | (m))

/* ---------------- encoding helpers (wire-identical to the Python
reference) ---------------- */

static void put_u16(char **p, uint16_t v) { memcpy(*p, &v, 2); *p += 2; }
static void put_u32(char **p, uint32_t v) { memcpy(*p, &v, 4); *p += 4; }

/* attr: little-endian len/type header + payload, 4-byte aligned at
the end (len excludes pad) */
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

/* Collect NLMSG_ERROR acks, map seq -> errno; wait at most wait_ms */
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

/* Send batch (BEGIN + n bodies + END); collect body acks into errs[] */
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

/* DELTABLE (inside batch); deleting a nonexistent table returns -ENOENT,
 * harmless; used to clean up leftovers */
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

/* interval endpoints (network-order bytes) */
static const uint8_t OV[4]       = { 0x01, 0x01, 0x01, 0x01 };  /* 1.1.1.1 */
static const uint8_t OV_END[4]   = { 0x01, 0x01, 0x01, 0x0b };  /* 1.1.1.11 */
static const uint8_t CONT[4]     = { 0x01, 0x01, 0x01, 0x00 };  /* 1.1.1.0 */
static const uint8_t CONT_END[4] = { 0x01, 0x01, 0x01, 0x0c };  /* 1.1.1.12 */
/* concat key = two 4-byte fields concatenated (key_len 8) */
static const uint8_t OV2[8]       = { 1,1,1,1,  1,1,1,1 };
static const uint8_t OV_END2[8]   = { 1,1,1,11, 1,1,1,11 };
static const uint8_t CONT2[8]     = { 1,1,1,0,  1,1,1,0 };
static const uint8_t CONT_END2[8] = { 1,1,1,12, 1,1,1,12 };

/* rbtree element (raw_interval encoding): [FLAGS(3)=1 only on END] +
 * KEY(1){ DATA(1)=4-byte key }, attr type 1+idx */
static void put_rb_elem(char **p, int idx, const uint8_t key[4], int is_end)
{
    char inner[64], *q = inner;
    if (is_end)
        put_attr_be32(&q, NFTA_SET_ELEM_FLAGS, NFT_SET_ELEM_INTERVAL_END);
    char kd[16], *k = kd;
    put_attr(&k, NFTA_DATA_VALUE, key, 4);
    put_attr(&q, NFTA_SET_ELEM_KEY, kd, (int)(k - kd));
    put_attr(p, 1 + idx, inner, (int)(q - inner));
}

/* pipapo element (elems_concat_interval encoding): KEY(1){ DATA(1)=8B } +
 * KEY_END(10){ DATA(1)=8B }, attr type 1+idx. Container has no NLA_F_NESTED. */
static void put_pp_elem(char **p, int idx, const uint8_t key[8],
                        const uint8_t end[8])
{
    char body[96], *q = body;
    char kd[16], *k = kd;
    put_attr(&k, NFTA_DATA_VALUE, key, 8);
    put_attr(&q, NFTA_SET_ELEM_KEY, kd, (int)(k - kd));
    char ed[16], *e = ed;
    put_attr(&e, NFTA_DATA_VALUE, end, 8);
    put_attr(&q, NFTA_SET_ELEM_KEY_END, ed, (int)(e - ed));
    put_attr(p, 1 + idx, body, (int)(q - body));
}

/* NEWTABLE: NAME(1) */
static void mk_table(char *buf, int *len, uint32_t seq)
{
    char attrs[64], *p = attrs;
    put_attr_str(&p, NFTA_TABLE_NAME, "mt-be");
    *len = build_msg(buf, NFT_MSG_TYPE(NFNL_SUBSYS_NFTABLES, NFT_MSG_NEWTABLE),
                     NLM_F_REQUEST | NLM_F_ACK | NLM_F_CREATE, seq, 2, 0,
                     attrs, (int)(p - attrs));
}

/* NEWSET: TABLE(1) NAME(2) FLAGS(3) KEY_TYPE(4)=7 KEY_LEN(5) ID(10)=0;
 * with_concat adds DESC(9){ CONCAT(2){ FIELD_LEN(1){ LEN(1)=be32 4 } x2 } } */
static void mk_set(char *buf, int *len, uint32_t seq, int with_concat)
{
    char attrs[256], *p = attrs;
    put_attr_str(&p, NFTA_SET_TABLE, "mt-be");
    put_attr_str(&p, NFTA_SET_NAME, "s");
    put_attr_be32(&p, NFTA_SET_FLAGS,
                  with_concat ? (NFT_SET_INTERVAL | NFT_SET_CONCAT)
                              : NFT_SET_INTERVAL);
    put_attr_be32(&p, NFTA_SET_KEY_TYPE, 7);      /* ipv4_addr */
    put_attr_be32(&p, NFTA_SET_KEY_LEN, with_concat ? 8 : 4);
    put_attr_be32(&p, NFTA_SET_ID, 0);
    if (with_concat) {
        char fields[64], *f = fields;
        for (int i = 0; i < 2; i++) {
            char fl[16], *q = fl;
            put_attr_be32(&q, NFTA_SET_FIELD_LEN, 4);
            put_attr(&f, 1, fl, (int)(q - fl));
        }
        char concat[72], *c = concat;
        put_attr(&c, NFTA_SET_DESC_CONCAT, fields, (int)(f - fields));
        put_attr(&p, NFTA_SET_DESC, concat, (int)(c - concat));
    }
    *len = build_msg(buf, NFT_MSG_TYPE(NFNL_SUBSYS_NFTABLES, NFT_MSG_NEWSET),
                     NLM_F_REQUEST | NLM_F_ACK | NLM_F_CREATE, seq, 2, 0,
                     attrs, (int)(p - attrs));
}

/* NEWSETELEM (rbtree backend): TABLE(1) NAME(2) ELEMENTS(3){4 elements} */
static void mk_elems_rb(char *buf, int *len, uint32_t seq)
{
    char attrs[256], *p = attrs;
    put_attr_str(&p, NFTA_SET_ELEM_LIST_TABLE, "mt-be");
    put_attr_str(&p, NFTA_SET_ELEM_LIST_SET, "s");
    {
        char elems[256], *q = elems;
        const uint8_t *keys[4] = { OV, OV_END, CONT, CONT_END };
        int ends[4] = { 0, 1, 0, 1 };
        for (int i = 0; i < 4; i++)
            put_rb_elem(&q, i, keys[i], ends[i]);
        put_attr(&p, NFTA_SET_ELEM_LIST_ELEMENTS, elems, (int)(q - elems));
    }
    *len = build_msg(buf, NFT_MSG_TYPE(NFNL_SUBSYS_NFTABLES,
NFT_MSG_NEWSETELEM),
                     NLM_F_REQUEST | NLM_F_ACK | NLM_F_CREATE, seq, 2, 0,
                     attrs, (int)(p - attrs));
}

/* NEWSETELEM (pipapo backend): same overlapping sequence, concat encoding */
static void mk_elems_pp(char *buf, int *len, uint32_t seq)
{
    char attrs[256], *p = attrs;
    put_attr_str(&p, NFTA_SET_ELEM_LIST_TABLE, "mt-be");
    put_attr_str(&p, NFTA_SET_ELEM_LIST_SET, "s");
    {
        char elems[256], *q = elems;
        put_pp_elem(&q, 0, OV2, OV_END2);
        put_pp_elem(&q, 1, CONT2, CONT_END2);
        put_attr(&p, NFTA_SET_ELEM_LIST_ELEMENTS, elems, (int)(q - elems));
    }
    *len = build_msg(buf, NFT_MSG_TYPE(NFNL_SUBSYS_NFTABLES,
NFT_MSG_NEWSETELEM),
                     NLM_F_REQUEST | NLM_F_ACK | NLM_F_CREATE, seq, 2, 0,
                     attrs, (int)(p - attrs));
}

/* ---------------- main ---------------- */

int main(void)
{
    char msgs[3][512];
    int lens[3];
    uint32_t seqs[3];
    int errs[3];

    nl_open();
    del_table(2, "mt-be");          /* cleanup of leftovers from previous run */

    /* control batch (rbtree backend): overlapping insert must be
rejected (last errno -17) */
    seqs[0] = 11; seqs[1] = 12; seqs[2] = 13;
    mk_table(msgs[0], &lens[0], seqs[0]);
    mk_set(msgs[1], &lens[1], seqs[1], 0);
    mk_elems_rb(msgs[2], &lens[2], seqs[2]);
    send_and_collect(msgs, lens, seqs, 3, 10, 14, errs, 1500);
    int rb_elem = E(errs[2]);
    printf("rbtree ack errno: [%d, %d, %d] (overlap should be rejected)\n",
           E(errs[0]), E(errs[1]), rb_elem);
    del_table(2, "mt-be");

    /* variant batch (pipapo backend): same sequence -> must also be
rejected; bug: accepted (0) */
    seqs[0] = 101; seqs[1] = 102; seqs[2] = 103;
    mk_table(msgs[0], &lens[0], seqs[0]);
    mk_set(msgs[1], &lens[1], seqs[1], 1);
    mk_elems_pp(msgs[2], &lens[2], seqs[2]);
    send_and_collect(msgs, lens, seqs, 3, 100, 104, errs, 1500);
    int pp_elem = E(errs[2]);
    printf("pipapo ack errno: [%d, %d, %d] (same sequence)\n",
           E(errs[0]), E(errs[1]), pp_elem);
    del_table(2, "mt-be");

    if (rb_elem != 0 && pp_elem == 0)
        printf("REPRODUCED: rbtree rejects the overlapping insert (%d) "
               "while pipapo accepts it (0) - backend divergence\n", rb_elem);
    else if (rb_elem != 0 && pp_elem != 0)
        printf("NOT_REPRODUCED: pipapo also rejects it (%d) - no divergence\n",
               pp_elem);
    else
        printf("UNAVAILABLE: unexpected observation (rbtree=%d, pipapo=%d)\n",
               rb_elem, pp_elem);

    close(nl_fd);
    return 0;
}
