From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [RELEASE] arptables v0.0.3-4
Date: Mon, 08 Mar 2010 17:38:27 +0100
Message-ID: <4B952803.1030406@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Nishit Shah <nsshah.82@gmail.com>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:46459 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab0CHQi3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Mar 2010 11:38:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I just released an updated version of arptables which incorporates this
important fix:

Update the userspace arptables tool to kernels 2.6.16 and above. A
change in the kernel API broke compatibility with the arptables tool
around release 2.6.16, causing the filtering to behave unexpectedly.
Reported and fixed by Nishit Shah.
See http://ebtables.sourceforge.net/downloads/latest.html

cheers,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be

