From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH conntrack-tools] configure: Fix flex version check
Date: Sat, 18 Jun 2016 22:19:51 +0530
Message-ID: <CAKHNQQHpZHTxmPnZjc6jBasnUrFHLQdi-WqmCP-e7TMC1uihaQ@mail.gmail.com>
References: <1466191063-25552-1-git-send-email-shivanib134@gmail.com> <20160618124245.GA13901@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:34319 "EHLO
	mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbcFRQub (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Jun 2016 12:50:31 -0400
Received: by mail-vk0-f67.google.com with SMTP id w1so5996254vka.1
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jun 2016 09:50:31 -0700 (PDT)
In-Reply-To: <20160618124245.GA13901@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jun 18, 2016 at 6:12 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Shivani,
>
> Thanks for following up on this, see comment below.
>
> On Sat, Jun 18, 2016 at 12:47:43AM +0530, Shivani Bhardwaj wrote:
>> Following the fixes for version check in iptables and nftables, make
>> conntrack-tools avoid generating false warning for Flex version greater
>> than 2.5.x.
>>
>> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
>> ---
>>  configure.ac | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/configure.ac b/configure.ac
>> index c541034..3bc5155 100644
>> --- a/configure.ac
>> +++ b/configure.ac
>> @@ -46,7 +46,7 @@ flex_major=`echo $flex_version| cut -d . -f 1`
>>  flex_minor=`echo $flex_version| cut -d . -f 2`
>>  flex_rev=`echo $flex_version| cut -d . -f 3`
>>
>> -if test "$flex_major" -eq "2" && test "$flex_minor" -eq "5" && test "$flex_rev" -ge "33"; then
>> +if (test "$flex_major" -eq "2" && test "$flex_minor" -eq "5" && test "$flex_rev" -ge "33") || (test "$flex_major" -eq "2" && test "$flex_minor" -gt "5") || test "$flex_major" -gt "2"; then
>>       AC_MSG_RESULT([$flex_version. OK])
>>  else
>>       AC_MSG_WARN([flex version $flex_version found.
>
> I'm starting to think that it's better to get rid of this version
> check. This was introduced in 2008:
>
>         ed50c34 ("add flex version warning (better with >= 2.5.33)")
>
> I can see RPM packages for 2.5.53 since 2008.
>
> The development of conntrack-tools a bit before that time, so I think
> it's better to nuke these checks, better since we have less code to
> maintain :)
>

Hi Pablo,

Just to avoid any confusion, should I be following up with patches for
iptables and conntrack-tools to completely remove this check? It is
already not there in nft. Please let me know.

Thank you.

> Thanks.
