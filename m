From: Shannon Wynter <freman@fremnet.net>
Subject: ipset suggestion, idle-timeout
Date: Mon, 21 Apr 2014 14:50:04 +1000
Message-ID: <5354A37C.8080308@fremnet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:15343 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744AbaDUEuI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:50:08 -0400
Received: from priya.2y.net (localhost [127.0.0.1])
	by priya.2y.net (Postfix) with ESMTP id A5D5D18611BE
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Apr 2014 14:50:04 +1000 (EST)
Received: from [192.168.0.28] (unknown [192.168.0.28]) (using TLSv1 with
 cipher ECDHE-RSA-AES128-SHA (128/128 bits)) (No client certificate requested)
 (Authenticated sender: freman:3cff8c5961fe222bf027c2ae4d713d3ab6acc1cd by
 priya.2y.net (Postfix) with ESMTPSA id 8371918611BD for
 <netfilter-devel@vger.kernel.org>; Mon, 21 Apr 2014 14:50:04 +1000 (EST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Greetings,

I would love to have an "idle timeout" for ipset

It would essentially work like the regular timeout, removing the entry 
from the set but only if no matches on the entry for the duration of the 
timeout

eg:
Add a match for 8.8.8.8 for 300 seconds.
If there is a match on 8.8.8.8 at 250 seconds then the timer is reset.
If there is no match on 8.8.8.8 for 300 then the entry is removed

I wouldn't mind having a look at this myself but don't really know the 
first thing about NF and I've already gotten lost in the source.
