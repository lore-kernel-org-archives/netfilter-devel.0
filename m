From: Thomas Jacob <jacob@internet24.de>
Subject: Incorrect xt_iprange boundary check for IPv6 (Variant 3)
Date: Mon, 24 Jan 2011 15:00:19 +0100
Message-ID: <1295877620-2399-1-git-send-email-jacob@internet24.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout02.ims-firmen.de ([213.174.32.97]:44046 "EHLO
	mailout02.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab1AXOAZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jan 2011 09:00:25 -0500
Received: from [192.168.1.112] (helo=mailin03.ims-firmen.de)
	by mailout02.ims-firmen.de with esmtp (Exim 4.72)
	(envelope-from <jacob@internet24.de>)
	id 1PhMxz-0002r9-NH
	for netfilter-devel@vger.kernel.org; Mon, 24 Jan 2011 15:00:23 +0100
Received: from [213.174.32.254] (helo=localhost.localdomain)
	by mailin03.ims-firmen.de with esmtpa (Exim 4.72)
	(envelope-from <jacob@internet24.de>)
	id 1PhMxz-000255-Jy
	for netfilter-devel@vger.kernel.org; Mon, 24 Jan 2011 15:00:23 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This variant should safe some comparisions but could possibly
worse from a L1 caching point of view
