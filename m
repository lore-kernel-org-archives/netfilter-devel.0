From: Patrick McHardy <kaber@trash.net>
Subject: textsearch 08/13: fix Boyer-Moore text search bug
Date: Mon,  7 Jul 2008 14:05:26 +0200 (MEST)
Message-ID: <20080707120524.4975.39989.sendpatchset@localhost.localdomain>
References: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58388 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbYGGMF1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:05:27 -0400
In-Reply-To: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

textsearch: fix Boyer-Moore text search bug

The current logic has a bug which cannot find matching pattern, if the
pattern is matched from the first character of target string.
for example:
	pattern=abc, string=abcdefg
	pattern=a,   string=abcdefg
Searching algorithm should return 0 for those things.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ad089136c547ef33e2375e64dd13a0f09825d4d0
tree e1ab155181637bf1ad3d39232b9cc2f40094f286
parent 170f103d11a1e1186e2677fd5f75735b740c025f
author Joonwoo Park <joonwpark81@gmail.com> Mon, 07 Jul 2008 13:00:17 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 07 Jul 2008 13:00:17 +0200

 0 files changed, 0 insertions(+), 0 deletions(-)

