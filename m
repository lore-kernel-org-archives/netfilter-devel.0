From: Thomas Jacob <jacob@internet24.de>
Subject: Incorrect xt_iprange boundary check for IPv6 (Variant 2)
Date: Mon, 24 Jan 2011 13:13:46 +0100
Message-ID: <1295871227-2545-1-git-send-email-jacob@internet24.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout02.ims-firmen.de ([213.174.32.97]:59239 "EHLO
	mailout02.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab1AXMNu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jan 2011 07:13:50 -0500
Received: from [192.168.1.111] (helo=mailin02.ims-firmen.de)
	by mailout02.ims-firmen.de with esmtp (Exim 4.72)
	(envelope-from <jacob@internet24.de>)
	id 1PhLIq-0003p4-Vn
	for netfilter-devel@vger.kernel.org; Mon, 24 Jan 2011 13:13:49 +0100
Received: from [213.174.32.254] (helo=localhost.localdomain)
	by mailin02.ims-firmen.de with esmtpa (Exim 4.72)
	(envelope-from <jacob@internet24.de>)
	id 1PhLIq-0004no-TE
	for netfilter-devel@vger.kernel.org; Mon, 24 Jan 2011 13:13:48 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Removed ntohl from equality check in iprange_ipv6_lt
