Return-Path: <SRS0=kgPV=3D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D1B1C3F68F
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 21:29:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB9F724656
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 21:29:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="ffX/kIO3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgANV3C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Jan 2020 16:29:02 -0500
Received: from kadath.azazel.net ([81.187.231.250]:55006 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728731AbgANV3C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 16:29:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cBjhdH6avh6t4Ngu3erkX/Q9uvAPML/2OvJMUvN73t0=; b=ffX/kIO3elPmQLbrg+Y7DQ1roV
        Y8Y4S9DgaD/zfJR35ozZ/eC2wsZdNntuFol5NPTPwJSqyR2rksU1vwEtxAGgAkktYbNbkmFm7PG0N
        wdx/vLbsbppXPvy5zi9nn3LCzRRtCb1AkxoXbwY/K+O1Kwvxiz3hlEkgVZe8JwBS2JMq4g9i8fUOB
        x5Avav9+VOr1AsKQXjwr1bUb2aMScTRsr29eAK8sdt56WBBeAFdG+HKIRLKHGShqlv40UA050WkfM
        3TdyYiNHq/GOkCC4d+njL2JxQzJK5997AexR83mDfaOUeE5mkbGvBMnRUqGpjCeYR6ezfqlaV/yR7
        97NTtwCA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1irTkC-0001CO-HB; Tue, 14 Jan 2020 21:29:00 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 0/3] netfilter: nft_bitwise: shift support
Date:   Tue, 14 Jan 2020 21:28:57 +0000
Message-Id: <20200114212900.134015-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The connmark xtables extension supports bit-shifts.  Add support for
shifts to nft_bitwise in order to allow nftables to do likewise, e.g.:

  nft add rule t c oif lo ct mark set meta mark << 8 | 0xab
  nft add rule t c iif lo meta mark & 0xff 0xab ct mark set meta mark >> 8

There are a couple of preliminary tidying-up patches first.

Jeremy Sowden (3):
  netfilter: nf_tables: white-space fixes.
  netfilter: bitwise: replace gotos with returns.
  netfilter: bitwise: add support for shifts.

 include/uapi/linux/netfilter/nf_tables.h |  9 ++-
 net/netfilter/nft_bitwise.c              | 97 ++++++++++++++++++++----
 net/netfilter/nft_set_bitmap.c           |  4 +-
 net/netfilter/nft_set_hash.c             |  2 +-
 4 files changed, 94 insertions(+), 18 deletions(-)

-- 
2.24.1

