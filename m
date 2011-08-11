From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [RELEASE] ebtables v2.0.10-2
Date: Thu, 11 Aug 2011 21:28:08 +0200
Message-ID: <4E442D48.70602@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:45589 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab1HKT2L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:28:11 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I released a small update of ebtables, changes:

* use sanitized kernel headers
* enable compiler optimizations (-O3)
* small changes to remove the compiler warnings due to optimization 
being turned on (thanks to Peter Volkov)
* respect LDFLAGS in Makefiles (Peter Volkov)

Have fun,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be
