From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH 00/18] netfilter: IPv6 NAT
Date: Tue, 29 Nov 2011 13:32:07 +0100
Message-ID: <4ED4D0C7.2020705@trash.net>
References: <1322153850-10533-1-git-send-email-kaber@trash.net> <4ED3C174.9030302@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	ulrich.weber@sophos.com
To: sclark46@earthlink.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58266 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab1K2McO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:32:14 -0500
In-Reply-To: <4ED3C174.9030302@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 28.11.2011 18:14, Stephen Clark wrote:
> On 11/24/2011 11:57 AM, kaber@trash.net wrote:
>> The following patches contain the updated IPv6 NAT patchset forward
>> ported
>> to 3.2-rc3. ...
>>
>>
>>    
> Probabably a dumb question but are these patches for natting ipv6 to
> ipv6 or ipv4 to ipv6?

IPv6 to IPv6. I haven't really considered IPv6 to IPv4 yet.
