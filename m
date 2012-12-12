From: kaber@trash.net
Subject: [PATCH 00/11] netfilter: nf_tables: small cleanups and netlink fixes
Date: Wed, 12 Dec 2012 19:47:30 +0100
Message-ID: <1355338061-5517-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63167 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab2LLSrv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:47:51 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches clean up a few minor things and fix a couple of netlink
issues:

- rename of pid to portid for consistency
- revert patch to include use attribute only sent by the kernel in nla_policy 
- move the hgenerator to the table to save a bit memory
- move the chain policy to basechains
- send netlink notifications for basechain policy changes
- introduce a chain handle and fix chain renames
- fix an invalid event type for rule GET operations
- remove ability to specify handles for new rules
- return an error for unsupported rule change requests
- return an error for rule replacement requests without a rule
- include NLM_F_APPEND/NLM_F_REPLACE in NEWRULE messages

Please apply, thanks.
