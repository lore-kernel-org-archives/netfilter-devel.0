From: Sassy Natan <sassyn@gmail.com>
Subject: Re: ULOG Packet Count
Date: Tue, 4 Feb 2014 00:13:56 +0200
Message-ID: <CACHQFzFV1KLfvnoeM+RN31ToAj4NT8W1efafVEtdPTbzvD6R1w@mail.gmail.com>
References: <CACHQFzFTDJ-zj9wx+my4Oy9sQ=nZg4mG=FX8JC7kHm-3n-Z-Bw@mail.gmail.com>
 <1391465110.19856.14.camel@ice-age2.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:49900 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaBCWOr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Feb 2014 17:14:47 -0500
Received: by mail-qa0-f49.google.com with SMTP id w8so10900836qac.22
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Feb 2014 14:14:47 -0800 (PST)
In-Reply-To: <1391465110.19856.14.camel@ice-age2.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric First thank you !

d9377e7ba22ec13a0c73785f86e5bcc869d1051f? What do u mean by that?
Is it the git version tag?

I guess it wan't be such a big issue to write a store procedure to get
the acct into mysql.
I will write it and will send it to you for review? Do u think is worth it?

Is there no other way to get the account taffic based on pure ulog
without using the  nacct?

why is the orig_bytes and orig_packets are always 0 in the ulog_ct tables?

Is there any IRC chat where I could chat with you?

Thanks
Sassy

On Tue, Feb 4, 2014 at 12:05 AM, Eric Leblond <eric@regit.org> wrote:
> Hi,
>
> On Mon, 2014-02-03 at 23:40 +0200, Sassy Natan wrote:
>> Hi All,
>>
>>
>> I being trying to understand how to get ulog2 to capture my network
>> traffic in terms of accounting.
>>
>> I have setup my ubuntu to work with ulog2 and MySQL, and manage to get
>> the tables fill up with data.
>>
>> Howerver, I didn't manage to understand how to get the packet length
>> so I could calculate the amount of data generated for the specific
>> service.
>>
>> In ulogd.conf I configure the following:
>>
>> stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2bin1:IP2BIN,mac2str1:HWHDR,mysql1:MYSQL
>> stack=ct1:NFCT,ip2bin1:IP2BIN,mysql2:MYSQL
>>
>>
>> Tables ulog2 and ulog2_ct are being populated with the data.
>> In ulog2_ct I can see a column name orig_bytes and orig_packets but
>> both of them are always 0.
>
> You need to enable accounting in conntrack:
>
> echo "1">/proc/sys/net/netfilter/nf_conntrack_acct
>
>> I google for this and found this
>> http://mohskitchen.wordpress.com/2012/08/27/accounting-with-ulogd-2-and-conntrack-on-a-gbit-nat/
>>
>> I'm also aware of nfacct, but haven't find a way to make it work with MySQL.
>
> Yes, MySQL schema has not been adapted to store these informations.
>
> Sassy, are you able to do it based on PostgreSQL one ? Commit
> implementing this is d9377e7ba22ec13a0c73785f86e5bcc869d1051f
>
> BR,
> --
> Eric Leblond <eric@regit.org>
>



-- 
Regards,

Sassy Natan
972-(05)54-2203702
