From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [0/2] netfilter: ctnetlink fixes for 2.6.29-rc
Date: Tue, 27 Jan 2009 22:14:51 +0100
Message-ID: <497F794B.3080302@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45327 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752577AbZA0VPB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:15:01 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

The following patches contains to ctnetlink fixes for 2.6.29-rc:

[1/2] netfilter: ctnetlink: allow changing NAT sequence adjustment in
creation
[2/2] netfilter: ctnetlink: fix echo if not subscribed to any multicast
group

The first patch fixes an inconsistency in the ctnetlink code, as the NAT
sequence adjustment bits may also be mangled in the creation path. The
second fixes netlink echoing if the socket is not subscribed to any
multicast group since currently the socket does not receive anything
back if NLM_F_ECHO is set.

Please, could you pass them to davem?
Thanks!

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
