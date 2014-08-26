From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf_tables PATCH v2 0/5] Series short description
Date: Tue, 26 Aug 2014 16:11:47 +0200
Message-ID: <20140826140908.3008.13225.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:48343 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758434AbaHZOMA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:12:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series implements some changes to the NFT_MSG_DELTABLE
API call.
The main change is the ability to flush the entire ruleset (also per AF).
We are no longer returning EBUSY.

This way, clients of the API can wipe the ruleset and add a new one in just
one transaction/batch.

In the first patches, there are a lot of code factorization and renaming.
The last patch is the change to NFT_MSG_DELTABLE itself.

Changes in this v2 are:
 * rebase on top of git.kernel.org/cgit/linux/kernel/git/pablo/nftables.git
 * address comments by Pablo. Now, support AF_UNSPEC and specified table.

Comments are welcome.
---

Arturo Borrero Gonzalez (5):
      netfilter: nf_tables: refactor rule deletion helper
      netfilter: nf_tables: add helper to unregister chain hooks
      netfilter: nf_tables: rename nf_table_delrule_by_chain()
      netfilter: nf_tables: add helpers to schedule objects deletion
      netfilter: nf_tables: extend NFT_MSG_DELTABLE to support flushing the ruleset


 net/netfilter/nf_tables_api.c |  454 +++++++++++++++++++++++++----------------
 1 file changed, 281 insertions(+), 173 deletions(-)

--
Arturo Borrero Gonzalez
