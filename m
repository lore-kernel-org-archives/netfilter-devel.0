Return-Path: <SRS0=edwS=ZZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F44CC43215
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Dec 2019 16:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57BFD2068E
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Dec 2019 16:03:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dtYCn58+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfLCQDz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Dec 2019 11:03:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35094 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726365AbfLCQDy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Dec 2019 11:03:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575389033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=L/S9YEoC00wo/Of2441RPzayHTUYnY3vnFh0QpGH2VA=;
        b=dtYCn58+LwA3LmDHU2X/Nmo3uMCS2e2LbJXoYhdkLUNn+8OFMD5qQYLIB2zWsN0e/ZIh7h
        lgP1JeOBzKVbvFqSU1GSysX6BdNR7C8m8liMl9qVtEC0/tHQ/XAjVSMfmXnlHu7M1qxctk
        uiyGE0dEA25RXlNtHioQDAsdQliz3Zg=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-159lSBThNoWvCFh6tyMh4A-1; Tue, 03 Dec 2019 11:03:49 -0500
Received: by mail-qt1-f199.google.com with SMTP id h14so1070416qtq.11
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Dec 2019 08:03:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ilQ0+r0UBu4+GolSe7bf072ArjOFjAUnGKdJuleehSk=;
        b=g/11mAgacqbmsd0vYVLP4U9++J/pU7yOr8X3NBkOnQgR+h1yBFJrJ5I1bbCHDbuf5G
         Whn+ohJKL6pIWS4CkyLOpMPR5XQN65tFVql+rGU2f2/5h0kRJh6J3yKnjM+wdZjXyRDi
         DUPDrAVRG8vrwxbtoI3AJawNSg5/lbUCLT5LpRa2q6D177pNb2cPf/04OE2+FmI+7STA
         SZSyuy97q7j8KpoVPNAH9aZ4N368ycVyYtN46rP8WNd/rEY+FturtBi7gv1EikpxO6ay
         aAM0EE/h4ZcCkSYEmIGyBfs+uvrk39tAOw85MbGdEnBNtU8MX3INvFNVjmLY1FIF6KTk
         SZ0w==
X-Gm-Message-State: APjAAAVeYV1HB3suYtHkJ3EBOejsL8kPbzYoMvBByChSoCYb8oZ0LXIW
        fYjC5rufZOrCvX8tdmOtslOFBPiMG4fChnEWFwUZrKqjXXPwWSKg0h1lNp19Qss8u5s2f6E30cX
        1M4AEIS0uJcahweQiSUlB3W9ASzZO
X-Received: by 2002:ac8:461a:: with SMTP id p26mr5490195qtn.317.1575389028707;
        Tue, 03 Dec 2019 08:03:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqw4fOIwDRRPp6l7y0lv2pBkxHBG2W7El3I1jqcWKz1A9rg9pHTFG2qYGS/ZbAA+/l6HxaYdUQ==
X-Received: by 2002:ac8:461a:: with SMTP id p26mr5490164qtn.317.1575389028362;
        Tue, 03 Dec 2019 08:03:48 -0800 (PST)
Received: from labbott-redhat.redhat.com (pool-96-235-39-235.pitbpa.fios.verizon.net. [96.235.39.235])
        by smtp.gmail.com with ESMTPSA id i19sm1930260qki.124.2019.12.03.08.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 08:03:47 -0800 (PST)
From:   Laura Abbott <labbott@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Laura Abbott <labbott@redhat.com>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [PATCH] netfilter: nf_flow_table_offload: Correct memcpy size for flow_overload_mangle
Date:   Tue,  3 Dec 2019 11:03:45 -0500
Message-Id: <20191203160345.24743-1-labbott@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
X-MC-Unique: 159lSBThNoWvCFh6tyMh4A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The sizes for memcpy in flow_offload_mangle don't match
the source variables, leading to overflow errors on some
build configurations:

In function 'memcpy',
    inlined from 'flow_offload_mangle' at net/netfilter/nf_flow_table_offlo=
ad.c:112:2,
    inlined from 'flow_offload_port_dnat' at net/netfilter/nf_flow_table_of=
fload.c:373:2,
    inlined from 'nf_flow_rule_route_ipv4' at net/netfilter/nf_flow_table_o=
ffload.c:424:3:
./include/linux/string.h:376:4: error: call to '__read_overflow2' declared =
with attribute error: detected read beyond size of object passed as 2nd par=
ameter
  376 |    __read_overflow2();
      |    ^~~~~~~~~~~~~~~~~~
make[2]: *** [scripts/Makefile.build:266: net/netfilter/nf_flow_table_offlo=
ad.o] Error 1

Fix this by using the corresponding type.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Laura Abbott <labbott@redhat.com>
---
Seen on a Fedora powerpc little endian build with -O3 but it looks like
it is correctly catching an error with doing a memcpy outside the source
variable.
---
 net/netfilter/nf_flow_table_offload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_=
table_offload.c
index c54c9a6cc981..526f894d0bdb 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -108,8 +108,8 @@ static void flow_offload_mangle(struct flow_action_entr=
y *entry,
 =09entry->id =3D FLOW_ACTION_MANGLE;
 =09entry->mangle.htype =3D htype;
 =09entry->mangle.offset =3D offset;
-=09memcpy(&entry->mangle.mask, mask, sizeof(u32));
-=09memcpy(&entry->mangle.val, value, sizeof(u32));
+=09memcpy(&entry->mangle.mask, mask, sizeof(u8));
+=09memcpy(&entry->mangle.val, value, sizeof(u8));
 }
=20
 static inline struct flow_action_entry *
--=20
2.21.0

