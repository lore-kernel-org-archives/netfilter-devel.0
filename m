From: Rudolf_AT <Rudolf_AT.nf@aon.at>
Subject: Re: IP sets: Suggestion: additional value match
Date: Thu, 6 Aug 2015 18:08:24 +0200
Message-ID: <55C38678.30005@aon.at>
References: <55BA42E9.70808@aon.at>
 <alpine.DEB.2.10.1508031058510.26858@blackhole.kfki.hu>
 <55C052E8.9040101@aon.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpout.aon.at ([195.3.96.117]:47683 "EHLO smtpout.aon.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbbHFQI3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Aug 2015 12:08:29 -0400
In-Reply-To: <55C052E8.9040101@aon.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Just to let you know, regarding my previous post:
 > In particular, I used SET instead of CONNMARK to implement the rules
 > described by Jan Engelhardt in "Detecting and deceiving network scans".

(Has nothing to do with IP sets.)
As it turns out, some legitimate clients open and close TCP connections 
in a way which makes them behave like connect scans. This makes the 
attempt detecting those scans by the mentioned rules look less appealing.

Best Regards,
Rudolf

