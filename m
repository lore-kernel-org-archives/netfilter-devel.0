Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14C61C77B78
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 May 2023 12:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjECM5O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 May 2023 08:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjECM5O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2023 08:57:14 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6177140C4
        for <netfilter-devel@vger.kernel.org>; Wed,  3 May 2023 05:57:12 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-2f86ee42669so4943295f8f.2
        for <netfilter-devel@vger.kernel.org>; Wed, 03 May 2023 05:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1683118630; x=1685710630;
        h=mime-version:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0jtA4SKuXa9FWRRn77Z6/kZv7eFwvZMyeb49r5csUgg=;
        b=G90H7XjO3GguinJnQfccM+N603SHbE96VZhu7C9RbyLy/PGX4ODOoXiFFUkgBFHGa3
         1+gqb6VUxpIkqMxeZpSTjNKY/uElNL8pPTTWBMDEB3W3ChIvQ9aE5TiZzg+HZoMIMkCI
         P8iw2LTt19/L73K6lBlHVH1V4Fjzy9LAYTkq0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683118630; x=1685710630;
        h=mime-version:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0jtA4SKuXa9FWRRn77Z6/kZv7eFwvZMyeb49r5csUgg=;
        b=D64l/VC4NCMt9NLMDme4l/9ua8DEK5ElMg/fBRGXMI1lxTJ9elq21HhsbLWRppf5kW
         IteNS8WqMOnfuVP/L2xTWNAyg3drRNCvyfnEOMpxI8P/AfHNtgjfmtHMXhayykCCOYOr
         zKL73ZZduSZTiLYzDNnqw8YGq2YCplxlAZnlcwJA33q0xtgaqShtsiRKwlsZxVb7G2dd
         1SoLviNkZ01lfR/LazslxucTfPR4BrN3Fc+Lw4d2PEzI9RHTQs3MNdvq0WOCG5Psg7NH
         k6sQoUelBJx0/CNh/70laX52Fxn/NSWWcmFx6ITbV46fbGNVs3pwy+mQLMlJCj0EI+Pp
         JuSA==
X-Gm-Message-State: AC+VfDxSl0oiPBIKqkvazuSU9aeW5mD8GyH3zC7DIBMkhyxUdL5hXLqK
        9+CzYbyl1+3LVI2aWIzjE7XUBjZF8zZRxhx2OwV15yAZI+pdNU+9vXWo6tLH3aNoCOge3o5KMJR
        hZIOZLcSA7U2k0nIvMsBZ8PCoOI2eEqAXohsTnfa8mr8nbaas3c9i6VGSeXGU0t8mK1XRvDCV1W
        Go6UmgdEnxvpOa0ipbSyR6xQ==
X-Google-Smtp-Source: ACHHUZ4cfixRfHjTAJK0HHY3BO+GbnX8XaFiJA/AfNY+KcdMV77ebq9y4nma0ehgPlW9LsILRrSa1Q==
X-Received: by 2002:a5d:6606:0:b0:306:772:5c2e with SMTP id n6-20020a5d6606000000b0030607725c2emr9062272wru.70.1683118630546;
        Wed, 03 May 2023 05:57:10 -0700 (PDT)
Received: from localhost.localdomain ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id y11-20020adfe6cb000000b002f81b4227cesm33991436wrm.19.2023.05.03.05.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 05:57:10 -0700 (PDT)
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>
Subject: [PATCH nft] payload: add offload flag to the statements
Date:   Wed,  3 May 2023 15:56:54 +0300
Message-Id: <20230503125654.41126-1-boris.sukholitko@broadcom.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000001ae81805fac9980e"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--0000000000001ae81805fac9980e
Content-Transfer-Encoding: 8bit

Payload modification statements such as:

ip dscp set cs3

are not being executed by the flowtable fast path code the kernel.

This commit adds ability to mark such statements for offload to fix
this problem. For example the following configuration becomes correct
(notice offload in the ip dscp clause):

table inet filter {
        flowtable f1 {
                hook ingress priority filter
                devices = { veth0, veth1 }
        }

        chain forward {
                type filter hook forward priority filter; policy accept;
                ip dscp set cs3 offload
                ip protocol { tcp, udp, gre } flow add @f1
                ct state established,related accept
        }
}

Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
---
 include/linux/netfilter/nf_tables.h | 1 +
 include/statement.h                 | 3 ++-
 src/json.c                          | 9 ++++++++-
 src/netlink_delinearize.c           | 5 +++--
 src/netlink_linearize.c             | 8 ++++++--
 src/parser_bison.y                  | 9 ++++++---
 src/parser_json.c                   | 2 +-
 src/payload.c                       | 5 ++++-
 8 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index e4b739d5..ee12a884 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -778,6 +778,7 @@ enum nft_payload_csum_types {
 
 enum nft_payload_csum_flags {
 	NFT_PAYLOAD_L4CSUM_PSEUDOHDR = (1 << 0),
+	NFT_PAYLOAD_CAN_OFFLOAD = (1 << 1),
 };
 
 enum nft_inner_type {
diff --git a/include/statement.h b/include/statement.h
index e648fb13..fa1a048c 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -58,10 +58,11 @@ extern struct stmt *exthdr_stmt_alloc(const struct location *loc,
 struct payload_stmt {
 	struct expr			*expr;
 	struct expr			*val;
+	bool				can_offload;
 };
 
 extern struct stmt *payload_stmt_alloc(const struct location *loc,
-				       struct expr *payload, struct expr *expr);
+				       struct expr *payload, struct expr *expr, bool off);
 
 #include <meta.h>
 struct meta_stmt {
diff --git a/src/json.c b/src/json.c
index f57f2f77..df50962c 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1163,9 +1163,16 @@ json_t *flow_offload_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 
 json_t *payload_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
-	return json_pack("{s: {s:o, s:o}}", "mangle",
+	json_t *root;
+
+	root = json_pack("{s: {s:o, s:o}}", "mangle",
 			 "key", expr_print_json(stmt->payload.expr, octx),
 			 "value", expr_print_json(stmt->payload.val, octx));
+
+	if (stmt->payload.can_offload)
+		json_object_set_new(root, "offload", json_true());
+
+	return root;
 }
 
 json_t *exthdr_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 4cd6cc3a..48e2a520 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -713,13 +713,14 @@ static void netlink_parse_payload_stmt(struct netlink_parse_ctx *ctx,
 				       const struct nftnl_expr *nle)
 {
 	enum nft_registers sreg;
-	uint32_t base, offset, len;
+	uint32_t base, offset, len, flags;
 	struct expr *expr, *val;
 	struct stmt *stmt;
 
 	base   = nftnl_expr_get_u32(nle, NFTNL_EXPR_PAYLOAD_BASE) + 1;
 	offset = nftnl_expr_get_u32(nle, NFTNL_EXPR_PAYLOAD_OFFSET) * BITS_PER_BYTE;
 	len    = nftnl_expr_get_u32(nle, NFTNL_EXPR_PAYLOAD_LEN) * BITS_PER_BYTE;
+	flags    = nftnl_expr_get_u32(nle, NFTNL_EXPR_PAYLOAD_FLAGS);
 
 	sreg = netlink_parse_register(nle, NFTNL_EXPR_PAYLOAD_SREG);
 	val  = netlink_get_register(ctx, loc, sreg);
@@ -730,7 +731,7 @@ static void netlink_parse_payload_stmt(struct netlink_parse_ctx *ctx,
 	expr = payload_expr_alloc(loc, NULL, 0);
 	payload_init_raw(expr, base, offset, len);
 
-	stmt = payload_stmt_alloc(loc, expr, val);
+	stmt = payload_stmt_alloc(loc, expr, val, flags & NFT_PAYLOAD_CAN_OFFLOAD);
 	rule_stmt_append(ctx->rule, stmt);
 }
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 3da72f50..82c89b8c 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1070,12 +1070,15 @@ static void netlink_gen_payload_stmt(struct netlink_linearize_ctx *ctx,
 	const struct expr *expr;
 	enum nft_registers sreg;
 	unsigned int csum_off;
+	uint32_t flags = 0;
 
 	sreg = get_register(ctx, stmt->payload.val);
 	netlink_gen_expr(ctx, stmt->payload.val, sreg);
 	release_register(ctx, stmt->payload.val);
 
 	expr = stmt->payload.expr;
+	if (stmt->payload.can_offload)
+		flags |= NFT_PAYLOAD_CAN_OFFLOAD;
 
 	csum_off = 0;
 	desc = expr->payload.desc;
@@ -1099,9 +1102,10 @@ static void netlink_gen_payload_stmt(struct netlink_linearize_ctx *ctx,
 	if ((expr->payload.base == PROTO_BASE_NETWORK_HDR && desc &&
 	     payload_needs_l4csum_update_pseudohdr(expr, desc)) ||
 	    expr->payload.base == PROTO_BASE_INNER_HDR)
-		nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_FLAGS,
-				   NFT_PAYLOAD_L4CSUM_PSEUDOHDR);
+		flags |= NFT_PAYLOAD_L4CSUM_PSEUDOHDR;
 
+	if (flags)
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_FLAGS, flags);
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index ccf07a30..8954eb4c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -726,7 +726,7 @@ int nft_lex(void *, void *, void *);
 %destructor { stmt_free($$); }	reject_stmt reject_stmt_alloc
 %type <stmt>			nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc redir_stmt redir_stmt_alloc
 %destructor { stmt_free($$); }	nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc redir_stmt redir_stmt_alloc
-%type <val>			nf_nat_flags nf_nat_flag offset_opt
+%type <val>			nf_nat_flags nf_nat_flag offset_opt set_offload
 %type <stmt>			tproxy_stmt
 %destructor { stmt_free($$); }	tproxy_stmt
 %type <stmt>			synproxy_stmt synproxy_stmt_alloc
@@ -5325,15 +5325,18 @@ ct_stmt			:	CT	ct_key		SET	stmt_expr	close_scope_ct
 			}
 			;
 
-payload_stmt		:	payload_expr		SET	stmt_expr
+payload_stmt		:	payload_expr		SET	stmt_expr set_offload
 			{
 				if ($1->etype == EXPR_EXTHDR)
 					$$ = exthdr_stmt_alloc(&@$, $1, $3);
 				else
-					$$ = payload_stmt_alloc(&@$, $1, $3);
+					$$ = payload_stmt_alloc(&@$, $1, $3, $4);
 			}
 			;
 
+set_offload		:	OFFLOAD 	{ $$ = true; }
+			|	/* empty */	{ $$ = false; }
+
 payload_expr		:	payload_raw_expr
 			|	eth_hdr_expr
 			|	vlan_hdr_expr
diff --git a/src/parser_json.c b/src/parser_json.c
index ae683314..270dddeb 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1753,7 +1753,7 @@ static struct stmt *json_parse_mangle_stmt(struct json_ctx *ctx,
 	case EXPR_EXTHDR:
 		return exthdr_stmt_alloc(int_loc, key, value);
 	case EXPR_PAYLOAD:
-		return payload_stmt_alloc(int_loc, key, value);
+		return payload_stmt_alloc(int_loc, key, value, false);
 	case EXPR_META:
 		stmt = meta_stmt_alloc(int_loc, key->meta.key, value);
 		expr_free(key);
diff --git a/src/payload.c b/src/payload.c
index ed76623c..77390e02 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -373,6 +373,8 @@ static void payload_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	expr_print(stmt->payload.expr, octx);
 	nft_print(octx, " set ");
 	expr_print(stmt->payload.val, octx);
+	if (stmt->payload.can_offload)
+		nft_print(octx, " offload");
 }
 
 static void payload_stmt_destroy(struct stmt *stmt)
@@ -390,13 +392,14 @@ static const struct stmt_ops payload_stmt_ops = {
 };
 
 struct stmt *payload_stmt_alloc(const struct location *loc,
-				struct expr *expr, struct expr *val)
+				struct expr *expr, struct expr *val, bool off)
 {
 	struct stmt *stmt;
 
 	stmt = stmt_alloc(loc, &payload_stmt_ops);
 	stmt->payload.expr = expr;
 	stmt->payload.val  = val;
+	stmt->payload.can_offload  = off;
 	return stmt;
 }
 
-- 
2.32.0


--0000000000001ae81805fac9980e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBVgwggRAoAMCAQICDADJ2jIiOyGGK/8iRTANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAxMTU2MDBaFw0yNTA5MTAxMTU2MDBaMIGW
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGTAXBgNVBAMTEEJvcmlzIFN1a2hvbGl0a28xLDAqBgkqhkiG
9w0BCQEWHWJvcmlzLnN1a2hvbGl0a29AYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEA1uKd0fo+YWpPYs389dpHW5vbrVQvwiWI4VGPHISUMVVVcCwrVXMcmoEi1AMN
t+KhIYltFzX7vj+SjHzSWLGrXUX/DW2tDJRYRXdc8+lVAu1wBO4WIhcYCMY8BDPfpxkMoY4w/qIa
1rC9tzBPzIGAdrBfdEzjjqblnqi+sIG7bakS6h7njOPNf9HuyLSQOs+Qq3kK8A8pX6t6KtAdq4iP
td/fua/xzT9yf7xQ0v0AVUPd9O3rahX4kX4sHlUcEVb6eXSNRwdyirUgDaJkDPrhIPKFapov5OeK
9BR0SGqf9JnBbAcQrigtBfEwkeDY+dJprju7HLWVNFkaW9u8vvvbiwIDAQABo4IB3jCCAdowDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAoBgNVHREEITAfgR1ib3Jpcy5zdWtob2xpdGtvQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUB46dIlYd
tkC0osZXFEatb5Hu+C8wDQYJKoZIhvcNAQELBQADggEBAE/WXEAo/TOHDort0zhfb2Vu7BdK2MHO
7LVlNc5DtQqFW4S0EA+f5oxpwsTHSzqf5FVY3S3TeMGTGssz2y/nGWwznbP+ti0SmO13EYKODFao
6fOqaW6dPraTx2lXgvMYXn/VZ+bxpnyKcFwC4qVssadK6ezPvrCVszHmO7MNvpH2vsfE5ulVdzbU
zPffqO2QS6e4oXzmoYuX9sCNfol1TaQgCYgYoC4rexOBLLtYbwdKWi3/ttntZ2PHS1QRaDzrBSuw
L39zqstTC0LC/YoSKC/cU9igMELugG/Twy9uVlg2XXTY1wUYSWMsYlpydsrVyG18UScp7FlGFbWX
EWKS7pkxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwA
ydoyIjshhiv/IkUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPnPCtXjZjVwQTXX
APOxYl2SRH+Y6qj50+xPzFnZRlEEMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIzMDUwMzEyNTcxMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAi/4XtHkuU0LfKxQFVDLI25VrY+XI8QaeZ
x3zzF5+bS6PD0mzYam8ezNlxsrNEVW0PuecI3aK0E8gwIPYAy1179XM0VG9s4KHjBqCdyc9Ebq0/
rRcYED1NYqSfkQCycrknv+fzDOfAFiNtVN/UvU1itlgU7EutIef9hZqu0+NY+f3n1RxIDZt2gC1P
3Ju0cKptfJpzirZIjOuTmqkI/dChFcDpg6WeezISRhlIJjKGwb7EcWXfmmtb/OSLtS1IyYgihVog
ZuxwR3IjySS9D3ByRwS6fP4esd/w6Q7+Kkx8foPmwPG6WscuVCORjMUmWphmY7eNf2ZzKNY0pkGu
vxyK
--0000000000001ae81805fac9980e--
