From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset 6.6 released
Date: Tue, 24 May 2011 12:09:01 +0100
Message-ID: <4DDB91CD.3080003@googlemail.com>
References: <alpine.DEB.2.00.1105241039080.1846@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47814 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab1EXLKh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 07:10:37 -0400
In-Reply-To: <alpine.DEB.2.00.1105241039080.1846@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> I thank to Mr Dash Four for his tireless testings and helpful reports.
>   
I thank you for your continuing development of this great tool which, at 
least in my case, hugely improved the stability and performance, as well 
as decreased the maintenance needed on all my systems as a direct result 
of employing this great tool!

> The next ipset package release will come with code simplifications, which 
> mean dropping some support:
>
> - iptree and iptreemap type support will be removed, because the automatic
>   conversion to hash:ip is not fully backward compatible. The hash:ip and 
>   hash:net types can be used instead.
> - kernel version support below 2.6.37 will be dropped, to make code
>   maintenance easier and more straightforward
>   
What are your plans with regards to the last point? The reason I am 
asking is because I am still on .35 (the last "stable" kernel released 
by Fedora) and I might not be able to use new releases if you introduce 
this restriction.

Also, would you consider my suggestion to include the number of members 
registered in a set to be displayed in the set headers (something like 
"Members: 15156") - this would help with managing the number of members 
in that set, which would be particularly useful for sets with large 
number of members.

