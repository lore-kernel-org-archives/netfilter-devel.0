From: "Partha Majumdar" <pmajumdar.kernel@gmail.com>
Subject: Changing IP destination in NF_IP_PRE_ROUTING hook
Date: Fri, 12 Sep 2008 16:58:33 +0530
Message-ID: <f4a980250809120428l14a26a31j1a08725404470fc4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.233]:17035 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbYILL2f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Sep 2008 07:28:35 -0400
Received: by qb-out-0506.google.com with SMTP id f11so1602604qba.17
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Sep 2008 04:28:34 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am not very familiar with Linux kernel internals. I am trying to
write a simple netfilter hook but facing some issues and did not find
any clear answer in available docs on packet filter or netfilter
hacking.

I am writing an experimental kernel module that will register a
NF_IP_PRE_ROUTING hook. This hook will change the destination address
of the IP header. After that I'll update the checksum of the IP header
by calling ip_nat_cheat_check as it is done in manip_pkt. Do I need to
update the TCP checksum as well (if it is a TCP packet) since the
pseudo header of the packet has changed? If I need to do update the
tcp checksum as well then why isn't it being done  mainp_pkt after
changing the source or destination IP address?

I also want to do similar modification for IPv6 packets. For IPv4 I
have seen that skb_ip_make_writable is being called before modifying
the IPv4 headers. I did not find anything similar for IPv6. What is
the logic I should follow for IPv6?

Regards,
Partha
