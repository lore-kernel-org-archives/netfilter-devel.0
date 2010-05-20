From: Anand Raj Manickam <anandrm@gmail.com>
Subject: Re: Any Performance benchmark on a Million conntracks
Date: Thu, 20 May 2010 22:43:13 +0530
Message-ID: <AANLkTikp7NU1cdAQHJkK9L14DsyRceaypO3ao_93raUu@mail.gmail.com>
References: <AANLkTinGFeinOo2LfMU_6jcNewuFxXkZL1f9vAE-SXBe@mail.gmail.com>
	 <1274360664.4046.36.camel@edumazet-laptop>
	 <4BF5414B.4090609@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qy0-f171.google.com ([209.85.221.171]:52545 "EHLO
	mail-qy0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab0ETRNT convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 May 2010 13:13:19 -0400
Received: by qyk1 with SMTP id 1so48625qyk.5
        for <netfilter-devel@vger.kernel.org>; Thu, 20 May 2010 10:13:18 -0700 (PDT)
In-Reply-To: <4BF5414B.4090609@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 20, 2010 at 7:33 PM, Patrick McHardy <kaber@trash.net> wrot=
e:
> Eric Dumazet wrote:
>> Le jeudi 20 mai 2010 =E0 18:21 +0530, Anand Raj Manickam a =E9crit :
>>> Hi,
>>> Is there any performance bench mark on conntrack response to 1 mill=
ion
>>> conntrack entries in the conntrack table.
>>> Since conntrack uses Hashing to lookup the entries i had some doubt=
s
>>> on the scalability. Can someone shed some light please?
>>
>> Question is not about number of conntrack entries in hash table, but
>> number of inserts and deletes per second.
>>
>> For persistent connections, if you use a hash table of one million
>> slots, performance will be very good, since the chain length is smal=
l.
>> Its scalable because each cpu can access conntrack table without loc=
ks,
>> in parallel.
>
My understanding is that , the chances of persistent connections on
Networks using internet is less.

Suppose , if there are around 50,000 connections adds and 50,000
connection deletes  on 1 million conncurrent conntrack entry table we
have a scalabilty problem ?

The reason why i m posting this question is on the ablity of hash
tables on 1 million entries vs rb trees handling 1 million entries .

> Actually the recommended hash table size is twice the number of
> expected connections since each conntrack is hashed twice :)
>

So , if i m expecting (i m just expecting connections from users NOT
on HELPERS/EXPECTATION) 1 million connections do i need to set the
conntrack table to 2 million ?

How much memory do we need to maintain 1 million connections ?

The typical iptables/netfilter  say about 32k connections for 512 MB
RAM / 64k connections for greater than 1 GB.
As per  my understanding each conntrack entry is about 300 odd bytes
,assuming 310 bytes per conntrack entry , (310 * 1000000) roughly
around 300 MB
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
