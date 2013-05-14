From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH 0/6] Fixes and features
Date: Tue, 14 May 2013 13:52:01 +0300
Message-ID: <1368528727-10127-1-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <519216B6.7060701@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46611 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020Ab3ENKwO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 May 2013 06:52:14 -0400
In-Reply-To: <519216B6.7060701@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Small fixes here and there in patch 1, 2 and 3 

patch 4, 5, and 6 propose a way to translate iptables matches/targets blob (when needed) into
nftables expressions list. (thus it requires the expression list functions in libnftables) 

Tomasz Bursztyka (6):
  xtables: initialize xtables defaults even on listing rules
  xtables: destroy list iterator relevantly
  xtables: policy can be changed only on builtin chain
  xtables: Add support for translating xtables target into nft expressions
  xtables: add support for translating xtables matches into nft
    expressions
  xtables: add suport for DNAT rule translation to nft extensions

 configure.ac              |   7 +++
 extensions/GNUmakefile.in |   2 +-
 extensions/libipt_DNAT.c  | 135 ++++++++++++++++++++++++++++++++++++++++++----
 include/xtables.h.in      |   8 +++
 iptables/nft.c            |  71 +++++++++++++++---------
 5 files changed, 186 insertions(+), 37 deletions(-)

-- 
1.8.2.1

