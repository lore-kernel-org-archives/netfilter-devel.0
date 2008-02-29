From: "Nishit Shah" <nishit@elitecore.com>
Subject: RE: Does Redirect/NAT change the destination port of reverse tuple ?
Date: Fri, 29 Feb 2008 18:04:13 +0530
Message-ID: <006701c87acf$63edd8d0$2bc98a70$@com>
References: <005101c87ac0$c0d34580$4279d080$@com> <47C7F1F7.9030406@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "'Pascal Hambourg'" <pascal.mail@plouf.fr.eu.org>,
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhost.elitecore.com ([203.88.135.194]:53317 "EHLO
	elitecore.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757579AbYB2MeI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Feb 2008 07:34:08 -0500
Received: from unknown (HELO elitecore3) ([203.88.135.197])
          (envelope-sender <nishit@elitecore.com>)
          by elitecore.com (qmail-ldap-1.03) with SMTP
          for <netfilter-devel@vger.kernel.org>; 29 Feb 2008 12:13:20 -0000
In-Reply-To: <47C7F1F7.9030406@plouf.fr.eu.org>
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



-----Original Message-----
From: netfilter-devel-owner@vger.kernel.org
[mailto:netfilter-devel-owner@vger.kernel.org] On Behalf Of Pascal Hambourg
Sent: Friday, February 29, 2008 5:22 PM
To: netfilter-devel@vger.kernel.org
Subject: Re: Does Redirect/NAT change the destination port of reverse tuple
?

> 	[NEW] tcp 6 120 NONE src=192.168.206.200 dst=72.14.223.83
> sport=63423 dport=443 packets=1 bytes=48 [UNREPLIED] src=192.168.121.125
> dst=192.168.206.200 sport=3128 dport=46873 packets=0 bytes=0 id=28187887
> 
> Now here original and reverse tuples are --> 
> 	Original tuple 192.168.206.200:63423->72.14.223.83:443
> 	Reply tuple    192.168.121.125:3128->192.168.206.200:46873
> 
> So, here destination port of reverse tuple is 46873. Is it correct ?

Yes. NAT may implicitly change the original source port in order to 
avoid a clash with an existing connection. However the original port 
will be restored in reply packets before they leave the box, so the 
client won't see anything. Remember that the tuples in ip_conntrack 
contain the addresses and ports when packets enter the PREROUTING or 
OUTPUT chains, not when they leave the POSTROUTING or INPUT chains.

Hmm... So if I need original source IP and port in proxy (like
SO_ORIGINAL_DST, something SO_ORIGINAL_SRC) I should trust conntrack not the
socket info, correct ?



--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel"
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

