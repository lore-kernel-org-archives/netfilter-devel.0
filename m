From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH] configure: Show support for connlabel
Date: Mon, 7 Mar 2016 23:05:15 +0530
Message-ID: <CAKHNQQEp7uV+afTfZ73k6srRQyj1ks_dsWYsbu0N_bWzsoNd-Q@mail.gmail.com>
References: <20160307091447.GA10194@gmail.com> <20160307140913.GA27599@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:33108 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbcCGRf4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 12:35:56 -0500
Received: by mail-oi0-f53.google.com with SMTP id d205so84454330oia.0
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Mar 2016 09:35:55 -0800 (PST)
In-Reply-To: <20160307140913.GA27599@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 7, 2016 at 7:39 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Mar 07, 2016 at 02:44:47PM +0530, Shivani Bhardwaj wrote:
>> Add the --enable-connlabel option and show whether it is already
>> supported.
>>
>> After this patch, iptables configuration shows up as:
>>
>> Iptables Configuration:
>>   IPv4 support:                               yes
>>   IPv6 support:                               yes
>>   Devel support:                      yes
>>   IPQ support:                                no
>>   Large file support:                 yes
>>   BPF utils support:                  no
>>   nfsynproxy util support:            no
>>   nftables support:                   yes
>>   connlabel support:                  yes
>>
>> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
>> ---
>>  configure.ac | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/configure.ac b/configure.ac
>> index 33a8f2d..c946d69 100644
>> --- a/configure.ac
>> +++ b/configure.ac
>> @@ -63,6 +63,9 @@ AC_ARG_WITH([pkgconfigdir], AS_HELP_STRING([--with-pkgconfigdir=PATH],
>>  AC_ARG_ENABLE([nftables],
>>       AS_HELP_STRING([--disable-nftables], [Do not build nftables compat]),
>>       [enable_nftables="$enableval"], [enable_nftables="yes"])
>> +AC_ARG_ENABLE([connlabel],
>> +     AS_HELP_STRING([--enable-connlabel], [Build libnetfilter_conntrack]),
>> +     [enable_connlabel="$enableval"], [enable_connlabel="yes"])
>
> I think there is still some missing code here. If the user requests
> connlabel but libnetfilter_conntrack (including the right version) is
> not available, then I would fail and display an error since the user
> is explicitly asking for this.
>
> Otherwise, we can fall back on the existing behaviour: just lazy check
> if it's there and enable it in that case. If the library is not
> present, just skip this.
>
> The --disable-connlabel should also work, in that case, we should skip
> adding support for this.
>
> Can you look into fitting this logic into this? Thanks.
>
Yes, I'll do that.
I need a bit of help here.
I followed some other modules for which support has been mentioned.
For example, libipq
When I first ran the configure script, it turned out
IPQ support:                          no

I did next time with the option --enable-libipq
As expected,
IPQ support:                          yes

But, I tried writing the output of both these cases to files and when
I looked up for difference between the two, turned out only this IPQ
support line was different among them, in any case following was shown

 config.status: creating libipq/Makefile
 config.status: creating libipq/libipq.pc

(because this is a part of AC_CONFIG_FILES)

I do not see any code associated with libipq in configure.ac.
May be I'm not understanding how these options are working, could you
please clarify a bit?

Thank you.

>>  libiptc_LDFLAGS2="";
>>  AX_CHECK_LINKER_FLAGS([-Wl,--no-as-needed],
>> @@ -114,6 +117,7 @@ AM_CONDITIONAL([ENABLE_LIBIPQ], [test "$enable_libipq" = "yes"])
>>  AM_CONDITIONAL([ENABLE_BPFC], [test "$enable_bpfc" = "yes"])
>>  AM_CONDITIONAL([ENABLE_SYNCONF], [test "$enable_nfsynproxy" = "yes"])
>>  AM_CONDITIONAL([ENABLE_NFTABLES], [test "$enable_nftables" = "yes"])
>> +AM_CONDITIONAL([ENABLE_CONNLABEL], [test "$enable_connlabel" = "yes"])
>>
>>  if test "x$enable_bpfc" = "xyes" || test "x$enable_nfsynproxy" = "xyes"; then
>>       AC_CHECK_LIB(pcap, pcap_compile,, AC_MSG_ERROR(missing libpcap library required by bpf compiler or nfsynproxy tool))
>> @@ -243,6 +247,7 @@ Iptables Configuration:
>>    BPF utils support:                 ${enable_bpfc}
>>    nfsynproxy util support:           ${enable_nfsynproxy}
>>    nftables support:                  ${enable_nftables}
>> +  connlabel support:                 ${enable_connlabel}
>>
>>  Build parameters:
>>    Put plugins into executable (static):      ${enable_static}
>> --
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
