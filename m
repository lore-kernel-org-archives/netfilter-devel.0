From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/2] set: set parsing fixes
Date: Thu, 16 Jan 2014 20:16:24 +0000
Message-ID: <1389903386-20612-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58917 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaAPUQu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 15:16:50 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following two patches fix a couple of problems with printed set
outputs from "nft list table ..." and parsing the output again with
"nft -f".

- internal flags are printed
- flags are not parsable
- initializers (elements = { }) is not parsable

With these patches, parsing the output of "nft list table ..." works
in at least more cases than before when sets are present. We still
have ordering problems, verdict maps referencing chains will fail
since chains are created after the maps. The same problem exists
generally for jump rules.

Changes to last version: set data type and evaluate initializers.

These patches have been tested to work as described. I'll push them
to master now.
