From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 0/3] Protocol auto detection, bugfixes and doc
Date: Thu,  7 Feb 2008 09:22:18 +0100
Message-ID: <12023725412-git-send-email-eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43538 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754371AbYBGIWW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Feb 2008 03:22:22 -0500
Received: from eric by localhost with local (Exim 4.67)
	(envelope-from <eric@bayen.regit.org>)
	id 1JN21V-0003Rc-7g
	for netfilter-devel@vger.kernel.org; Thu, 07 Feb 2008 09:22:21 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

First patch is the most significative. It modify the behaviour of ulogd for
packet based logging. Before the patch, it was necessary to define the type
of IP protocol that will be used in an NFLOG input. A side effect was that
it was impossible to log in a single netlink group for IPv4 and IPv6. This
patch let the BASE filter do this job of finding the protocol.

This patchset also contains two small fixes and/or improvements:
 * A fix of ulogd info option
 * A review of default config file which has been modified to follow the
 latest modifications
