From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: Re: [iptables PATCH] configure: exit if libnftnl is not found
Date: Sat, 9 Apr 2016 10:46:40 +0200
Message-ID: <CAFpD06RfmQe5gJO_VJo=2Ke-JqN3yMkge8xeEA0VNzy_uypSpQ@mail.gmail.com>
References: <1459073146-11576-1-git-send-email-giuseppelng@gmail.com>
	<20160408125536.GA8693@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37023 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbcDIIqm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Apr 2016 04:46:42 -0400
Received: by mail-wm0-f45.google.com with SMTP id n3so47373444wmn.0
        for <netfilter-devel@vger.kernel.org>; Sat, 09 Apr 2016 01:46:41 -0700 (PDT)
In-Reply-To: <20160408125536.GA8693@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2016-04-08 14:55 GMT+02:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Sun, Mar 27, 2016 at 12:05:46PM +0200, Giuseppe Longo wrote:
>> iptables building is broken if libnftnl is not installed
>> on the system, raising up the following errors:
>>
>> nft-shared.c:25:27: fatal error: libnftnl/rule.h: No such file or directory
>>  #include <libnftnl/rule.h>
>>                            ^
>> compilation terminated.
>> nft.c:41:28: fatal error: libnftnl/table.h: No such file or directory
>>  #include <libnftnl/table.h>
>>                             ^
>> compilation terminated.
>> mv -f .deps/xtables_multi-iptables-restore.Tpo .deps/xtables_multi-iptables-restore.Po
>> In file included from nft.h:5:0,
>>                  from nft-ipv6.c:25:
>> nft-shared.h:6:27: fatal error: libnftnl/rule.h: No such file or directory
>>  #include <libnftnl/rule.h>
>>                            ^
>> mv -f .deps/xtables_multi-xshared.Tpo .deps/xtables_multi-xshared.Po
>> compilation terminated.
>> In file included from nft.h:5:0,
>>                  from nft-ipv4.c:26:
>> nft-shared.h:6:27: fatal error: libnftnl/rule.h: No such file or directory
>>  #include <libnftnl/rule.h>
>>
>> configure script checks if libnftnl is installed, but doesn't
>> exit if it is not.
>>
>> Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
>> ---
>>  configure.ac | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/configure.ac b/configure.ac
>> index 33a8f2d..b08ecca 100644
>> --- a/configure.ac
>> +++ b/configure.ac
>> @@ -128,6 +128,13 @@ if test "x$enable_nftables" = "xyes"; then
>>
>>       PKG_CHECK_MODULES([libnftnl], [libnftnl >= 1.0.5], [nftables=1], [nftables=0])
>>
>> +     if test "$nftables" = 0;
>> +     then
>> +             echo "*** Error: No suitable libnftnl found. ***"
>> +             echo "    Please install the 'libnftnl' package."
>
> I'm going to take this patch, but mangle it to include this information too:
>
>                 echo "    Or consider --disable-nftables to skip "
>                 echo "    iptables-compat over nftables support."
>

I can send a v2 of this patch with these changes.
I think a similar patch is needed for libmnl because
there is a same issue.
