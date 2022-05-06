Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92EDFC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 May 2022 11:41:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391449AbiEFLpT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 May 2022 07:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391443AbiEFLpS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 May 2022 07:45:18 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6751560D88
        for <netfilter-devel@vger.kernel.org>; Fri,  6 May 2022 04:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=x3GnwGsRUTIrikXgCWGKAInp6G/o2KMfTQPe8EFS7zg=; b=oQxTCq6Q7vWSqcoDvkCQ/pwv53
        q6wHKXLe/iDkzYCfbDsJlnJnHvO402Skh92kakmfkFEG8ynPeNaZZkY94Bz7gH+qCPmsMn/jd2HB1
        wsAdaiFMBh5LOX2NEPemSkCMcQaZ5cLl+/mbcJ8SGX/QE0j8v50qky8mdQI6RKonPxCaWhaB9r5Dk
        Ru9re5ICBiJ/lJ2qyr/zze0lm/3hXBfKK0tRTFEKFixMIrPA9B09kz3SZI6NM8Ko+b5PvxXasXImz
        uK3xQSkxxuzGpxLq3xQx4CBZKGBE4LrJI0EDW1IbrVPPMEZxJ6xADR5rNfhPDqdqvCixUvysVenqB
        Q+ivPI8w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nmwL0-0005qz-Qn; Fri, 06 May 2022 13:41:34 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/5] Restore libxtables ABI compatibility
Date:   Fri,  6 May 2022 13:40:59 +0200
Message-Id: <20220506114104.7344-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

First three patches eliminate the 'print_help' callback added to
struct xtables_globals by making xtables_printhelp() do the right thing
for arptables as well. Due to the shared parser there are only a few
distinct options left anyway. While doing so, help output is aligned
with legacy arptables which prints all extensions' help texts even if
not requested for.

Patch four changes how the different optstrings are passed to the shared
parser. Via central storage in xshared.h and a helper function which
maps from afinfo->family value, struct xtables_global's 'optstring'
field may be dropped again.

The last patch just undoes the "fix" to struct xtables_pprot. It is not
a problem which may occur during run-time and the compiler complains if
code changes would trigger the bug.

Phil Sutter (5):
  extensions: MARK: Drop extra newline at end of help
  xshared: Move arp_opcodes into shared space
  xshared: Extend xtables_printhelp() for arptables
  libxtables: Drop xtables_globals 'optstring' field
  libxtables: Revert change to struct xtables_pprot

 extensions/libarpt_mangle.c |   1 -
 extensions/libxt_MARK.c     |   3 +-
 include/xtables.h           |   4 +-
 iptables/ip6tables.c        |   2 -
 iptables/iptables.c         |   2 -
 iptables/nft-arp.c          |  22 ++------
 iptables/nft-arp.h          |   7 ---
 iptables/xshared.c          |  84 ++++++++++++++++++++++++----
 iptables/xshared.h          |   7 ++-
 iptables/xtables-arp.c      | 106 ------------------------------------
 iptables/xtables-eb.c       |   3 +-
 iptables/xtables-monitor.c  |   1 -
 iptables/xtables.c          |   3 -
 13 files changed, 86 insertions(+), 159 deletions(-)
 delete mode 100644 iptables/nft-arp.h

-- 
2.34.1

