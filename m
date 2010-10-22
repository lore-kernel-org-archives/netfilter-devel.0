From: Stephen Clark <sclark46@earthlink.net>
Subject: clone packet with new destination address
Date: Fri, 22 Oct 2010 08:31:59 -0400
Message-ID: <4CC1843F.8050903@earthlink.net>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-masked.atl.sa.earthlink.net ([209.86.89.68]:36348 "EHLO
	elasmtp-masked.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755983Ab0JVMcB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Oct 2010 08:32:01 -0400
Received: from [69.22.83.66] (helo=joker.seclark.com)
	by elasmtp-masked.atl.sa.earthlink.net with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.67)
	(envelope-from <sclark46@earthlink.net>)
	id 1P9Gmu-0004CH-GR
	for netfilter-devel@vger.kernel.org; Fri, 22 Oct 2010 08:32:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Problem:
I have a two monitoring servers behind a a linux firewall, one is 
primary and one is backup.
In the field we have units sending udp informational packet to the 
primary server. On the
linux firewall I would like to copy this packet and change the 
destination address of the copied
packet to point to the backup server. Is there a way to do this without 
writing any code?

NOTE:
Currently the firewall is FreeBSD and we accomplish this rather easily using
ipfw along with natd, but we want to move to linux for our firewall.

Thanks for any ideas,
Steve

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



