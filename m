From: Valentina Giusti <valentina.giusti@oss.bmw-carit.de>
Subject: Re: [PATCH 0/4] [RFC] nfnetlink_acct: Traffic-based and periodic
 notifications
Date: Thu, 05 Sep 2013 16:58:40 +0200
Message-ID: <52289C20.5080104@oss.bmw-carit.de>
References: <1378296333-19208-1-git-send-email-valentina.giusti@bmw-carit.de> <20130904123920.GB4900@localhost> <522839BC.6000909@oss.bmw-carit.de> <20130905082752.GA3975@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: valentina.giusti@bmw-carit.de, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.bmw-carit.de ([62.245.222.98]:49643 "EHLO
	linuxmail.bmw-carit.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752936Ab3IEO6n (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:58:43 -0400
In-Reply-To: <20130905082752.GA3975@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On 09/05/2013 10:27 AM, Pablo Neira Ayuso wrote:
> On Thu, Sep 05, 2013 at 09:58:52AM +0200, Valentina Giusti wrote:
> [...]
>> As I mentioned, there are
>>
>> "applications (e.g. connman) which currently need to keep polling
>> accounting objects via nfnl_acct_get() in order to get updated
>> statistics. This is far from ideal in scenarios with large amounts
>> of accounting objects and diverse, unpredictable network traffic."
> You get around 100 accounting objects with one single recv syscall on
> x86_64 when polling from userspace. If you're noticing performance
> issues with this approach, please report them more precisely.

It's actually rather a conceptual matter here.
Requesting notifications from userspace via nfnl_acct_get() implies that 
for each and every one of them, userspace has to make a new query. Is 
polling for stats  better than receiving notifications from the kernel?

Thanks,
- V.
