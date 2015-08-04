From: Rudolf_AT <Rudolf_AT.nf@aon.at>
Subject: Re: IP sets: Suggestion: additional value match
Date: Tue, 4 Aug 2015 07:51:36 +0200
Message-ID: <55C052E8.9040101@aon.at>
References: <55BA42E9.70808@aon.at>
 <alpine.DEB.2.10.1508031058510.26858@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpout.aon.at ([195.3.96.115]:5659 "EHLO email.aon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753089AbbHDFvm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2015 01:51:42 -0400
In-Reply-To: <alpine.DEB.2.10.1508031058510.26858@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for your reply!

 > As far as I see it's quite similar to the "connmark/CONNMARK" match
 > and target. Why cannot that simply be used?

Yes, it is quite similar to connmark. But - to my knowledge - I think at 
least the following differences apply:

CONNMARK can be used: a) if there are no conflicts with existing use of 
connmark rules - in particular with special firewall/packetfilter 
systems with built-in-rules - and b) if a connection should be 
identified exactly by src/dest IP + src/dest port.

SET can be used without interfering with connection tracking and other 
existing SET rules. Identifying the origin and destination of a packet 
is more flexible by using one or all of src/dest IP + one port.

In particular, I used SET instead of CONNMARK to implement the rules 
described by Jan Engelhardt in "Detecting and deceiving network scans".

Best Regards,
Rudolf
