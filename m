From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nefilter: nfnetlink: add nfnetlink_set_err and use it
 in	ctnetlink
Date: Mon, 16 Mar 2009 15:47:57 +0100
Message-ID: <49BE669D.7040502@netfilter.org>
References: <20090305163208.14553.517.stgit@Decadence> <49BE5E6F.2020708@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37425 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754834AbZCPOsG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:48:06 -0400
In-Reply-To: <49BE5E6F.2020708@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> This patch adds nfnetlink_set_err() to propagate the error to netlink
>> broadcast listener in case of memory allocation errors in the
>> message building.
> 
>> +void nfnetlink_set_err(u32 group, int error)
>> +{
>> +    netlink_set_err(nfnl, 0, group, error);
>> +}
>> +EXPORT_SYMBOL_GPL(nfnetlink_set_err);
> 
> Please make the pid argument controllable by the caller as well. This
> is necessary to avoid double error notifications when an error occurs
> in response to a user-request triggering notifications.

OK, I'll add it, but the pid passed as argument will be zero by now.
Note that, in the current code, user-requests ignore notification
errors, so there is no chance to get double error notifications.

I have another patch here to propagate errors of user-requests that
result in failing notifications, then the pid parameter in
nfnetlink_set_err() will be useful. That patch also includes the use of
NETLINK_BROADCAST_ERROR. I'll send you that patch soon.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
