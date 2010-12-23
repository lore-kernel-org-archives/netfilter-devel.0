From: Stephen Clark <sclark46@earthlink.net>
Subject: inconsistent address treatment.
Date: Thu, 23 Dec 2010 09:12:16 -0500
Message-ID: <4D1358C0.4060704@earthlink.net>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:60244 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751704Ab0LWOMR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Dec 2010 09:12:17 -0500
Received: from [69.22.83.66] (helo=joker.seclark.com)
	by elasmtp-scoter.atl.sa.earthlink.net with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.67)
	(envelope-from <sclark46@earthlink.net>)
	id 1PVltx-0004ld-ET
	for netfilter-devel@vger.kernel.org; Thu, 23 Dec 2010 09:12:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Why the inconsistency in the way addresses are treated. I can use -d 
2.2.2.2/32
  but not --to-source 205.201.149.214/32

iptables -t nat -A POSTROUTING -o eth1 -s 10.0.128.0/17 -d 2.2.2.2/32 -j 
SNAT --to-source 205.201.149.214/32


-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



