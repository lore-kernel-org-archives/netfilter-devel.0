From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: Issue with latest nftables
Date: Mon, 01 Jul 2013 09:56:45 +0300
Message-ID: <51D1282D.1050007@linux.intel.com>
References: <1372450120.8772.5.camel@tiger2> <20130629094503.GA3805@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:45843 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472Ab3GAG4s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Jul 2013 02:56:48 -0400
In-Reply-To: <20130629094503.GA3805@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,
>> netlink: Error: unknown expression type 'match'
>> name=iprange rev=1
>>
>>
>> netlink: Error: unknown expression type 'target'
>> name=LOG rev=0
>>
>> Should this problem be trivial for someone, I let him do the job. If
>> not, I will start to work on it.
> We don't have support for compat from nft yet. That should be
> relatively easy to fix.
>

Do we want to support those totally, or just when listing the rules? I 
would rather do the later one, nft is not meant to maintain 
iptables-nftables rules.
Where were could only handle then the expression itselsf and the name of 
the match/target, but nothing more. (No blob parsing etc...)

Tomasz
