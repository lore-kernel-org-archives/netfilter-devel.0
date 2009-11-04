From: aidan mcgurn <a_mcgurn@yahoo.co.uk>
Subject: ipt ROUTE lib
Date: Wed, 4 Nov 2009 13:51:26 +0000 (GMT)
Message-ID: <747472.83765.qm@web24103.mail.ird.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from web24103.mail.ird.yahoo.com ([87.248.114.167]:38965 "HELO
	web24103.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755834AbZKDN6D convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:58:03 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

(sent this query to user list: not sure if its applicable here instead)
Hi,
I had looked through the archives and did again but i'm fairly new to netfilters iptables and i can't see
any other way of routing using dst:port via different gateways besides using the ipt ROUTE lib.

That been the case, can u please directme on how to build the ipt_ROUTE kernel object for this or is it a patch thats required?
As i said i downloaded 1.3.5 iptables code from netfilter and did a make but it only builds the shared objects, no kernel objects which
i presume i need to install a ipt_ROUTE.ko to get the -j ROUTE option to work?
alternatively is there any iptables package which includes this?


thanks for any help here,
/aidan






      
