Return-Path: <SRS0=vOmJ=3I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB33AC33CB1
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 13:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 920D720663
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 13:35:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="idjE5nQo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgASNff (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 Jan 2020 08:35:35 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48304 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726816AbgASNff (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Jan 2020 08:35:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579440934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xS9eJ7SuBOIJ0ztXEWmKfOJ59T0NmgtsXxJNa7eUxjw=;
        b=idjE5nQofIHINvc7El1quuFpUmcs0d0P/gQup80mG5aVFnBHu87gJ8001RbhtDwjVdkPfx
        QOSI5w+7l7UQmf9Cg/KklBOH87ahyQuUQ6uRu8gH3W/uo6gIymwfsC3id0B6C0l4OmpB9f
        ObTF9TgfGxxiVe+ivnTw3N9R4dopWLs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-macwvJwZNCObL-npY3aaBQ-1; Sun, 19 Jan 2020 08:35:31 -0500
X-MC-Unique: macwvJwZNCObL-npY3aaBQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C59C58017CC;
        Sun, 19 Jan 2020 13:35:29 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-51.ams2.redhat.com [10.36.112.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E665089E81;
        Sun, 19 Jan 2020 13:35:27 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH libnftnl v3 0/2] Attributes for concatenated ranges
Date:   Sun, 19 Jan 2020 14:35:24 +0100
Message-Id: <cover.1579432712.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series adds support for NFTA_SET_DESC_CONCAT set attribute and
the additional key passed as NFTA_SET_ELEM_KEY_END to denote the
upper bound of a range in a generic way, as suggested by Pablo.

v3: Support for separate "end" key added as 2/2, reworked 1/2 to
    use set description data for length of concatenation fields

Stefano Brivio (2):
  set: Add support for NFTA_SET_DESC_CONCAT attributes
  set_elem: Introduce support for NFTNL_SET_ELEM_KEY_END

 include/libnftnl/set.h |   2 +
 include/set.h          |   2 +
 include/set_elem.h     |   1 +
 src/set.c              | 111 ++++++++++++++++++++++++++++++++++-------
 src/set_elem.c         |  24 +++++++++
 5 files changed, 121 insertions(+), 19 deletions(-)

--=20
2.24.1

