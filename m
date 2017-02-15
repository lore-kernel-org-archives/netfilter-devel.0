From: Fabian Franz <s1410239008@students.fh-hagenberg.at>
Subject: Re: [Question] Is there some documentation for nftables development
Date: Wed, 15 Feb 2017 18:21:47 +0100
Message-ID: <fb394aca-8979-332d-c1f0-cbffef52f581@students.fh-hagenberg.at>
References: <f23dc1f5-6965-cdf0-cd7d-04d2c200e4a6@students.fh-hagenberg.at>
 <d73038eb-3609-d4a8-85af-30c81174eb3d@mindchasers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay01-mailcontrol.conova.com ([217.196.144.161]:53618 "EHLO
        relay01-mailcontrol.conova.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751313AbdBORVy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Feb 2017 12:21:54 -0500
In-Reply-To: <d73038eb-3609-d4a8-85af-30c81174eb3d@mindchasers.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear Mr. Cochran,


even if your document looks good, I am looking for some documentation
related to nftables - iptables is NO option because I want to implement
a kernel module for nftables doing that.

The problem is, that there is a wiki how to use it, but there is no
information how to extend it:

https://wiki.nftables.org/wiki-nftables/index.php/Main_Page


Kind regards


Fabian Franz




Am 2017-02-15 um 17:44 schrieb Bob Cochran:
> If you don't mind using iptables/Xtables instead:
> http://inai.de/documents/Netfilter_Modules.pdf
>
>
>
> On 02/15/2017 08:59 AM, Fabian Franz wrote:
>> Hi there,
>>
>> is there some documentation available how to create a custom match for a
>> firewall rule (nftables).
>>
>> What I want to create is a custom match which will query a user space
>> application, if the packet is allowed (returning a bool value)?
>>
>> Kind regards
>>
>> Fabian Franz
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe
>> netfilter-devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>


