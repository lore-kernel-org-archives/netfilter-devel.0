From: Eric Leblond <eric@regit.org>
Subject: [RFC ulogd patch 0/1] Implement conntrack event filter in NFCT input
Date: Wed,  1 Aug 2012 23:33:28 +0200
Message-ID: <1343856809-11585-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:49562 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab2HAVec (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Aug 2012 17:34:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

This patch implements filtering for NFCT input plugin. It adds
two configuration variables src_filter and dst_filter which
can be used to select the IPv4 or IPv6 network to filter on
for the source or destination address.

For IPv4 this is working fine but despite the latest update
from Pablo on libnetfilter_conntrack, I still don't manage
to get IPv6 working. Any help appreciated on this.

This explains the RFC status of this patch. The other reason is
that I want to ensure that the proposed filtering is convenient
for the users.

BR,
--
Eric
