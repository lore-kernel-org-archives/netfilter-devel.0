From: "Balaji Venkatamohan" <bvenkat@ncsu.edu>
Subject: Doubts in netfilter limit match
Date: Tue, 13 Oct 2009 13:17:26 -0400 (EDT)
Message-ID: <52072.152.14.243.6.1255454246.squirrel@webmail.ncsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from uni12mr.unity.ncsu.edu ([152.1.1.171]:40663 "EHLO
	uni12mr.unity.ncsu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760405AbZJMRSP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Oct 2009 13:18:15 -0400
Received: from uni21wi.unity.ncsu.edu (uni21wi.unity.ncsu.edu [152.1.227.221])
	by uni12mr.unity.ncsu.edu (8.13.7/8.13.8/Nv5.2008.0610.1) with ESMTP id n9DHHRJ7008668
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Oct 2009 13:17:28 -0400 (EDT)
Received: from uni21wi.unity.ncsu.edu (localhost.localdomain [127.0.0.1])
	by uni21wi.unity.ncsu.edu (8.13.8/8.13.8) with ESMTP id n9DHHRSF014088
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Oct 2009 13:17:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I want to know how the limit match works. When we are trying to restrict
the number of packets sent by a particular IP to, say, 3 / hour, we use a
iptable rule like

	iptables -A INPUT -s 127.0.0.1 -m limit --limit-burst 5

I want to know how and where the count is stored. Are they checked for
previous entries using netfilter log? Also, Can you please tell me the .c
file in the netfilter source code which deals with handling various match
and target extensions. If you can send me a link to any tutorial that
deals with linux network programming then that will be great.

Thanks and Regards,
Balaji
