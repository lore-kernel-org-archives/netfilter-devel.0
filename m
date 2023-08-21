Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28A5FEE4996
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Aug 2023 19:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjHUTnI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Aug 2023 15:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjHUTnG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2023 15:43:06 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7639D9
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2023 12:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Fs0SD16kBJTFNYx5sUguAJrcgnleJJitzcPAYCzb+6s=; b=PYHPJODiE+1dgxeZfSLqa+C8AA
        D9tbGixDnMag/HVCT93pJ0ngrRKeJBGyRQOfvXI1ZLQF5mo3uRhD+OUGaiE5RdyIdHTtgnPM6rHbw
        1s8+lUSBKsF6ZwMbsRTbzIsZRgZ0IdgO9sT659HNoTV70KDzXh08sOVpOZF0LmdbPlRBpkp1JN7vn
        yrIs8EsEfFV6oDpbW5iUIJ/Egm0Zz/41Y4QhlWEx03naAknCdo+pplY4hq39njca6WVWCkgMw2OFU
        KKvew6AP4OBnyDkK/DMZgpZirMNZQcMEInz+vh9iYWjgVm0XgDsA91UuypcQWmZXIUN6nO2DkVQhL
        eL1sM6qg==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qYAnn-00909U-1N
        for netfilter-devel@vger.kernel.org;
        Mon, 21 Aug 2023 20:43:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v3 00/11] Fixes for handling and output of IP addresses
Date:   Mon, 21 Aug 2023 20:42:26 +0100
Message-Id: <20230821194237.51139-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Robert O'Brien reported a bug in the output of the source and target IP
addresses of ARP packets using the GPRINT output plug-in and proposed a
fix for that particular bug:

  https://lore.kernel.org/netfilter-devel/005601d8f532$49cd7080$dd685180$@foxtrot-research.com/

It transpired that there are a number of incorrect assumptions about the
format of IP addresses in the code-base.  In a couple of places there
are endianness mismatches, but more commonly it is assumed that all IP
addresses are IPv4.

In the previous versions of this work, my solution for fixing the
handling of IPv6 addresses was to handle all addresses internally as
IPv6 by converting IPv4 addresses to IPv4-in-IPv6 ("::ffff:a.b.c.d"),
and then convert IPv4-in-IPv6 address back to IPv4 on output.  However,
Florian pointed out that this means that if ulogd2 receives a real
IPv4-in-IPv6 address as input it will be indistinguishable from the
synthetic ones and so converted to IPv4 format on output.

In this version, I have taken a different approach.  Input keys have a
legnth field which is not used for fixed-width data-types.  I have used
this to distinguish 128-bit IPv6 addresses from 32-bit IPv4 ones.

I have also broken up the single patch of previous versions into a
series of smaller, hopefully more easily comprehensible ones, separating
out, in particular, the endianness fixes from the IPv6 ones.

One thing to note is that this changes the expected endianness of IP
address in the OPRINT plug-in.

Jeremy Sowden (11):
  src: record length of integer key values
  printpkt: fix statement punctuator
  printpkt, raw2packet_BASE: keep gateway address in NBO
  raw2packet_BASE: store ARP address values as integers
  ip2hbin: store ipv6 address as integer
  ipfix: skip non-ipv4 addresses
  gprint, oprint: use inet_ntop to format ip addresses
  gprint, oprint: add support for printing ipv6 addresses
  sqlite3: correct binding of ipv4 addresses and 64-bit integers
  sqlite3: insert ipv6 addresses as null rather than garbage
  db: insert ipv6 addresses in the same format as ip2bin

 filter/raw2packet/ulogd_raw2packet_BASE.c | 15 ++++---
 filter/ulogd_filter_IP2BIN.c              | 33 +--------------
 filter/ulogd_filter_IP2HBIN.c             |  9 ++--
 include/ulogd/ulogd.h                     | 50 ++++++++++++++++++++++-
 output/ipfix/ulogd_output_IPFIX.c         |  3 ++
 output/sqlite3/ulogd_output_SQLITE3.c     | 20 ++++++---
 output/ulogd_output_GPRINT.c              | 32 ++++++++++-----
 output/ulogd_output_OPRINT.c              | 41 +++++++++++--------
 util/db.c                                 | 19 +++++++--
 util/printpkt.c                           |  5 ++-
 10 files changed, 146 insertions(+), 81 deletions(-)

-- 
2.40.1

