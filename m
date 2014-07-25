From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: reset nfacct counters
Date: Fri, 25 Jul 2014 12:05:12 +0400
Message-ID: <53D20FB8.9050606@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	alexey.perevalov@hotmail.com,
	=?UTF-8?B?J+qzoO2YhOyEsSc=?= <hs81.go@samsung.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, mathieu.poirier@linaro.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:26252 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759830AbaGYIFR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:05:17 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N99006TRD4G4140@mailout4.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Fri, 25 Jul 2014 09:05:04 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Pablo and Mathieu.
I would like to thank you for quota with notification implementation in 
nfacct.

But also I want to discuss about resetting counters value. Right now 
nfacct has 2 way to get counter
NFNL_MSG_ACCT_GET and NFNL_MSG_ACCT_GET_CTRZERO, last one is intended to 
nullify accumulated counter.
It resets counters with and without populated quota value. After commit 
683399eddb nfacct really operates
with 2 different entities: pure counter and quota based counter. If so, 
why not to operate with it separately,
maybe by some filter (flag).

Also it was strange for me, why reset is not a command of command line 
tool nfacct, like get? Ok, if it's an argument of get, why not it's a 
flag (attribute) in netlink serialization?

Why I'm asking such questions. My use case requires periodic reset of 
the counters, also I have quota based counters and I don't want to reset 
them.
I could work around it from user space, for example, I could get quota 
based counter before I'm going to reset counters, delete it and key it 
in after counters reset. As you could see too much operations. Or I 
could could avoid reseting, but in this case I need to operates with 
deltas in user space and it's not robust in situation when my daemon is 
restarting. Every variant in user space leads to more run time complexity.

And my final question, will you accept a patch, which will move CTRZERO 
to netlink attribute and CTRZERO will be expanded to CTRZERO_OVERAL, 
CTRZERO_COUNTER and CTRZERO_QUOTA? For both kernel side and user space 
part (nfacct tool with libraries).


-- 
Best regards,
Alexey Perevalov
