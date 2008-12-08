From: Thomas Jacob <jacob@internet24.de>
Subject: ulogd2 doesn't decode IPv6 L4 protos
Date: Mon,  8 Dec 2008 19:27:05 +0100
Message-ID: <1228760826-12886-1-git-send-email-jacob@internet24.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout02.ims-firmen.de ([213.174.32.97]:48082 "EHLO
	mailout02.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbYLHSsV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Dec 2008 13:48:21 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


ip6_ext_hdr returns ULOGD_IRET_* codes instead of a boolean value
which prevents IPv6 layer 4 protocols from being decoded in the
raw2packet filter.
