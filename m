From: Patrick McHardy <kaber@trash.net>
Subject: iptables-next merged
Date: Tue, 03 Aug 2010 17:26:32 +0200
Message-ID: <4C583528.9030301@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55483 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab0HCP0d (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:26:33 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by stinky.trash.net (Postfix) with ESMTP id 9C76FB2C5E
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Aug 2010 17:26:32 +0200 (MEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I've merged the iptables-next branch into master, which now
contains support for the new features scheduled for 2.6.36:

- the CHECKSUM target
- the IDLETIMER target
- the cpu match
- the ipvs match

as well as some documentation updates and cleanups.
