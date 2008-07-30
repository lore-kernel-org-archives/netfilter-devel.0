From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/7] ctnetlink updates
Date: Wed, 30 Jul 2008 13:02:56 +0200
Message-ID: <48904A60.2070308@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39064 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755291AbYG3LDQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:03:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

The following patchset includes several updates for ctnetlink. Its
purpose is to resolve the remaining issues so that we can unlabel it as
experimental in the near future. I'd like to release the first 1.0 of
the conntrack-tools by the end of the year and it would be great if we
can have this marked as a stable feature before doing so.

AFAIK, another remaining issues are the removal of the notifier call
chain and the NAT dependency. Could you point out the preferred way to
do this?

Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
