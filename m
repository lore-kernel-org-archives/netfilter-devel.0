From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: clone packet with new destination address
Date: Fri, 22 Oct 2010 21:36:43 +0800
Message-ID: <AANLkTi=T3QwJp-yVT3GNk46mjmudQ5CrE71YnMqWfsOh@mail.gmail.com>
References: <4CC1843F.8050903@earthlink.net> <AANLkTi=Y6zdmj4hngEaJPjZjNTTWaWMERfKR=dGSkY9b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: sclark46@earthlink.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47299 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab0JVNhK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Oct 2010 09:37:10 -0400
Received: by wwe15 with SMTP id 15so865406wwe.1
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Oct 2010 06:37:08 -0700 (PDT)
In-Reply-To: <AANLkTi=Y6zdmj4hngEaJPjZjNTTWaWMERfKR=dGSkY9b@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 22, 2010 at 9:24 PM, Changli Gao <xiaosuo@gmail.com> wrote:
> On Fri, Oct 22, 2010 at 8:31 PM, Stephen Clark <sclark46@earthlink.net> wrote:
>> Hello,
>>
>> Problem:
>> I have a two monitoring servers behind a a linux firewall, one is primary
>> and one is backup.
>> In the field we have units sending udp informational packet to the primary
>> server. On the
>> linux firewall I would like to copy this packet and change the destination
>> address of the copied
>> packet to point to the backup server. Is there a way to do this without
>> writing any code?
>>
>> NOTE:
>> Currently the firewall is FreeBSD and we accomplish this rather easily using
>> ipfw along with natd, but we want to move to linux for our firewall.
>>
>
> I think you can use tc action mirred to mirror the packets to a fake
> NIC device ifb, and use tc action nat to dnat the packets received
> from ifb.
>

Oh, iptables can also do it. Please see iptables target TEE and RAWNAT
in xtables-addons. http://xtables-addons.sourceforge.net/

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
