From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/3] ctnetlink fixes
Date: Thu, 07 Aug 2008 12:07:48 +0200
Message-ID: <489AC974.60700@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53162 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751558AbYHGOZ1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Aug 2008 10:25:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

The following patches contain three important fixes for ctnetlink:

[PATCH] fix double helper assignation for NAT'ed conntracks
[PATCH] fix sleep in read-side lock section
[PATCH] fix sleepable allocation with spin lock bh

I think that they should go to -stable.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
