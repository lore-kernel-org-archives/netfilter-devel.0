From: =?utf-8?q?T=C3=B3th=20L=C3=A1szl=C3=B3=20Attila?=
	<panther@balabit.hu>
Subject: [PATCH 0/2] Addrtype match limit to a specific interface. Patches
Date: Fri, 5 Oct 2007 17:20:33 +0200
Message-ID: <addrtype-20071005-1725.1191598313.git.panther@balabit.hu>
To: undisclosed-recipients:;
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:60188 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763379AbXJEQDl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Oct 2007 12:03:41 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id C066DC123D
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Oct 2007 18:03:39 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The address type check can be limited to the interface the packets belongs to
and it matches only if the incoming interface (of the packet) has the same
IP address as the packet's source or destination address depending on the
source or destionation type settings.
