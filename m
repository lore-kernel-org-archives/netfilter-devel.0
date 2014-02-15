From: Bourne Without <blackhole@airpost.net>
Subject: Re: [PATCH 0/2] ipset: forceadd support
Date: Sat, 15 Feb 2014 16:09:27 +0100
Message-ID: <52FF8327.5020109@airpost.net>
References: <1391261452-11266-1-git-send-email-johunt@akamai.com>
Reply-To: blackhole@airpost.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu
To: Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58009 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753279AbaBOPHt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Feb 2014 10:07:49 -0500
In-Reply-To: <1391261452-11266-1-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 01.02.2014 14:30, Josh Hunt wrote:
> Forceadd is a property for hash set types and is passed in duration creation.
> When sets with this property enabled are full each subsequent 'add' operation
> will attempt to evict a random entry from the set. The implementation tries to
> keep the overhead low by checking to see which bucket the new entry hashes to.
> If that bucket has any entries it will evict the first one and add the new
> entry.
>
> Ex usage:
> ipset create foo hash:ip forceadd
>
> The intended usecase is for things like 'ban' lists where you may not be concerned
> with possibly evicting something early, and more concerned with the size of
> the hash itself.

Sorry forgot the url :/

For all who want to save time typing while testing, I've already 
implemented the forceadd support in the ipset-bash_completion code 
available here:

https://github.com/AllKind/ipset-bash-completion/tree/dev

As it's set to enable the feature from ipset v6.21+, you need to either 
bump the ipset version, or just change line 886 in my code from:

  if ((ips_version[0] == 6 && ips_version[1] >= 21)); then

to:

  if ((ips_version[0] == 6 && ips_version[1] >= 20)); then

happy testing :)
