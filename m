Return-Path: <SRS0=FCuH=V3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0211C433FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 14:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C355F20659
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 14:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730724AbfG3OQ3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 10:16:29 -0400
Received: from correo.us.es ([193.147.175.20]:53092 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727338AbfG3OQ3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 10:16:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7A4A411ED85
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 16:16:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C3231150B9
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 16:16:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 60B83FF6CC; Tue, 30 Jul 2019 16:16:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 99CA0DA4D1;
        Tue, 30 Jul 2019 16:16:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 30 Jul 2019 16:16:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.32.83])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0B4334265A32;
        Tue, 30 Jul 2019 16:16:23 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, bmastbergen@untangle.com
Subject: [PATCH nft,RFC,PoC 0/2] typeof support for set / map
Date:   Tue, 30 Jul 2019 16:16:15 +0200
Message-Id: <20190730141620.2129-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

One topic that keeps coming back and forth is support for using integers
from the set / map definitions, see:

https://patchwork.ozlabs.org/patch/1089728/

The following example shows how PoC/RFC patchset works:

# cat test.nft
table filter {
            set blacklist {
                    typeof ip saddr
            }

            chain input {
                    ip saddr @blacklist counter drop
            }
    }
# nft -f test.nft
# nft list ruleset
table ip filter {
        set blacklist {
                typeof ip saddr
        }

        chain input {
                ip saddr @blacklist counter packets 0 bytes 0 drop
        }
}

This patchset provides a proof-of-concept, it's a quick hack, I dislike
to deliver things in a raw shape like this, but anyway...

Support for concatenations and object maps are missing. The
representation of the expression into the TLV still needs to be defined
(it could be a structure whose first field specifies the expression
type and an union with the specific fields for this expression,
encapsulated in the TLV).

Pablo Neira Ayuso (2):
  parser: add typeof keyword for declarations
  src: restore typeof datatype when listing set definition

 include/rule.h     |  3 +++
 src/mnl.c          | 27 +++++++++++++++++++++++++++
 src/netlink.c      |  9 ++++++++-
 src/parser_bison.y | 20 ++++++++++++++++++++
 src/rule.c         |  9 +++++++--
 src/scanner.l      |  1 +
 6 files changed, 66 insertions(+), 3 deletions(-)

-- 
2.11.0

