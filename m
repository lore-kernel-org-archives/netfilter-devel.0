From: Stephen Clark <sclark46@earthlink.net>
Subject: ethernet filtering
Date: Sun, 24 Mar 2013 13:57:26 -0400
Message-ID: <514F3E86.9010809@earthlink.net>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:49058 "EHLO
	elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753558Ab3CXSFj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Mar 2013 14:05:39 -0400
Received: from [24.144.93.86] (helo=joker.seclark.com)
	by elasmtp-kukur.atl.sa.earthlink.net with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.67)
	(envelope-from <sclark46@earthlink.net>)
	id 1UJpAd-0007FW-Hv
	for netfilter-devel@vger.kernel.org; Sun, 24 Mar 2013 13:57:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Do I have to have a bridge setup to use ebtables or can filter on a regular 
interface?
I want to filter arp packets from a misconfigured router that is erroneously doing
proxy arp.

Thanks,
Steve

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



