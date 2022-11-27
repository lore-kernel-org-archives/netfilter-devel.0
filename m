Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B680C47088
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Nov 2022 00:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiK0AX0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Nov 2022 19:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiK0AXY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Nov 2022 19:23:24 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB35DEFB
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Nov 2022 16:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=I26HNUpisAStJINeCkkSb4DWg/cFSzj5lu0PsD06s60=; b=Xgvqmt0F08eLoFt8c4ULpljs4F
        R5jRR2L10tpoFT0Q7+tHYCLL1HM0teK7h6EXLJDzXyFivH56kpU3sjrsjy9UjuxVGQEWomsBrF+fM
        scIZffSwjeqzMw4vhPfH029F3n/VSrWIDPMw+UpDVjw8oDc/E9lsILD1yX4aYlytvSEckXX4fbbgD
        eEe5gXSWS2VCmL5eCeLZB9CECNKZoSI/30+YFc661XWdLsErwXCq5CNacG+ez3R8OBdKZB/U1sqOO
        xOVXnvm2/Z7/fwfNvtV2S30TQK8/Er4XpQXFz3qVQLInr+S7W/6L2BWsOktvxvVM2LyikssL9Lnyb
        rddOXniQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oz5S2-00Aj1L-K6; Sun, 27 Nov 2022 00:23:18 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Robert O'Brien <robrien@foxtrot-research.com>
Subject: [PATCH ulogd2 0/3] IP Address Formatting Fixes
Date:   Sun, 27 Nov 2022 00:22:57 +0000
Message-Id: <20221127002300.191936-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Robert O'Brien reported a bug in the output of the source and target IP
addresses of ARP packets using the GPRINT output plug-in and proposed a
fix for that particular bug:

  https://lore.kernel.org/netfilter-devel/005601d8f532$49cd7080$dd685180$@foxtrot-research.com/

It transpires that there are a number of incorrect assumptions about the
format of IP addresses in the code-base.  In a couple of places there
are endianness mismatches, but more commonly it is assumed that all IP
addresses are IPv4.

This series fixes a couple of things I noticed during triage, and then
converts all addresses internally to IPv6, using IPv4-in-IPv6 format for
IPv4 addresses, converting them back to IPv4 where necessary (e.g., on
output).

Things to note.

  1. Previously IP2HBIN passed IPv6 address through unmodified.  Now it
     ignores them altogether.
  2. The GPRINT and OPRINT plug-ins now use `inet_ntop` to format
     addresses and handle IPv6 address correctly.
  3. The SQL output plug-ins, which previously output garbage for IPv6
     addresses, now output NULL.

Patch 1 fixes a misspelt variable.
Patch 2 adds some missing int64_t support.
Patch 3 contains the IP address changes.

Jeremy Sowden (3):
  filter: IP2BIN: correct spelling of variable
  output: add missing support for int64_t values
  src: keep IPv4 addresses internally in IPv4-in-IPv6 format

 filter/raw2packet/ulogd_raw2packet_BASE.c | 24 +++++--
 filter/ulogd_filter_IP2BIN.c              | 39 +++-------
 filter/ulogd_filter_IP2HBIN.c             | 13 ++--
 filter/ulogd_filter_IP2STR.c              |  5 +-
 include/ulogd/ulogd.h                     | 52 ++++++++++++++
 input/flow/ulogd_inpflow_NFCT.c           | 24 ++++---
 output/ipfix/ulogd_output_IPFIX.c         |  4 +-
 output/sqlite3/ulogd_output_SQLITE3.c     | 24 +++++--
 output/ulogd_output_GPRINT.c              | 38 +++++++---
 output/ulogd_output_JSON.c                |  3 +
 output/ulogd_output_OPRINT.c              | 87 +++++++++++++----------
 src/ulogd.c                               |  3 +-
 util/db.c                                 | 18 +++--
 13 files changed, 219 insertions(+), 115 deletions(-)

-- 
2.35.1

