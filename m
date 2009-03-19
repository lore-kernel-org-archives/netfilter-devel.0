From: Patrick McHardy <kaber@trash.net>
Subject: Re: next iptables release
Date: Thu, 19 Mar 2009 13:55:54 +0100
Message-ID: <49C240DA.2070006@trash.net>
References: <49C202EA.40006@trash.net> <49C23FD6.6010503@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34781 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbZCSMz6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 08:55:58 -0400
In-Reply-To: <49C23FD6.6010503@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> I've planned to release the next iptables version sometime (late)
>> this weekend. We've had quite a lot of changes since the last
>> version, please test the latest version from git and report any
>> issues.
>>
>> Thanks!
> 
> Great :). BTW, I'm finishing the cluster match manpage, I'll be done
> tonight, I'd like to see it in this iptables release (even if the
> feature is expected to appear in 2.6.30).

I have to ask .. why? :)

Besides potentially confusing people (why doesn't it work despite me
doing everything the manpage says), what are the advantages of including
the manpage before the actual implementation?
