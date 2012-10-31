From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nf-next/nf_tables-experiments - PATCH 0/2] chain rename and rule replacement
Date: Wed, 31 Oct 2012 11:28:27 +0200
Message-ID: <1351675709-14127-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:7772 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480Ab2JaJ2d (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:28:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Here is two patches, there title is self-explaining.

Renaming chain's name applies only on user's chain. Not on builtin or base ones.

Please review,

Tomasz Bursztyka (2):
  nf_tables: Add support for changing users chain's name
  nf_tables: Add support for replacing a rule by another one.

 include/linux/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c       | 82 ++++++++++++++++++++++++++++++++++---
 2 files changed, 77 insertions(+), 6 deletions(-)

-- 
1.7.12.4

