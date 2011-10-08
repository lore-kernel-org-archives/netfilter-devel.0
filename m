From: Stephen Clark <sclark46@earthlink.net>
Subject: SNAT before IPSEC - why?
Date: Fri, 07 Oct 2011 22:08:04 -0400
Message-ID: <4E8FB084.6030807@earthlink.net>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:40527 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313Ab1JHCIG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Oct 2011 22:08:06 -0400
Received: from [69.22.83.66] (helo=joker.seclark.com)
	by elasmtp-dupuy.atl.sa.earthlink.net with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.67)
	(envelope-from <sclark46@earthlink.net>)
	id 1RCMKb-00006Z-3n
	for netfilter-devel@vger.kernel.org; Fri, 07 Oct 2011 22:08:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

What is the reasoning for having SNAT happen before ipsec encryption?

It forces one to add special rules in the NAT table to keep this from 
happening and
I can't think of one reason why you would want it to be this way.

Please someone enlighten me.

Thanks,
Steve

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



