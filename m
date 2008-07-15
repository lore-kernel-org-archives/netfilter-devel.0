From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ULOGD PATCH] rework, fill MAC address in ULOG for ethernet.
Date: Tue, 15 Jul 2008 15:26:28 +0200
Message-ID: <487CA584.3030200@trash.net>
References: <486B88F4.7060704@trash.net> <1215554219-13763-1-git-send-email-eric@inl.fr> <487497F4.8070004@netfilter.org> <48749899.7070505@trash.net> <48749AF1.60900@netfilter.org> <48749CAA.3030306@trash.net> <20080709210454.GA4461@ghlodit.inl.fr> <48752B26.3010404@trash.net> <20080710203931.GB4000@bayen.regit.org> <48776972.8080305@trash.net> <20080715124924.GA7175@khasse.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Eric Leblond <eric@inl.fr>, Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57582 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759748AbYGON0b (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jul 2008 09:26:31 -0400
In-Reply-To: <20080715124924.GA7175@khasse.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hello,
> 
> On Friday, 2008 July 11 at 16:08:50 +0200, Patrick McHardy wrote:
>>>> This comment made me believe that it would break header
>>>> printing for non-ethernet packets. If that is not true,
>>>> I have no objections.
>>> Hmm, you're right but user using non-ethernet packets can upgrade to
>>> NFLOG ;)
>> I assume thats not meant seriously :) But we should integrate
>> new features into the new things, not break old things and
>> expect users to upgrade :)
> 
> Well, we still have a problem here:
>  * ULOG logs raw hardware header
>  * NFLOG logs source hardware address only
>  * SQL output module only support real MAC address (at least for PGSQL which
>  has a dedicated type)
> 
> I'm not able to find a clean and easy way to fix this.
> 
> Here's some possible solutions:
>  * Modify mac type in database to support everything:
>   * Performance impact
>   * Different datatypes in same field :(

It seems we already have a problem here since we can't put
other link layer headers in the database.

>  * NFLOG modification to log full hardware header:
>   * Will revert to a non parsable field :(

How about extending nfnetlink_log to include the full MAC header
and link layer type? That will make it a superset of ULOG.

>  * ULOG header parsing:
>   * Incomplete and untrustable by design
>   * May be able to retrieve source HW address info in most cases
>   * ULOG could output fields raw.mac and raw.mac.saddr to ensure
>   compatibility with older applications

Why don't you do something similar to your previous patch,
but instead of refusing unknown header lengths, treat
them as before?

> IMHO last solution is the less worst one. If it seems ok for you, I will
> provide a patchset implementing this solution.

I don't think I understand the problem well enough yet
to make that decision. Generally, I'm fine with anything
that doesn't break existing features and doesn't stand
in the way of correctly handling non-ethernet headers.


