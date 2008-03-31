From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 0/4]
Date: Tue,  1 Apr 2008 01:09:46 +0200
Message-ID: <1207004990315-git-send-email-eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:41720 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751036AbYCaXJv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Mar 2008 19:09:51 -0400
Received: from eric by localhost with local (Exim 4.67)
	(envelope-from <eric@bayen.regit.org>)
	id 1JgT8Q-00035b-2Y
	for netfilter-devel@vger.kernel.org; Tue, 01 Apr 2008 01:09:50 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

This patchset features some SQL improvement, a partial rewrite of NACCT output
plugin and an sync of ulogd.conf.in with current state of the code.

First two patches are SQL related. They simply synchronise  MySQL code with
current NFCT code:
 * Fix SQL field naming.
 * Convert SQL procedure to function in MySQL plugins.

Third patch is
 * IPv6 compliance of NACCT output plugin.
NACCT code was heavily dependant of the order of keys provided by input
plugins. As change in other parts of the code is quiet important, NACCT 
should'nt have been in a working state. I've rewritten it using current
coding style and added IPv6 support.

Last patch is a sync of example configuration file with current ulogd
capabilities:
 * Add some example to ulogd.conf.in.

BR,
--
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
