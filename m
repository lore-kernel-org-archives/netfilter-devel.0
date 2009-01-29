From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 0/2] fix invalid packet logging for icmpv6 conntrack
Date: Thu, 29 Jan 2009 21:36:20 +0100
Message-ID: <1233261382-17030-1-git-send-email-eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:52083 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753887AbZA2UgZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:36:25 -0500
Received: from eric by ice-age with local (Exim 4.69)
	(envelope-from <eric@bayen.regit.org>)
	id 1LSdcc-0004Zm-Rp
	for netfilter-devel@vger.kernel.org; Thu, 29 Jan 2009 21:36:22 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

This small patchset fixes a small issue with a nf_log_packet() message which
was badly formatted and adds a message for invalid new icmpv6 packet.

Patchset statistic:
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

BR,
--
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
EdenWall: http://www.edenwall.com/
