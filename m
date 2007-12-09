From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/5] ctnetlink updates
Date: Sun, 09 Dec 2007 19:12:53 +0100
Message-ID: <475C3025.3060307@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36762 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751160AbXLISNy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Dec 2007 13:13:54 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This patchset contains several updates for ctnetlink:

[PATCH 1/5] Add support for NAT sequence adjustments
[PATCH 2/5] Add support for SCTP
[PATCH 3/5] Add support for master tuple event notification and dumping
[PATCH 4/5] Set expected bit for related conntracks
[PATCH 5/5] Add support for secmark

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
