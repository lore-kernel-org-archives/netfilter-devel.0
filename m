Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599CBC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Mar 2022 13:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbiCDNUq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Mar 2022 08:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233410AbiCDNUp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Mar 2022 08:20:45 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81EE4FC40
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Mar 2022 05:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=i7g/a+0EKBAYr6DmNi9+T/2BUnj8tPrR/VRdHlyyJRk=; b=dOAbM6OsfFe9P3wvO6e7HmrkX4
        bGdRjOuX+yhKtC8fniEzs+XceVlNEx/nOh4DR0DCHKFS0/8IaHs3lAsPe3VSl35S+Oxd+Q/xCGWvl
        HipnO+BEqauTgnGOD9/ziPkieAhuBIvdWA7kQeaEOVWnDhueSqgfQTooiQ8afljpIGLiFD1AbupQG
        lnSRFoqA994BRAWgF+Ck63GcJz750MTnMUG1z372tXIWa59c8fgSG8flK+6jV7/wDQ/nV2GMwgswo
        j5kZrsdybvukuQUwmlyIlrxxiHkcFntm9Iy33qgC9KXieFgWg2pbmaeL5OoYKjXNcdEeMn/JR8460
        yFy5LsUQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nQ7qe-0004Vz-4o; Fri, 04 Mar 2022 14:19:56 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables RFC 0/2] Speed up restoring huge rulesets
Date:   Fri,  4 Mar 2022 14:19:42 +0100
Message-Id: <20220304131944.30801-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Spinning further on my OpenShift sample ruleset with 50k chains and 130k
rules (of which 90k jump to a chain), I discovered old work in a local
branch which surprisingly worked and is contained in patch 1:

Cache target lookup results if they failed. This speeds up the logic to
determine whether the rule's target is a chain for consecutive rules
jumping to that same chain. The cache does not care about table names,
but that's fine: If a given chain name is not an extension, that holds
for all chains of the same name in all tables.

Patch 2 goes even further by populating that cache from declared chains
in the parsed dump file. This is potentially problematic because it
effectively disables the chain name and extension clash check (which
didn't exist in nft-variant and was a warning only in legacy), and it
does that for all tables. So in theory, one could create a chain named
LOG in nat table and expect to still be able to use LOG target in filter
table. With patch 2 applied, the restore will fail.

I still find the series feasible despite its problems: The performance
improvement is immense (see numbers in patches) and it breaks only
corner-cases which are likely unintended anyway.

Phil Sutter (2):
  libxtables: Implement notargets hash table
  libxtables: Boost rule target checks by announcing chain names

 include/xtables.h           |  3 ++
 iptables/iptables-restore.c |  1 +
 iptables/xtables-restore.c  |  1 +
 libxtables/xtables.c        | 84 +++++++++++++++++++++++++++++++++++++
 4 files changed, 89 insertions(+)

-- 
2.34.1

