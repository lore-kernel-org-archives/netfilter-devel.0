From: Peter Gordon <peter@pg-consultants.com>
Subject: arptables - bulk/fast insert
Date: Tue, 06 Apr 2010 15:39:13 +0300
Message-ID: <1270557553.2712.24.camel@qed>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gold.securenet-server.net ([207.45.186.66]:58778 "EHLO
	gold.securenet-server.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab0DFMjV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Apr 2010 08:39:21 -0400
Received: from [212.143.139.191] (helo=[10.1.20.106])
	by gold.securenet-server.net with esmtpa (Exim 4.69)
	(envelope-from <peter@pg-consultants.com>)
	id 1Nz83r-0000e4-RQ
	for netfilter-devel@vger.kernel.org; Tue, 06 Apr 2010 08:39:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Is there a fast way to add rules to arptables, like ebtables-restore or
iptables-restore?

arptables-restore is a perl script which runs arptables for each insert,
so
a) it is not atomic
b) it is slow

Peter

