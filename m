From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH v3] configure: Show support for connlabel
Date: Wed, 16 Mar 2016 00:32:51 +0530
Message-ID: <CAKHNQQHQjiHE26UwYWGPKr+baDftxymBjmr9mJF5mepQBr8+QA@mail.gmail.com>
References: <20160312121804.GA27150@gmail.com> <20160315003601.GA23295@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:33533 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934145AbcCOTDb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2016 15:03:31 -0400
Received: by mail-ob0-f182.google.com with SMTP id fz5so27666064obc.0
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 12:03:31 -0700 (PDT)
In-Reply-To: <20160315003601.GA23295@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 15, 2016 at 6:06 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Mar 12, 2016 at 05:48:04PM +0530, Shivani Bhardwaj wrote:
>> Add the --disable-connlabel option and the appropriate functionality
>> associated with it.
>>
>> After this patch, iptables configuration shows up as:
>>
>> Iptables Configuration:
>>   IPv4 support:                         yes
>>   IPv6 support:                         yes
>>   Devel support:                        yes
>>   IPQ support:                          no
>>   Large file support:                   yes
>>   BPF utils support:                    no
>>   nfsynproxy util support:              no
>>   nftables support:                     yes
>>   connlabel support:                    yes
>
> I think we are almost there, see below.
>
>> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
>> ---
>> Changes in v3:
>>       Remove check for libnfnetlink from the if block
>>
>> Changes in v2:
>>       Correct the option to disable-connlabel and add code to make it
>>       work
>>
>>  configure.ac | 30 +++++++++++++++++++++---------
>>  1 file changed, 21 insertions(+), 9 deletions(-)
>>
>> diff --git a/configure.ac b/configure.ac
>> index 33a8f2d..f9bc2a3 100644
>> --- a/configure.ac
>> +++ b/configure.ac
> [...]
>> @@ -168,6 +164,21 @@ if test "$nftables" != 1; then
>>       blacklist_a_modules="$blacklist_a_modules mangle"
>>  fi
>>
>> +if test "x$enable_connlabel" = "xyes"; then
>> +     PKG_CHECK_MODULES([libnetfilter_conntrack],
>> +             [libnetfilter_conntrack >= 1.0.4],
>> +             [nfconntrack=1], [nfconntrack=0])
>> +
>> +     if test "$nfconntrack" -ne 1; then
>> +             blacklist_modules="$blacklist_modules connlabel";
>> +             echo "WARNING: libnetfilter_conntrack not found, connlabel match will not be built";
>
> Could you set enable_connlabel to "no" when this occurs so the banner
> also displays that connlabel support has been skipped?
>
OK. Thanks.
One question, in case of nftables, I see enable_nftables is nowhere
set to "no", should that be added in case package requirements are not
met?
Same for bpfc and nfsynproxy.

>> +     fi;
>> +else
>> +     blacklist_modules="$blacklist_modules connlabel";
>> +fi;
