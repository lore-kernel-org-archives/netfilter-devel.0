From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH 0/2] conntrackd: Fix bogus characters in help
Date: Thu,  7 Apr 2016 10:21:42 +0200
Message-ID: <1460017304-21888-1-git-send-email-mart.frauenlob@chello.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at02-3.mx.upcmail.net ([62.179.121.150]:47600 "EHLO
	vie01a-dmta-at02-3.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751426AbcDGIWE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 04:22:04 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-pe01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1ao5CS-0007c6-1J
	for netfilter-devel@vger.kernel.org; Thu, 07 Apr 2016 10:22:00 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Good day!

The usage output as well as the man page of conntrackd
contain superflous separator characters.
The man page has two quoting errors.

Best regards,
Mart
