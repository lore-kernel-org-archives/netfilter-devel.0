From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 0/6] rework dependency removal (v2)
Date: Wed, 14 Feb 2018 16:22:23 +0100
Message-ID: <20180214152229.11830-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51620 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030682AbeBNPWj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 10:22:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 79B5E117732
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6AC21DA7E0
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9C352DA7E0
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:33 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 690BF41E4817
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:33 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This patchset aims to address what Florian reported time ago [1]. This
is skipping removal of protocol key payload expressions at network base
for the netdev, bridge and inet.

It would better to annotate all redundant expressions and add a later
stage, where we can do smarter simplifications by looking globally at
what we have, instead of just looking at current protocol key expression
and last one that we have annotated in the context structure to perform
removals. But I would prefer to have a fix now upstream then look at
this larger rework later on since it would require to review a bit of
the postprocess code.

The initial 4 patches in this batch are just cleanup/preparation patches
for patches 5/6 and 6/6.

There is still a few warning in the tests/py/ infrastructure, some of
them I think need to be fixed, and at least one can remain there to
remind us that we can do better.

Let me know if you have any concern with this.

Thanks.

[1] https://www.spinics.net/lists/netfilter-devel/msg50078.html

Pablo Neira Ayuso (6):
  src: pass family to payload_dependency_kill()
  payload: add payload_dependency_release() helper function
  src: add payload_dependency_exists()
  src: get rid of __payload_dependency_kill()
  payload: add payload_may_dependency_kill()
  netlink_delinearize: add meta_may_dependency_kill()

 include/payload.h         |   7 +--
 src/netlink.c             |   2 +-
 src/netlink_delinearize.c | 106 +++++++++++++++++++++++++++++++++++++++++-----
 src/payload.c             |  85 ++++++++++++++++++++++++++++---------
 4 files changed, 165 insertions(+), 35 deletions(-)

-- 
2.11.0

