From: Fabian Franz <s1410239008@students.fh-hagenberg.at>
Subject: Re: [Question] Is there some documentation for nftables development
Date: Wed, 15 Feb 2017 20:33:22 +0100
Message-ID: <7a0794eb-f0bd-e9de-9367-004e53145678@students.fh-hagenberg.at>
References: <f23dc1f5-6965-cdf0-cd7d-04d2c200e4a6@students.fh-hagenberg.at>
 <d73038eb-3609-d4a8-85af-30c81174eb3d@mindchasers.com>
 <fb394aca-8979-332d-c1f0-cbffef52f581@students.fh-hagenberg.at>
 <1487183874.795.1@smtp.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: <netfilter-devel@vger.kernel.org>
To: Anatole Denis <natolumin@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay01-mailcontrol.conova.com ([217.196.144.161]:57662 "EHLO
        relay01-mailcontrol.conova.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750800AbdBOTd1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Feb 2017 14:33:27 -0500
In-Reply-To: <1487183874.795.1@smtp.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Anatole,


I am aware of this option, but this is still not what I want. For
example, I want to have a firewall rule

"tcp ssh user fabian accept"

to have a rule with my user in the match. For the authentication, a
captive portal or a radius server for 802.1X may be an option. The user
is part of the match and therefore it must be part of the rule (don't
want to evaluate everything twice).

There is also no reason to queue the full packet to the user space if
only the source is required.


Kind regards


Fabian Franz


Am 2017-02-15 um 19:37 schrieb Anatole Denis:
> On mer., févr. 15, 2017 at 6:21 , Fabian Franz
> <s1410239008@students.fh-hagenberg.at> wrote:
>> Dear Mr. Cochran,
>>
>>
>> even if your document looks good, I am looking for some documentation
>> related to nftables - iptables is NO option because I want to implement
>> a kernel module for nftables doing that.
>>
>> The problem is, that there is a wiki how to use it, but there is no
>> information how to extend it:
>>
>> https://wiki.nftables.org/wiki-nftables/index.php/Main_Page
>
> From your description, "query a user space application, if the packet
> is allowed", seems to be exactly nfqueue, which is already developed
> and in mainline kernel, and supported by nftables. The wiki you link
> to has a page on it:
> https://wiki.nftables.org/wiki-nftables/index.php/Queueing_to_userspace.
>
> As you can also see in the link, there is a userspace library for it,
> libnetfilter_queue, as well.
>
> The question is maybe, do you want to solve a problem (in which case I
> believe nfqueue could be a solution), or write a kernel module (in
> which case, sorry to be useless, I don't know about any documentation
> on the kernel side of netfilter) ?
>
> -- 
> Anatole
>


