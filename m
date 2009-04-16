From: Stephen Clark <sclark46@earthlink.net>
Subject: NAT and IPSEC
Date: Thu, 16 Apr 2009 09:00:25 -0400
Message-ID: <49E72BE9.6020007@earthlink.net>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:60470 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753133AbZDPNA1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Apr 2009 09:00:27 -0400
Received: from [208.118.36.249] (helo=joker.seclark.com)
	by elasmtp-dupuy.atl.sa.earthlink.net with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.67)
	(envelope-from <sclark46@earthlink.net>)
	id 1LuRCc-0006V1-IV
	for netfilter-devel@vger.kernel.org; Thu, 16 Apr 2009 09:00:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I have to separate ipsec tunnels going to two different private networks. How do 
I keep iptables from natting the traffic destined for these 2 networks. I tried:

iptables -t nat -A POSTROUTING -o eth1 -d ! 192.168.1.0/24  -d ! 172.16.0.0/16 
-j MASQUERADE

but it says only one -d is allowed. So I tried
iptables -t nat -A POSTROUTING -o eth1 -d ! ( 192.168.1.0/24 || 172.16.0.0/16 ) 
-j MASQUERADE

and it says "(" error. So how do I specify multiple destination 
networks/addresses to be excluded from being natted.

Thanks,
Steve

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)


