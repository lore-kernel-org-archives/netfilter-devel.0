From: Thomas Woerner <twoerner@redhat.com>
Subject: MARK extension
Date: Mon, 08 Mar 2010 17:08:47 +0100
Message-ID: <4B95210F.5020305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363Ab0CHQIw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Mar 2010 11:08:52 -0500
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o28G8oTb018344
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Mon, 8 Mar 2010 11:08:50 -0500
Received: from natal.str.redhat.com (natal.str.redhat.com [10.32.5.36])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o28G8m2t002744
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Mon, 8 Mar 2010 11:08:49 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

according to the man page MARK "can only be used in the mangle table". 
But this is not correct. It is possible to use it also in the nat table.

Is this a documentation problem?

Working example:

*nat
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
-A PREROUTING -i eth+ -p tcp --dport 4711 -j MARK --set-mark 0x65
-A PREROUTING -i eth+ -p tcp --dport 4711 -m mark --mark 0x65 -j DNAT 
--to-destination :80
COMMIT

*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -i eth+ -m state --state NEW -m tcp -p tcp --dport 80 -m mark 
--mark 0x65 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT

Thanks,
Thomas

-- 
Thomas Woerner
Software Engineer            Phone: +49-711-96437-310
Red Hat GmbH                 Fax  : +49-711-96437-111
Hauptstaetterstr. 58         Email: Thomas Woerner <twoerner@redhat.com>
D-70178 Stuttgart            Web  : http://www.redhat.de/
