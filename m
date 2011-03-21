From: Patrick McHardy <kaber@trash.net>
Subject: iptables release plans
Date: Mon, 21 Mar 2011 19:48:54 +0100
Message-ID: <4D879D96.2000904@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34473 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab1CUStA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Mar 2011 14:49:00 -0400
Received: from x100e.localnet (localhost [127.0.0.1])
	by stinky.trash.net (Postfix) with ESMTP id 7652EB2C43
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Mar 2011 19:48:55 +0100 (MET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

About a potential iptables release for 2.6.38 - we don't have any
new features in the kernel that would require a new release.
However we've had a lot of other changes that would be good to
get out for wider testing.

Unfortunately due some confusion at the time of the last kernel
release, all patches for the upcoming feature in 2.6.39 have been
added to the master branch. I don't want to release extensions
for new kernel features while we're in the -rc phase since we
might still decide to change the userspace API.

So the options basically are:

- branch off the current HEAD, remove all new extension for upcoming
  features and release that branch

- skip the release for 2.6.38

Any opinions?
