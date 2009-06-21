From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [RELEASE] ebtables v2.0.9-1
Date: Sun, 21 Jun 2009 18:11:47 +0200
Message-ID: <4A3E5BC3.5030104@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:57159 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbZFUQLw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Jun 2009 12:11:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

We just released a new version of ebtables, see 
http://ebtables.sourceforge.net/download.html

Changes:
- added ip6 module for filtering IPv6 traffic (Kuo-Lang Tseng, Manohar 
Castelino)
- added --log-ip6 option for logging IPv6 traffic (Kuo-Lang Tseng, 
Manohar Castelino)
- added nflog watcher for logging packets to userspace (Peter Warasin)
- bugfix in ebtables.sysv (Michal Soltys)
- bugfix for among match on x86-64 (reported by Pavel Emelyanov)

cheers,
Bart

