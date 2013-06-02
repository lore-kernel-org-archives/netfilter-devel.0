From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 0/5] misc fixes
Date: Sun,  2 Jun 2013 12:38:27 +0200
Message-ID: <1370169512-23500-1-git-send-email-eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:36287 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3FBKiq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Jun 2013 06:38:46 -0400
Received: from bayen.regit.org ([81.57.69.189] helo=ice-age.regit.org)
	by ks28632.kimsufi.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <eric@regit.org>)
	id 1Uj5gS-0001an-MD
	for netfilter-devel@vger.kernel.org; Sun, 02 Jun 2013 12:38:45 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

Here's a small patchset for nftables. It contains miscellaneous fixes
and improvements. I'm not sure for patch 2 ("expression") because it
may not be the best way to fix the crash. Patch 3 can also be discussed
because it suppress something that was done before in the code.

BR,
--
Eric
