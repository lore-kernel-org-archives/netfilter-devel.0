From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables/libnfables PATCHES] Target translation to nftables
Date: Tue, 14 May 2013 13:49:26 +0300
Message-ID: <519216B6.7060701@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56945 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab3ENKt2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 May 2013 06:49:28 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

You will find 2 sets of patches, one for libnftables and one 
foriptables-nftables.

Among some fixes, one feature has been added: DNAT support in 
iptables-nftables.

Iimplemented quickly only this one to show how to translate targets blob 
into nftables expression. Other ones can be easily implemented as well.
But whenit iseasy in that way, it will be a bit trickier in the other way.

Actually, I have not found a proper solution to output the rule in 
iptables format from the expression list. Nothing clean.
If someone has anice idea...


The 2 sets will follow this mail.

Br,

Tomasz
