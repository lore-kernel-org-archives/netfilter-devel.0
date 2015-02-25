From: Eric Leblond <eric@regit.org>
Subject: [nft PATCH 0/3] fix a delinearization issue
Date: Thu, 26 Feb 2015 00:51:07 +0100
Message-ID: <1424908270-554-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:42928 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115AbbBZATx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Feb 2015 19:19:53 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

This small patchset is fixing a ntables delinearization issue when
using counter. The rule triggering this is not straightforward as
it relays on statement order:
 ip protocol tcp counter packets tcp dport ssh accept
But it is possible some users are using this kind of rules so it
should be linearized and delinearized correctly.

With current code it was converted when reading rules from kernel
to:
 counter packets tcp dport ssh accept

BR,
--
Eric
