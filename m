From: Ismo Puustinen <ismo.puustinen@intel.com>
Subject: [PATCH nft 0/1] Proposal: include directories for rulesets
Date: Wed,  2 Mar 2016 14:11:29 +0200
Message-ID: <1456920690-14477-1-git-send-email-ismo.puustinen@intel.com>
Cc: Ismo Puustinen <ismo.puustinen@intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:12087 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484AbcCBMLw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 07:11:52 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A nice-to-have feature in nft would be the ability to use include
directories that contain rule files. The use case would be support for
services dropping their custom configuration files into a directory,
allowing a more modular firewall configuration.

This is a proof-of-concept patch -- I'm not very familiar with nftables
code base and conventions.

Ismo Puustinen (1):
  scanner: add support for include directories

 src/main.c    |  4 ++--
 src/scanner.l | 73 +++++++++++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 61 insertions(+), 16 deletions(-)

-- 
2.5.0

