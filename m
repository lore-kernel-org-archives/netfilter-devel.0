From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: netfilter: cache dst_entry in conntrack
Date: Mon, 08 Nov 2010 07:39:14 +0100
Message-ID: <4CD79B12.9060502@trash.net>
References: <AANLkTimVY870t+ugopoabpe3+QCDC9RFh0nCtgPmJLq8@mail.gmail.com> <4CD79A79.3030103@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54301 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab0KHGjQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Nov 2010 01:39:16 -0500
In-Reply-To: <4CD79A79.3030103@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[resend with netfilter-devel address fixed]

On 08.11.2010 07:36, Patrick McHardy wrote:
> On 08.11.2010 07:32, Changli Gao wrote:
>> When conntrack is enabled, we can cache dst_entry into the
>> corresponding conntrack to eliminate the subsequence
>> ip_route_input_noref() calls for the same connection. The current
>> implementation is a standalone module. If this idea is welcomed, I'll
>> try to push it up. Thanks.
>>
>> Here it is: https://github.com/xiaosuo/xiaosuo/tree/master/nf_rtcache/
> 
> Please send the patch as attachment so it can be discussed.

