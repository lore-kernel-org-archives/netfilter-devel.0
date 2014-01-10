From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/4] nftables: bug fixes and minor cleanups
Date: Fri, 10 Jan 2014 09:31:30 +0000
Message-ID: <1389346294-7242-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57686 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbaAJJcZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 04:32:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following four patches fix error reporting for errors starting
at column 0, fix a crash for unresolvable mark values, revert the
incorrect integer_type parsing patch and reduce the size of the
"could not process rule in batch" message to avoid having it spill
over on the next line.

If there are no objections, I'll push them to master in a few hours.
