From: jalvarez <jalvarez@toulouse.viveris.com>
Subject: Re: [PATCH libnftnl] examples: selective rule dumping
Date: Fri, 22 Jul 2016 09:35:41 +0200
Message-ID: <5791CCCD.8080808@toulouse.viveris.com>
References: <20160721133630.GA2050@salvia>
 <1469113181-5034-1-git-send-email-jalvarez@toulouse.viveris.com>
 <20160721161329.GA1719@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.toulouse.viveris.com ([212.99.125.10]:40334 "EHLO
	mailS.toulouse.viveris.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751648AbcGVHfp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jul 2016 03:35:45 -0400
In-Reply-To: <20160721161329.GA1719@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21/07/2016 18:13, Pablo Neira Ayuso wrote:
> Please, send me your Signed-off-by: and a couple of lines with a
> description.
>
> No need to resend this patch, I'll amend this myself. But please
> include it next time. Thanks.

I apologize, I forgot to add it this time. Here are the missing lines you requested.


Improve nft-rule-get example to demonstrate selective rule dumping when table and / or chain attributes are set in a rule dump request. Usage is now as follows : nft-rule-get <family> [<table> <chain>] [<xml|json>].

Signed-off-by: Josue Alvarez<jalvarez@toulouse.viveris.com>

