From: John Haxby <john.haxby@oracle.com>
Subject: Re: L2 NAT
Date: Thu, 04 Dec 2008 14:38:34 +0000
Message-ID: <4937EB6A.9050109@oracle.com>
References: <f4d9d6df0812030922y34efdaddu16c808ee637beb4b@mail.gmail.com>	 <38bcb3ec0812031701k3df95b38y5bf4c77686a2347f@mail.gmail.com> <f4d9d6df0812040534i7053483eh49d20b08afa26296@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: James King <t.james.king@gmail.com>,
	netfilter-devel@vger.kernel.org
To: ivan <lagigliaivan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:61980 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbYLDOir (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Dec 2008 09:38:47 -0500
In-Reply-To: <f4d9d6df0812040534i7053483eh49d20b08afa26296@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ivan wrote:
> I think that your answer is a good approach, but I would like to
> pass/modify the module parameters while this one is running. I believe
> this way allows to the user more flexibility to add/configure the
> module behavior.
>   

You can do that with module parameters, they appears as files in 
/sys/module/<module-name>/parameters and, given the right permissions, 
you can modify them as you see fit.

jch
