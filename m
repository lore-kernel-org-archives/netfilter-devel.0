From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/2] netfilter: nf_tables: set selection
Date: Fri, 28 Mar 2014 10:19:46 +0000
Message-ID: <1396001988-32338-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54086 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaC1KTy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:19:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These patches implement the basic set selection mechanism based on data
characteristics provided by userspace. So far we only need to know the
maximum number of elements.

Instead of trying to anticipate the information future set types will
need, the plan is to add more as we require it under the assumption
that we will converge to a state where a new set type already has
all information required available. The expectation is that most set
types will require the same information for estimation since they
most likely will be some type of tree or trie.

Please apply.

