From: Thomas Woerner <twoerner@redhat.com>
Subject: netfilter/iptables and network interface names
Date: Thu, 04 Feb 2010 13:58:15 +0100
Message-ID: <4B6AC467.7020209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756508Ab0BDM6S (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Feb 2010 07:58:18 -0500
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o14CwHAd006462
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Thu, 4 Feb 2010 07:58:18 -0500
Received: from neo.tm.hn.org (vpn1-5-192.ams2.redhat.com [10.36.5.192])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o14CwFHB027884
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Thu, 4 Feb 2010 07:58:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I just fell over network interface definitions in kernel and 
netfilter/iptables.

Interfaces names in the kernel have few limits: Only spaces and slashes 
are not allowed, but everything else, even Ctrl characters are.

In iptables, there are other limits: Colon, exclamation mark and 
asterisk are not allowed. The plus is treated special for matching. But 
what will be matched if the interface starts with or contains a plus?

iptables allows to use interfaces containing spaces and slashes. 
iptables-save is not escaping interface names. The interface "+" will be 
treated as no interface limit at all and will be dropped, therefore all 
interfaces match.

I think there should be some discussion about interface names and limits 
in kernel and netfilter/iptables.

What do you think?

Thanks in advance,
Thomas Woerner
