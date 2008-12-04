From: ivan <lagigliaivan@gmail.com>
Subject: Re: L2 NAT
Date: Thu, 4 Dec 2008 13:43:33 -0200
Message-ID: <f4d9d6df0812040743o58af28d8jf771a04924be0f22@mail.gmail.com>
References: <f4d9d6df0812030922y34efdaddu16c808ee637beb4b@mail.gmail.com>
	 <38bcb3ec0812031701k3df95b38y5bf4c77686a2347f@mail.gmail.com>
	 <f4d9d6df0812040534i7053483eh49d20b08afa26296@mail.gmail.com>
	 <4937EB6A.9050109@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "James King" <t.james.king@gmail.com>,
	netfilter-devel@vger.kernel.org
To: "John Haxby" <john.haxby@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:56720 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758896AbYLDPnf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:43:35 -0500
Received: by ey-out-2122.google.com with SMTP id 6so1756650eyi.37
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Dec 2008 07:43:33 -0800 (PST)
In-Reply-To: <4937EB6A.9050109@oracle.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks jch,

I will try doing this!
My module works changing the IP address of a package according to its
MAC address, so I would like to add diferents <MAC-IP> couples while
the module is running.

Thanks!!

On Thu, Dec 4, 2008 at 12:38 PM, John Haxby <john.haxby@oracle.com> wrote:
> ivan wrote:
>>
>> I think that your answer is a good approach, but I would like to
>> pass/modify the module parameters while this one is running. I believe
>> this way allows to the user more flexibility to add/configure the
>> module behavior.
>>
>
> You can do that with module parameters, they appears as files in
> /sys/module/<module-name>/parameters and, given the right permissions, you
> can modify them as you see fit.
>
> jch
>
