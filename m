Return-Path: <SRS0=vOmJ=3I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E54C33CB1
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 13:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77D9C20663
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 13:35:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zd97K0fX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgASNfM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 Jan 2020 08:35:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30504 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726816AbgASNfM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Jan 2020 08:35:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579440911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=z22WgVt996qqWrEY86ax0EaoXTan2lazNcBEhBl1PYw=;
        b=Zd97K0fXOzOIKm/0yk9BUCj6iuDJ7jNJCyp+VKny8z/GxU+hwI4KG3NSlPUHC1gWNoFimh
        7gsG53i9KDzgJ71fcZADDwqR+XOqxq4dTogsi2ifPGx5/QeLstISOOS7Qr9B8/3Ahv/QtO
        Hq0iUmbLiLebXkRLAk7vPo4sMFCBj30=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-PNdheUTLNgigsyiKclus-w-1; Sun, 19 Jan 2020 08:35:06 -0500
X-MC-Unique: PNdheUTLNgigsyiKclus-w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5AD378017CC;
        Sun, 19 Jan 2020 13:35:05 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-51.ams2.redhat.com [10.36.112.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E252428D19;
        Sun, 19 Jan 2020 13:34:57 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft v3 0/3] Introduce support for concatenated ranges
Date:   Sun, 19 Jan 2020 14:34:53 +0100
Message-Id: <cover.1579434179.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is the counterpart of kernel series:
  nftables: Set implementation for arbitrary concatenation of ranges

and it has a UAPI dependency on kernel patches:
  [PATCH nf-next v3 2/9] netfilter: nf_tables: add NFTA_SET_ELEM_KEY_END =
attribute
  [PATCH nf-next v3 3/9] netfilter: nf_tables: Support for sets with mult=
iple ranged fields

Patch 1/3 adds support for the NFTA_SET_DESC_CONCAT netlink
attributes: they specify the length of fields within concatenations,
and they are needed by set implementations in the kernel to figure
out where single fields start and stop.

Patch 2/3 introduces new key data semantics needed to represent
arbitrary concatenation of ranges, as well as required changes in
lexer and expression evaluation. Closing element of concatenated
ranges is now expressed by a separate key, as proposed by Pablo.

Patch 3/3 adds test cases for operations on the new set type.

v3: Changes listed in messages for all patches
v2: Changes listed in messages for 2/3 and 3/3

Stefano Brivio (3):
  src: Add support for NFTNL_SET_DESC_CONCAT
  src: Add support for concatenated set ranges
  tests: Introduce test for set with concatenated ranges

 include/expression.h                          |   3 +
 include/rule.h                                |  11 +-
 src/evaluate.c                                |  19 +-
 src/mnl.c                                     |   7 +
 src/netlink.c                                 | 120 ++++++++++---
 src/parser_bison.y                            |  17 +-
 src/rule.c                                    |  15 +-
 src/segtree.c                                 | 117 +++++++++++++
 .../testcases/sets/0042concatenated_ranges_0  | 162 ++++++++++++++++++
 9 files changed, 428 insertions(+), 43 deletions(-)
 create mode 100755 tests/shell/testcases/sets/0042concatenated_ranges_0

--=20
2.24.1

