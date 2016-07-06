From: Vikas <vikas.c.kumar@oracle.com>
Subject: DoS attack mitigation in netfilter
Date: Wed, 06 Jul 2016 10:06:45 +0530
Message-ID: <577C8ADD.60007@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, eric@netfilter.org
To: coreteam@netfilter.org, Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37814 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbcGFEg4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Jul 2016 00:36:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Wanted to explore options netfilter provides to mitigate DoS/SYN attacks.
Even if there is mechanism to incorporate rate limiter solution for high 
incoming volume traffic then it would help.

Any input in this regard will be appreciated.

Regards
Vikas
