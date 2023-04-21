Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 586FEC7618E
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Apr 2023 17:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbjDURkH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Apr 2023 13:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233178AbjDURkE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Apr 2023 13:40:04 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FEE6EB9
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Apr 2023 10:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=I3qA61tKBHvRdGg1K0UElxpYz2OhjFUF18KLiLzKERg=; b=IJMRMRU+Z7zvSUIzy73ZvA87Iv
        kUQfIpYd2Pnq3PKmSoTqHo3gk1LicbX7ZhI09LWPAkJMI2FtL8jgFf6no870KADkjSQsRutqsnVcx
        KfPeChRdzcwkQ1zv975SJSBz1z03OfBR/iCIl3rGWh0XcU37z2Dp2s/veYzRjBkqSmE4gcMyy93KH
        YLKAcVa9hhTzQI849NI9Egi3aSO5WdU7nK9dmxraK+aLa8iWhdd6c9SKOwv2ESvBaDLZ0f8TPj9H7
        wC6hgwD44AkjFSEcfejvyGUDYSIK7dplk7j/wh1A7O41YExOcDPn5Kezgh1CXZNk+lW/Es5zyzEuY
        e0cvHq+Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ppujp-00089F-7r; Fri, 21 Apr 2023 19:40:01 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 0/3] Extract nftnl_rule parsing code
Date:   Fri, 21 Apr 2023 19:40:11 +0200
Message-Id: <20230421174014.17014-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft-shared.c was already oversized, upcoming enhancement of the
nftnl_rule parser will add to that. So prepare any further work in that
field by creating a common 'nft-ruleparse.c' source and one for each
family to hold all the parsing code (basically the stack below
nft_rule_to_iptables_command_state).

Collect the existing expression parsing callbacks in a new struct
nft_ruleparse_ops and add a pointer to it into nft_family_ops. This way
the callbacks may be static and the nft-ruleparse-<family>.c sources
only export their ops object.

This series does things somewhat gradually:

* First pull everything from nft-shared.c into nft-ruleparse.c (likewise
  with header files)
* Then perform the *_ops struct changes which should not have a
  functional implication
* Finally weed parsers from nft-<family>.c files into
  nft-ruleparse-<family>.c ones.

Phil Sutter (3):
  nft: Introduce nft-ruleparse.{c,h}
  nft: Extract rule parsing callbacks from nft_family_ops
  nft: ruleparse: Create family-specific source files

 iptables/Makefile.am            |    3 +
 iptables/nft-arp.c              |  139 +---
 iptables/nft-bridge.c           |  390 +---------
 iptables/nft-cache.h            |    2 +
 iptables/nft-ipv4.c             |  106 +--
 iptables/nft-ipv6.c             |   83 +--
 iptables/nft-ruleparse-arp.c    |  168 +++++
 iptables/nft-ruleparse-bridge.c |  422 +++++++++++
 iptables/nft-ruleparse-ipv4.c   |  135 ++++
 iptables/nft-ruleparse-ipv6.c   |  112 +++
 iptables/nft-ruleparse.c        | 1208 +++++++++++++++++++++++++++++++
 iptables/nft-ruleparse.h        |  138 ++++
 iptables/nft-shared.c           | 1190 ------------------------------
 iptables/nft-shared.h           |  115 +--
 14 files changed, 2194 insertions(+), 2017 deletions(-)
 create mode 100644 iptables/nft-ruleparse-arp.c
 create mode 100644 iptables/nft-ruleparse-bridge.c
 create mode 100644 iptables/nft-ruleparse-ipv4.c
 create mode 100644 iptables/nft-ruleparse-ipv6.c
 create mode 100644 iptables/nft-ruleparse.c
 create mode 100644 iptables/nft-ruleparse.h

-- 
2.40.0

