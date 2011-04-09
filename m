From: Lennert Buytenhek <buytenh@wantstofly.org>
Subject: ipset issues in 2.6.39-rc2
Date: Sat, 9 Apr 2011 17:16:55 +0200
Message-ID: <20110409151655.GA22881@wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:64000 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab1DIPON (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Apr 2011 11:14:13 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On the current Fedora Rawhide kernel (2.6.39-0.rc2.git0.0.fc16), I am
seeing the following two issues:

1. Attempting to create a -j SET rule with a certain invalid set of
   flags leaks a reference to the specified pool:

	# ipset create foo hash:ip
	# ipset list foo | grep References
	References: 0
	# iptables -A INPUT -j SET --del-set foo src,src,src,src,src,src
	iptables: Numerical result out of range.
	# ipset list foo | grep References
	References: 1
	#

2. --del-set doesn't seem to work (or I don't understand how it's supposed
   to work):

	# ipset create bar hash:ip
	# ipset add bar 127.0.0.1
	# iptables -I INPUT -s 127.0.0.1 -p icmp -j SET --del-set bar src
	# ping -c 1 127.0.0.1
	[...]
	# iptables -L INPUT -v | grep SET
	    2   168 SET        icmp --  *      *       127.0.0.1            0.0.0.0/0           del-set bar src,dst,dst,dst,dst,dst 
	# ipset list bar
	[...]
	Members:
	127.0.0.1
	#


thanks,
Lennert
