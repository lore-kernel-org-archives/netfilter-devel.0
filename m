From: Eric Leblond <eric@regit.org>
Subject: [PATCH for 3.13 0/1] nft: reject: fix endianess
Date: Thu, 12 Dec 2013 08:51:58 +0100
Message-ID: <1386834719-29204-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:56357 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3LLHwP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:52:15 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

Here's a small fix for 3.13. I'm not sure it is necessary but
getting it in 3.13 will avoid us some possible backward
compatibility issues later.

BR,
--
Eric
