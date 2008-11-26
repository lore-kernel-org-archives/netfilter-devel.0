From: Bryan Duff <bduff@astrocorp.com>
Subject: Building the conntrack rule from scratch
Date: Wed, 26 Nov 2008 15:45:07 -0600
Message-ID: <492DC363.3040304@astrocorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.astrocorp.com ([75.160.64.129]:21556 "EHLO
	mail.astrocorp.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752028AbYKZWR0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Nov 2008 17:17:26 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.astrocorp.com (Postfix) with ESMTP id BB0E0630FD
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Nov 2008 15:44:35 -0600 (CST)
Received: from mail.astrocorp.com ([127.0.0.1])
	by localhost (mail.astrocorp.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XMIXY-EWmPOr for <netfilter-devel@vger.kernel.org>;
	Wed, 26 Nov 2008 15:44:34 -0600 (CST)
Received: from Win2003.astrocorp.com (unknown [192.168.1.146])
	by mail.astrocorp.com (Postfix) with ESMTP id 75FB0630F9
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Nov 2008 15:44:34 -0600 (CST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If I build a conntrack rule (before any traffic actually traverses), and 
then send traffic through, the conntrack rule gets used, but no SNAT 
takes place.  It sends the packet outbound with a source IP on the LAN 
instead of using the reply-dst and SNAT'ing to the WAN side.

How do I get it to SNAT the packet?  In this way I'm circumventing 
iptables (why use it when you already have all the information anyway) - 
so nat POSTROUTING is never actually touched by the first outbound 
packet - it's picked up by the conntrack rule.

Tell me if I'm missing something, or if more information is needed.

-Bryan
