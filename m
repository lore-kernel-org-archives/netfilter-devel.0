From: ivan <lagigliaivan@gmail.com>
Subject: Re: L2 NAT
Date: Thu, 4 Dec 2008 11:34:12 -0200
Message-ID: <f4d9d6df0812040534i7053483eh49d20b08afa26296@mail.gmail.com>
References: <f4d9d6df0812030922y34efdaddu16c808ee637beb4b@mail.gmail.com>
	 <38bcb3ec0812031701k3df95b38y5bf4c77686a2347f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "James King" <t.james.king@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:27373 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbYLDNeO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Dec 2008 08:34:14 -0500
Received: by ey-out-2122.google.com with SMTP id 6so1729504eyi.37
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Dec 2008 05:34:12 -0800 (PST)
In-Reply-To: <38bcb3ec0812031701k3df95b38y5bf4c77686a2347f@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

James,

Thanks for your soon reply!

I think that your answer is a good approach, but I would like to
pass/modify the module parameters while this one is running. I believe
this way allows to the user more flexibility to add/configure the
module behavior.

Please, let me know if you have any idea.

Thanks again.

ivan.




On Wed, Dec 3, 2008 at 11:01 PM, James King <t.james.king@gmail.com> wrote:
> On Wed, Dec 3, 2008 at 9:22 AM, ivan <lagigliaivan@gmail.com> wrote:
>> I would like to pass parameters to the kernel module in run time from
>> user space. These parameters could be IP address and MAC. Somebody
>> know how I can do this??
>
> Use the module_param functions (you probably want the string variant).
>  See http://tldp.org/LDP/lkmpg/2.6/html/x323.html for examples.
>
>> I was thinking about passing this parameters thorough a sysctl syscall
>> or using /proc filesystem, but I beleave that this is not the correct
>> way.
>
> Depends on if you need to be able to modify it after the module has
> already been loaded.  If not, a module parameter should suffice.
>
>
> HTH,
> James
>
