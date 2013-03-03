From: Eric Leblond <eric@regit.org>
Subject: [ulogd patch 0/1] use conntrack based timestamp
Date: Sun,  3 Mar 2013 23:10:57 +0100
Message-ID: <1362348658-19291-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:43621 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab3CCWLl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Mar 2013 17:11:41 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

This patch is using the connection tracking provided timestamp as
time source when it is available. This fixes some cases where ulogd
was not able to get the timestamp.
I was initially thinking to add a configuration option to avoid the
check of the connection tracking attribute but I don't think the
load induced by the check is too costly.

BR,
