From: Patrick McHardy <kaber@trash.net>
Subject: Re: Patch for iptables
Date: Wed, 04 Jun 2008 15:17:16 +0200
Message-ID: <484695DC.2030807@trash.net>
References: <19c1b8a90804291101x4544818agde26a61a02036c32@mail.gmail.com> <200806032327.m53NRYTk005126@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: raj.khem@gmail.com, netfilter-devel@vger.kernel.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40878 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbYFDNRU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:17:20 -0400
In-Reply-To: <200806032327.m53NRYTk005126@toshiba.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yasuyuki KOZAKAI wrote:
> Hi,
> 
> From: "Khem Raj" <raj.khem@gmail.com>
> Date: Tue, 29 Apr 2008 11:01:03 -0700
> 
>> Hello Yasuyuki-san
>>
>> I am not a regular contributor to iptables. However this is what I
>> noticed errors when I compiled latest iptables release on glibc 2.8
>> iptables is using union ip6_u directly which has been changed in
>> glibc. Usually it is preferred that these unions are accessed via the
>> provided macros that way any change in glibc headers is not affecting
>> the package the following patch works  and I have tested it on
>> OpenEmbedded.
> 
> Thank you for sending patch. I've fixed up it to apply to the recent
> iptables. Please send patches to netfilter-devel@vger.kernel.org from next
> time.
> 
> Patrick, please apply the following patch.

Done, thanks. Is git not working properly for you?
