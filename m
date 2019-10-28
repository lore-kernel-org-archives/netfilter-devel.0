Return-Path: <SRS0=tJiL=YV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC266CA9EC0
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 14:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7661620659
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 14:27:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="TyYcB3jP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390054AbfJ1O1X (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Oct 2019 10:27:23 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:44948 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728330AbfJ1O1W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Oct 2019 10:27:22 -0400
Received: by mail-vs1-f67.google.com with SMTP id j85so6422208vsd.11
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Oct 2019 07:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A7y220vMaf499xanl3uMbh3inFXt1BbTGEbAjezKRWU=;
        b=TyYcB3jPGrWdBV+GUjPBbRCO2qhyrarFdspMRsWN+pj3wjMg4w9szVBXYFOruiOZrT
         OuC2nxZ8ZpRfpX3hj1l1GJ/lNb1vI90Zk6UOk/ZlIpGl9HEMTJdfLvQZqJgEtGzK7bla
         mdIDX4fLDf+G/QNBq1wt9/pVD7iQNgxJyRslobI1sAchdrWGOpGH5JWTUmtggoHFL3Bm
         Xe1XEfovVqe34PAO+iLSBZIGGx1lxyQoSqEQelx5X8CmytMK+GEGzua/V3JDiIRFoF64
         QHXhkCYJpDWv/+L2NlEB2v6F0cNTK+Od8MdrXgXCgmHO2ObSyAJ5fsN3PbaniLJaoi/t
         Gb/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A7y220vMaf499xanl3uMbh3inFXt1BbTGEbAjezKRWU=;
        b=sBNAFQt23rs1fZsmVvjP9tCWDJ5EB/PLWdgji9hvvTT9kvpg733W2PeIdt4V98ya8z
         MXe5eDjtsFmG1ow7FeGFGO6jUslThu8wBoAsvSqjRYOSvfPJW87ysMsUBd0jxr3hPhBc
         PuIvvpTE0u5IyWgM6GZ4tZBaMUwc5a80sm8q1t3dV6tMTOOYRa4rgbjnOkUrgJRIq2Xv
         1OAEGa5Lhw8Anh6XLQjqsgM9ugGssX18K9AiqS2LbK2LYMwfO1GuqWuNR+OEEd7VWUP1
         BpSy2auWZPB7OpqMo7qua25oEg5/lz6rwUvpELpXswlLc0rCr65ACD74dRECsv0lkioQ
         UYIA==
X-Gm-Message-State: APjAAAXdWYEmEOGQmnmTFWN+Dz0k/q/8CGibvl4egK2WFge9YJC5zQ1D
        TQ4bHU4g+xR6JNJnGhnFFHwEoPj/UR3vPf1PhQjF9PMA
X-Google-Smtp-Source: APXvYqyagJOH7/sa2ljrIl3ofIdfxKczwicU37kkJuLXEw2UXFH6VxNqwRPm/1LkRmqMI95FVIX3pcYeHFoeSk2eLiM=
X-Received: by 2002:a05:6102:1d2:: with SMTP id s18mr9222798vsq.144.1572272839802;
 Mon, 28 Oct 2019 07:27:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ2a_DcUH1ZaovOTNS14Z64Bwj5R5y4LLmZUeEPWFaNKECS6mQ@mail.gmail.com>
 <20191022173411.zh3o2wnoqxpjhjkq@salvia>
In-Reply-To: <20191022173411.zh3o2wnoqxpjhjkq@salvia>
From:   =?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>
Date:   Mon, 28 Oct 2019 15:27:07 +0100
Message-ID: <CAJ2a_DdVOTDPpamh=DKcGde_8gp++xYPwBP=0gY3_GDqPFntrQ@mail.gmail.com>
Subject: Re: nftables: secmark support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000001b64230595f94c19"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--0000000000001b64230595f94c19
Content-Type: text/plain; charset="UTF-8"

> >     [... define secmarks and port maps ...]
> >     chain input {
> >         type filter hook input priority 0;
> >         ct state new meta secmark set tcp dport map @secmapping_in
> >         ct state new ip protocol icmp meta secmark set "icmp_server"
> >         ct state new ip6 nexthdr icmpv6 meta secmark set "icmp_server"
> >         ct state new ct secmark_raw set meta secmark_raw
> >         ct state established,related meta secmark_raw set ct secmark_raw
>
> So your concern is the need for this extra secmark_raw, correct?

Exactly, cause i want to store the kernel internal secid in the packet
state to match it on est,rel packets.
Otherwise I got "Counter expression must be constant" and other errors.

> This is what your patch [6] does, right? If you don't mind to rebase
> it I can have a look if I can propose you something else than this new
> keyword.

Attached at the end (base on 707ad229d48f2ba7920541527b755b155ddedcda)

> This is the listing after you add ruleset in 1., correct?

Yes

> > 3.
> > The patch also adds the ability to reset secmarks.
> > Is there a way to query the kernel about the actual secid (to verify
> > the reset works)?
>
> What do you mean by "reset secmarks", example please.

Reseting secmarks intends to renew the association between the secmark
string and the kernel internal secid.
To keep it in sync after e.g. a SELinux policy reload, without
restarting the whole firewall, resetting counters etc..



From c559cb37e09526e02da02724017d0f921a03a1c1 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
Date: Mon, 28 Oct 2019 15:12:29 +0100
Subject: [PATCH] add secmark_raw for storing secmark id in packet state

---
 src/ct.c           |  2 ++
 src/evaluate.c     |  2 ++
 src/meta.c         |  3 +++
 src/parser_bison.y | 37 +++++++++++++++++++++++++++++--------
 src/rule.c         |  6 ++++++
 src/scanner.l      |  1 +
 6 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/src/ct.c b/src/ct.c
index ed458e6..9e6a835 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -299,6 +299,8 @@ const struct ct_template ct_templates[__NFT_CT_MAX] = {
                           BYTEORDER_BIG_ENDIAN, 128),
     [NFT_CT_DST_IP6]    = CT_TEMPLATE("ip6 daddr", &ip6addr_type,
                           BYTEORDER_BIG_ENDIAN, 128),
+    [NFT_CT_SECMARK]    = CT_TEMPLATE("secmark", &integer_type,
+                          BYTEORDER_HOST_ENDIAN, 32),
 };

 static void ct_print(enum nft_ct_keys key, int8_t dir, uint8_t nfproto,
diff --git a/src/evaluate.c b/src/evaluate.c
index a56cd2a..1b2f5e3 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3944,8 +3944,10 @@ static int cmd_evaluate_reset(struct eval_ctx
*ctx, struct cmd *cmd)
     switch (cmd->obj) {
     case CMD_OBJ_COUNTER:
     case CMD_OBJ_QUOTA:
+    case CMD_OBJ_SECMARK:
     case CMD_OBJ_COUNTERS:
     case CMD_OBJ_QUOTAS:
+    case CMD_OBJ_SECMARKS:
         if (cmd->handle.table.name == NULL)
             return 0;
         if (table_lookup(&cmd->handle, &ctx->nft->cache) == NULL)
diff --git a/src/meta.c b/src/meta.c
index f54b818..8093d67 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -709,6 +709,8 @@ const struct meta_template meta_templates[] = {
     [NFT_META_TIME_HOUR]    = META_TEMPLATE("hour", &hour_type,
                         4 * BITS_PER_BYTE,
                         BYTEORDER_HOST_ENDIAN),
+    [NFT_META_SECMARK]    = META_TEMPLATE("secmark", &integer_type,
+                        32, BYTEORDER_HOST_ENDIAN),
 };

 static bool meta_key_is_unqualified(enum nft_meta_keys key)
@@ -720,6 +722,7 @@ static bool meta_key_is_unqualified(enum nft_meta_keys key)
     case NFT_META_OIFNAME:
     case NFT_META_IIFGROUP:
     case NFT_META_OIFGROUP:
+    case NFT_META_SECMARK:
         return true;
     default:
         return false;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 11f0dc8..16fcea2 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -479,6 +479,7 @@ int nft_lex(void *, void *, void *);

 %token SECMARK            "secmark"
 %token SECMARKS            "secmarks"
+%token SECMARK_RAW        "secmark_raw"

 %token NANOSECOND        "nanosecond"
 %token MICROSECOND        "microsecond"
@@ -748,7 +749,7 @@ int nft_lex(void *, void *, void *);

 %type <expr>            meta_expr
 %destructor { expr_free($$); }    meta_expr
-%type <val>            meta_key    meta_key_qualified
meta_key_unqualified    numgen_type
+%type <val>            meta_key    meta_key_qualified
meta_key_unqualified    meta_key_object    numgen_type

 %type <expr>            socket_expr
 %destructor { expr_free($$); } socket_expr
@@ -1365,6 +1366,18 @@ reset_cmd        :    COUNTERS    ruleset_spec
             {
                 $$ = cmd_alloc(CMD_RESET, CMD_OBJ_QUOTA, &$2, &@$, NULL);
             }
+            |    SECMARKS    ruleset_spec
+            {
+                $$ = cmd_alloc(CMD_RESET, CMD_OBJ_SECMARKS, &$2, &@$, NULL);
+            }
+            |    SECMARKS    TABLE    table_spec
+            {
+                $$ = cmd_alloc(CMD_RESET, CMD_OBJ_SECMARKS, &$3, &@$, NULL);
+            }
+            |       SECMARK        obj_spec
+            {
+                $$ = cmd_alloc(CMD_RESET, CMD_OBJ_SECMARK, &$2, &@$, NULL);
+            }
             ;

 flush_cmd        :    TABLE        table_spec
@@ -4123,7 +4136,7 @@ meta_key_qualified    :    LENGTH        { $$ =
NFT_META_LEN; }
             |    PROTOCOL    { $$ = NFT_META_PROTOCOL; }
             |    PRIORITY    { $$ = NFT_META_PRIORITY; }
             |    RANDOM        { $$ = NFT_META_PRANDOM; }
-            |    SECMARK        { $$ = NFT_META_SECMARK; }
+            |    SECMARK_RAW    { $$ = NFT_META_SECMARK; }
             ;

 meta_key_unqualified    :    MARK        { $$ = NFT_META_MARK; }
@@ -4152,7 +4165,18 @@ meta_key_unqualified    :    MARK        { $$ =
NFT_META_MARK; }
             |       HOUR        { $$ = NFT_META_TIME_HOUR; }
             ;

+meta_key_object        :    SECMARK        { $$ = NFT_META_SECMARK; }
+            ;
+
 meta_stmt        :    META    meta_key    SET    stmt_expr
+            {
+                $$ = meta_stmt_alloc(&@$, $2, $4);
+            }
+            |    meta_key_unqualified    SET    stmt_expr
+            {
+                $$ = meta_stmt_alloc(&@$, $1, $3);
+            }
+            |    META meta_key_object    SET    stmt_expr
             {
                 switch ($2) {
                 case NFT_META_SECMARK:
@@ -4161,14 +4185,10 @@ meta_stmt        :    META    meta_key    SET
  stmt_expr
                     $$->objref.expr = $4;
                     break;
                 default:
-                    $$ = meta_stmt_alloc(&@$, $2, $4);
-                    break;
+                    erec_queue(error(&@2, "invalid meta object name
'%s'\n", $2), state->msgs);
+                    YYERROR;
                 }
             }
-            |    meta_key_unqualified    SET    stmt_expr
-            {
-                $$ = meta_stmt_alloc(&@$, $1, $3);
-            }
             |    META    STRING    SET    stmt_expr
             {
                 struct error_record *erec;
@@ -4354,6 +4374,7 @@ ct_key            :    L3PROTOCOL    { $$ =
NFT_CT_L3PROTOCOL; }
             |    PROTO_DST    { $$ = NFT_CT_PROTO_DST; }
             |    LABEL        { $$ = NFT_CT_LABELS; }
             |    EVENT        { $$ = NFT_CT_EVENTMASK; }
+            |    SECMARK_RAW    { $$ = NFT_CT_SECMARK; }
             |    ct_key_dir_optional
             ;

diff --git a/src/rule.c b/src/rule.c
index 64756bc..dbbec5e 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2454,6 +2454,12 @@ static int do_command_reset(struct netlink_ctx
*ctx, struct cmd *cmd)
     case CMD_OBJ_QUOTA:
         type = NFT_OBJECT_QUOTA;
         break;
+    case CMD_OBJ_SECMARKS:
+        dump = true;
+        /* fall through */
+    case CMD_OBJ_SECMARK:
+        type = NFT_OBJECT_SECMARK;
+        break;
     default:
         BUG("invalid command object type %u\n", cmd->obj);
     }
diff --git a/src/scanner.l b/src/scanner.l
index 3de5a9e..feaa691 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -591,6 +591,7 @@ addrstring    ({macaddr}|{ip4addr}|{ip6addr})

 "secmark"        { return SECMARK; }
 "secmarks"        { return SECMARKS; }
+"secmark_raw"        { return SECMARK_RAW; }

 {addrstring}        {
                 yylval->string = xstrdup(yytext);
-- 
2.24.0.rc1

--0000000000001b64230595f94c19
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-add-secmark_raw-for-storing-secmark-id-in-packet-sta.patch"
Content-Disposition: attachment; 
	filename="0001-add-secmark_raw-for-storing-secmark-id-in-packet-sta.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k2aimicz0>
X-Attachment-Id: f_k2aimicz0

RnJvbSBjNTU5Y2IzN2UwOTUyNmUwMmRhMDI3MjQwMTdkMGY5MjFhMDNhMWMxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/Q2hyaXN0aWFuPTIwRz1DMz1CNnR0c2NoZT89
IDxjZ3pvbmVzQGdvb2dsZW1haWwuY29tPgpEYXRlOiBNb24sIDI4IE9jdCAyMDE5IDE1OjEyOjI5
ICswMTAwClN1YmplY3Q6IFtQQVRDSF0gYWRkIHNlY21hcmtfcmF3IGZvciBzdG9yaW5nIHNlY21h
cmsgaWQgaW4gcGFja2V0IHN0YXRlCgotLS0KIHNyYy9jdC5jICAgICAgICAgICB8ICAyICsrCiBz
cmMvZXZhbHVhdGUuYyAgICAgfCAgMiArKwogc3JjL21ldGEuYyAgICAgICAgIHwgIDMgKysrCiBz
cmMvcGFyc2VyX2Jpc29uLnkgfCAzNyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0t
LS0tCiBzcmMvcnVsZS5jICAgICAgICAgfCAgNiArKysrKysKIHNyYy9zY2FubmVyLmwgICAgICB8
ICAxICsKIDYgZmlsZXMgY2hhbmdlZCwgNDMgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9zcmMvY3QuYyBiL3NyYy9jdC5jCmluZGV4IGVkNDU4ZTYuLjllNmE4MzUg
MTAwNjQ0Ci0tLSBhL3NyYy9jdC5jCisrKyBiL3NyYy9jdC5jCkBAIC0yOTksNiArMjk5LDggQEAg
Y29uc3Qgc3RydWN0IGN0X3RlbXBsYXRlIGN0X3RlbXBsYXRlc1tfX05GVF9DVF9NQVhdID0gewog
CQkJCQkgICAgICBCWVRFT1JERVJfQklHX0VORElBTiwgMTI4KSwKIAlbTkZUX0NUX0RTVF9JUDZd
CT0gQ1RfVEVNUExBVEUoImlwNiBkYWRkciIsICZpcDZhZGRyX3R5cGUsCiAJCQkJCSAgICAgIEJZ
VEVPUkRFUl9CSUdfRU5ESUFOLCAxMjgpLAorCVtORlRfQ1RfU0VDTUFSS10JPSBDVF9URU1QTEFU
RSgic2VjbWFyayIsICZpbnRlZ2VyX3R5cGUsCisJCQkJCSAgICAgIEJZVEVPUkRFUl9IT1NUX0VO
RElBTiwgMzIpLAogfTsKIAogc3RhdGljIHZvaWQgY3RfcHJpbnQoZW51bSBuZnRfY3Rfa2V5cyBr
ZXksIGludDhfdCBkaXIsIHVpbnQ4X3QgbmZwcm90bywKZGlmZiAtLWdpdCBhL3NyYy9ldmFsdWF0
ZS5jIGIvc3JjL2V2YWx1YXRlLmMKaW5kZXggYTU2Y2QyYS4uMWIyZjVlMyAxMDA2NDQKLS0tIGEv
c3JjL2V2YWx1YXRlLmMKKysrIGIvc3JjL2V2YWx1YXRlLmMKQEAgLTM5NDQsOCArMzk0NCwxMCBA
QCBzdGF0aWMgaW50IGNtZF9ldmFsdWF0ZV9yZXNldChzdHJ1Y3QgZXZhbF9jdHggKmN0eCwgc3Ry
dWN0IGNtZCAqY21kKQogCXN3aXRjaCAoY21kLT5vYmopIHsKIAljYXNlIENNRF9PQkpfQ09VTlRF
UjoKIAljYXNlIENNRF9PQkpfUVVPVEE6CisJY2FzZSBDTURfT0JKX1NFQ01BUks6CiAJY2FzZSBD
TURfT0JKX0NPVU5URVJTOgogCWNhc2UgQ01EX09CSl9RVU9UQVM6CisJY2FzZSBDTURfT0JKX1NF
Q01BUktTOgogCQlpZiAoY21kLT5oYW5kbGUudGFibGUubmFtZSA9PSBOVUxMKQogCQkJcmV0dXJu
IDA7CiAJCWlmICh0YWJsZV9sb29rdXAoJmNtZC0+aGFuZGxlLCAmY3R4LT5uZnQtPmNhY2hlKSA9
PSBOVUxMKQpkaWZmIC0tZ2l0IGEvc3JjL21ldGEuYyBiL3NyYy9tZXRhLmMKaW5kZXggZjU0Yjgx
OC4uODA5M2Q2NyAxMDA2NDQKLS0tIGEvc3JjL21ldGEuYworKysgYi9zcmMvbWV0YS5jCkBAIC03
MDksNiArNzA5LDggQEAgY29uc3Qgc3RydWN0IG1ldGFfdGVtcGxhdGUgbWV0YV90ZW1wbGF0ZXNb
XSA9IHsKIAlbTkZUX01FVEFfVElNRV9IT1VSXQk9IE1FVEFfVEVNUExBVEUoImhvdXIiLCAmaG91
cl90eXBlLAogCQkJCQkJNCAqIEJJVFNfUEVSX0JZVEUsCiAJCQkJCQlCWVRFT1JERVJfSE9TVF9F
TkRJQU4pLAorCVtORlRfTUVUQV9TRUNNQVJLXQk9IE1FVEFfVEVNUExBVEUoInNlY21hcmsiLCAm
aW50ZWdlcl90eXBlLAorCQkJCQkJMzIsIEJZVEVPUkRFUl9IT1NUX0VORElBTiksCiB9OwogCiBz
dGF0aWMgYm9vbCBtZXRhX2tleV9pc191bnF1YWxpZmllZChlbnVtIG5mdF9tZXRhX2tleXMga2V5
KQpAQCAtNzIwLDYgKzcyMiw3IEBAIHN0YXRpYyBib29sIG1ldGFfa2V5X2lzX3VucXVhbGlmaWVk
KGVudW0gbmZ0X21ldGFfa2V5cyBrZXkpCiAJY2FzZSBORlRfTUVUQV9PSUZOQU1FOgogCWNhc2Ug
TkZUX01FVEFfSUlGR1JPVVA6CiAJY2FzZSBORlRfTUVUQV9PSUZHUk9VUDoKKwljYXNlIE5GVF9N
RVRBX1NFQ01BUks6CiAJCXJldHVybiB0cnVlOwogCWRlZmF1bHQ6CiAJCXJldHVybiBmYWxzZTsK
ZGlmZiAtLWdpdCBhL3NyYy9wYXJzZXJfYmlzb24ueSBiL3NyYy9wYXJzZXJfYmlzb24ueQppbmRl
eCAxMWYwZGM4Li4xNmZjZWEyIDEwMDY0NAotLS0gYS9zcmMvcGFyc2VyX2Jpc29uLnkKKysrIGIv
c3JjL3BhcnNlcl9iaXNvbi55CkBAIC00NzksNiArNDc5LDcgQEAgaW50IG5mdF9sZXgodm9pZCAq
LCB2b2lkICosIHZvaWQgKik7CiAKICV0b2tlbiBTRUNNQVJLCQkJInNlY21hcmsiCiAldG9rZW4g
U0VDTUFSS1MJCQkic2VjbWFya3MiCisldG9rZW4gU0VDTUFSS19SQVcJCSJzZWNtYXJrX3JhdyIK
IAogJXRva2VuIE5BTk9TRUNPTkQJCSJuYW5vc2Vjb25kIgogJXRva2VuIE1JQ1JPU0VDT05ECQki
bWljcm9zZWNvbmQiCkBAIC03NDgsNyArNzQ5LDcgQEAgaW50IG5mdF9sZXgodm9pZCAqLCB2b2lk
ICosIHZvaWQgKik7CiAKICV0eXBlIDxleHByPgkJCW1ldGFfZXhwcgogJWRlc3RydWN0b3IgeyBl
eHByX2ZyZWUoJCQpOyB9CW1ldGFfZXhwcgotJXR5cGUgPHZhbD4JCQltZXRhX2tleQltZXRhX2tl
eV9xdWFsaWZpZWQJbWV0YV9rZXlfdW5xdWFsaWZpZWQJbnVtZ2VuX3R5cGUKKyV0eXBlIDx2YWw+
CQkJbWV0YV9rZXkJbWV0YV9rZXlfcXVhbGlmaWVkCW1ldGFfa2V5X3VucXVhbGlmaWVkCW1ldGFf
a2V5X29iamVjdAludW1nZW5fdHlwZQogCiAldHlwZSA8ZXhwcj4JCQlzb2NrZXRfZXhwcgogJWRl
c3RydWN0b3IgeyBleHByX2ZyZWUoJCQpOyB9IHNvY2tldF9leHByCkBAIC0xMzY1LDYgKzEzNjYs
MTggQEAgcmVzZXRfY21kCQk6CUNPVU5URVJTCXJ1bGVzZXRfc3BlYwogCQkJewogCQkJCSQkID0g
Y21kX2FsbG9jKENNRF9SRVNFVCwgQ01EX09CSl9RVU9UQSwgJiQyLCAmQCQsIE5VTEwpOwogCQkJ
fQorCQkJfAlTRUNNQVJLUwlydWxlc2V0X3NwZWMKKwkJCXsKKwkJCQkkJCA9IGNtZF9hbGxvYyhD
TURfUkVTRVQsIENNRF9PQkpfU0VDTUFSS1MsICYkMiwgJkAkLCBOVUxMKTsKKwkJCX0KKwkJCXwJ
U0VDTUFSS1MJVEFCTEUJdGFibGVfc3BlYworCQkJeworCQkJCSQkID0gY21kX2FsbG9jKENNRF9S
RVNFVCwgQ01EX09CSl9TRUNNQVJLUywgJiQzLCAmQCQsIE5VTEwpOworCQkJfQorCQkJfCAgICAg
ICBTRUNNQVJLCQlvYmpfc3BlYworCQkJeworCQkJCSQkID0gY21kX2FsbG9jKENNRF9SRVNFVCwg
Q01EX09CSl9TRUNNQVJLLCAmJDIsICZAJCwgTlVMTCk7CisJCQl9CiAJCQk7CiAKIGZsdXNoX2Nt
ZAkJOglUQUJMRQkJdGFibGVfc3BlYwpAQCAtNDEyMyw3ICs0MTM2LDcgQEAgbWV0YV9rZXlfcXVh
bGlmaWVkCToJTEVOR1RICQl7ICQkID0gTkZUX01FVEFfTEVOOyB9CiAJCQl8CVBST1RPQ09MCXsg
JCQgPSBORlRfTUVUQV9QUk9UT0NPTDsgfQogCQkJfAlQUklPUklUWQl7ICQkID0gTkZUX01FVEFf
UFJJT1JJVFk7IH0KIAkJCXwJUkFORE9NCQl7ICQkID0gTkZUX01FVEFfUFJBTkRPTTsgfQotCQkJ
fAlTRUNNQVJLCQl7ICQkID0gTkZUX01FVEFfU0VDTUFSSzsgfQorCQkJfAlTRUNNQVJLX1JBVwl7
ICQkID0gTkZUX01FVEFfU0VDTUFSSzsgfQogCQkJOwogCiBtZXRhX2tleV91bnF1YWxpZmllZAk6
CU1BUksJCXsgJCQgPSBORlRfTUVUQV9NQVJLOyB9CkBAIC00MTUyLDcgKzQxNjUsMTggQEAgbWV0
YV9rZXlfdW5xdWFsaWZpZWQJOglNQVJLCQl7ICQkID0gTkZUX01FVEFfTUFSSzsgfQogCQkJfCAg
ICAgICBIT1VSCQl7ICQkID0gTkZUX01FVEFfVElNRV9IT1VSOyB9CiAJCQk7CiAKK21ldGFfa2V5
X29iamVjdAkJOglTRUNNQVJLCQl7ICQkID0gTkZUX01FVEFfU0VDTUFSSzsgfQorCQkJOworCiBt
ZXRhX3N0bXQJCToJTUVUQQltZXRhX2tleQlTRVQJc3RtdF9leHByCisJCQl7CisJCQkJJCQgPSBt
ZXRhX3N0bXRfYWxsb2MoJkAkLCAkMiwgJDQpOworCQkJfQorCQkJfAltZXRhX2tleV91bnF1YWxp
ZmllZAlTRVQJc3RtdF9leHByCisJCQl7CisJCQkJJCQgPSBtZXRhX3N0bXRfYWxsb2MoJkAkLCAk
MSwgJDMpOworCQkJfQorCQkJfAlNRVRBIG1ldGFfa2V5X29iamVjdAlTRVQJc3RtdF9leHByCiAJ
CQl7CiAJCQkJc3dpdGNoICgkMikgewogCQkJCWNhc2UgTkZUX01FVEFfU0VDTUFSSzoKQEAgLTQx
NjEsMTQgKzQxODUsMTAgQEAgbWV0YV9zdG10CQk6CU1FVEEJbWV0YV9rZXkJU0VUCXN0bXRfZXhw
cgogCQkJCQkkJC0+b2JqcmVmLmV4cHIgPSAkNDsKIAkJCQkJYnJlYWs7CiAJCQkJZGVmYXVsdDoK
LQkJCQkJJCQgPSBtZXRhX3N0bXRfYWxsb2MoJkAkLCAkMiwgJDQpOwotCQkJCQlicmVhazsKKwkJ
CQkJZXJlY19xdWV1ZShlcnJvcigmQDIsICJpbnZhbGlkIG1ldGEgb2JqZWN0IG5hbWUgJyVzJ1xu
IiwgJDIpLCBzdGF0ZS0+bXNncyk7CisJCQkJCVlZRVJST1I7CiAJCQkJfQogCQkJfQotCQkJfAlt
ZXRhX2tleV91bnF1YWxpZmllZAlTRVQJc3RtdF9leHByCi0JCQl7Ci0JCQkJJCQgPSBtZXRhX3N0
bXRfYWxsb2MoJkAkLCAkMSwgJDMpOwotCQkJfQogCQkJfAlNRVRBCVNUUklORwlTRVQJc3RtdF9l
eHByCiAJCQl7CiAJCQkJc3RydWN0IGVycm9yX3JlY29yZCAqZXJlYzsKQEAgLTQzNTQsNiArNDM3
NCw3IEBAIGN0X2tleQkJCToJTDNQUk9UT0NPTAl7ICQkID0gTkZUX0NUX0wzUFJPVE9DT0w7IH0K
IAkJCXwJUFJPVE9fRFNUCXsgJCQgPSBORlRfQ1RfUFJPVE9fRFNUOyB9CiAJCQl8CUxBQkVMCQl7
ICQkID0gTkZUX0NUX0xBQkVMUzsgfQogCQkJfAlFVkVOVAkJeyAkJCA9IE5GVF9DVF9FVkVOVE1B
U0s7IH0KKwkJCXwJU0VDTUFSS19SQVcJeyAkJCA9IE5GVF9DVF9TRUNNQVJLOyB9CiAJCQl8CWN0
X2tleV9kaXJfb3B0aW9uYWwKIAkJCTsKIApkaWZmIC0tZ2l0IGEvc3JjL3J1bGUuYyBiL3NyYy9y
dWxlLmMKaW5kZXggNjQ3NTZiYy4uZGJiZWM1ZSAxMDA2NDQKLS0tIGEvc3JjL3J1bGUuYworKysg
Yi9zcmMvcnVsZS5jCkBAIC0yNDU0LDYgKzI0NTQsMTIgQEAgc3RhdGljIGludCBkb19jb21tYW5k
X3Jlc2V0KHN0cnVjdCBuZXRsaW5rX2N0eCAqY3R4LCBzdHJ1Y3QgY21kICpjbWQpCiAJY2FzZSBD
TURfT0JKX1FVT1RBOgogCQl0eXBlID0gTkZUX09CSkVDVF9RVU9UQTsKIAkJYnJlYWs7CisJY2Fz
ZSBDTURfT0JKX1NFQ01BUktTOgorCQlkdW1wID0gdHJ1ZTsKKwkJLyogZmFsbCB0aHJvdWdoICov
CisJY2FzZSBDTURfT0JKX1NFQ01BUks6CisJCXR5cGUgPSBORlRfT0JKRUNUX1NFQ01BUks7CisJ
CWJyZWFrOwogCWRlZmF1bHQ6CiAJCUJVRygiaW52YWxpZCBjb21tYW5kIG9iamVjdCB0eXBlICV1
XG4iLCBjbWQtPm9iaik7CiAJfQpkaWZmIC0tZ2l0IGEvc3JjL3NjYW5uZXIubCBiL3NyYy9zY2Fu
bmVyLmwKaW5kZXggM2RlNWE5ZS4uZmVhYTY5MSAxMDA2NDQKLS0tIGEvc3JjL3NjYW5uZXIubAor
KysgYi9zcmMvc2Nhbm5lci5sCkBAIC01OTEsNiArNTkxLDcgQEAgYWRkcnN0cmluZwkoe21hY2Fk
ZHJ9fHtpcDRhZGRyfXx7aXA2YWRkcn0pCiAKICJzZWNtYXJrIgkJeyByZXR1cm4gU0VDTUFSSzsg
fQogInNlY21hcmtzIgkJeyByZXR1cm4gU0VDTUFSS1M7IH0KKyJzZWNtYXJrX3JhdyIJCXsgcmV0
dXJuIFNFQ01BUktfUkFXOyB9CiAKIHthZGRyc3RyaW5nfQkJewogCQkJCXl5bHZhbC0+c3RyaW5n
ID0geHN0cmR1cCh5eXRleHQpOwotLSAKMi4yNC4wLnJjMQoK
--0000000000001b64230595f94c19--
