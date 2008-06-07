From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Bug 10875] Oops in nf_nat_setup_info
Date: Sat, 07 Jun 2008 14:01:16 +0200
Message-ID: <484A788C.3000205@trash.net>
References: <Pine.LNX.4.64.0806061931140.12641@bizon.gios.gov.pl> <Pine.LNX.4.64.0806070046360.12641@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43209 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbYFGMBn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Jun 2008 08:01:43 -0400
In-Reply-To: <Pine.LNX.4.64.0806070046360.12641@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krzysztof Oledzki wrote:
>
>
> On Fri, 6 Jun 2008, Krzysztof Oledzki wrote:
>
>> Hello,
>>
>> Today I have been plaing with the conntrackd utility and noticed it 
>> is very easy to trigger a kernel oops just by:
>>
>> conntrackd -d
>> conntrackd -n
>> conntrackd -c
>> conntrackd -c
>
> OK, quite often is is enough to run only the first "conntrackd -c" to 
> crash the kernel. 

Is that with or without your accounting patch?
