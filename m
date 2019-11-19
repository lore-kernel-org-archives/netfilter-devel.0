Return-Path: <SRS0=iRt+=ZL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6BBEC432C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 01:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CD7720730
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 01:07:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eQZD7nDw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbfKSBHT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Nov 2019 20:07:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45933 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726990AbfKSBHT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Nov 2019 20:07:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574125637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=CJHy8vdreX60OUtIcYGshZgecmKd9s+i+Qjzx9VsQlQ=;
        b=eQZD7nDwtUlcAX5BpGQp5ML1cBDYDJWiFZQg8qwxMqjltqConUmwrasyfW+mzQTAspUxK+
        P/TPNLiGYBR/bbL6M0h9hSR+IdZhplKGracOlw96G/XFNlHnvkdgKV2NdEGE5aCB4oJ8Lu
        JBU1aj5uBYmrQ0Sh6qYm27x89ZWoOhw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-r31XcunZNBmugLIFisK77g-1; Mon, 18 Nov 2019 20:07:16 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D995801E7E;
        Tue, 19 Nov 2019 01:07:15 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 523BABA45;
        Tue, 19 Nov 2019 01:07:13 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft 0/3] Introduce support for concatenated ranges
Date:   Tue, 19 Nov 2019 02:07:09 +0100
Message-Id: <20191119010712.39316-1-sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: r31XcunZNBmugLIFisK77g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is the counterpart of kernel series:
=09nftables: Set implementation for arbitrary concatenation of ranges

and it has a UAPI dependency on kernel patch:
=09[PATCH nf-next 1/8] nf_tables: Support for subkeys, set with multiple ra=
nged fields

Patch 1/3 adds support for NFT_SET_SUBKEY: these new netlink
attributes specify the length of fields within concatenations,
and they are needed by set implementations in the kernel to
figure out where single fields start and stop.

Patch 2/3 introduces new key data semantics needed to represent
arbitrary concatenation of ranges with minimal UAPI modifications,
as well as required changes in lexer and expression evaluation.

Patch 3/3 adds test cases for operations on the new set type.

I'm not updating the UAPI header copy in this series, please
let me know if I'd better do that.

Stefano Brivio (3):
  src: Add support for and export NFT_SET_SUBKEY attributes
  src: Add support for concatenated set ranges
  tests: Introduce test for set with concatenated ranges

 include/expression.h                          |   4 +
 include/netlink.h                             |   2 +-
 include/rule.h                                |   1 +
 src/evaluate.c                                |  25 ++-
 src/mnl.c                                     |   4 +
 src/netlink.c                                 |  95 +++++++---
 src/netlink_linearize.c                       |  16 +-
 src/parser_bison.y                            |  25 ++-
 src/rule.c                                    |  10 +-
 src/segtree.c                                 | 134 +++++++++++++++
 .../testcases/sets/0038concatenated_ranges_0  | 162 ++++++++++++++++++
 11 files changed, 432 insertions(+), 46 deletions(-)
 create mode 100755 tests/shell/testcases/sets/0038concatenated_ranges_0

--=20
2.23.0

