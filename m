From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/3]: netfilter fixes
Date: Sun, 19 Aug 2012 22:16:07 +0200
Message-ID: <1345407370-30009-1-git-send-email-kaber@trash.net>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32828 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2HSUQN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Aug 2012 16:16:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo.

the following three patches contain some minor fixes and cleanups:

- fix for a NLA_PUT conversion bug
- endian annotation fixes
- removal of unnecessary RTNL locking

Please apply, thanks.
