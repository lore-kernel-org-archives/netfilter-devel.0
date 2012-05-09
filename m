From: Gaurav Sinha <vgsinha@gmail.com>
Subject: Re: iptables ulog-cprange
Date: Wed, 09 May 2012 00:13:50 -0700
Message-ID: <4FAA192E.80703@gmail.com>
References: <4FA98904.3070008@gmail.com> <20120508223611.GA18723@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57262 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab2EIHNw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 May 2012 03:13:52 -0400
Received: by pbbrp8 with SMTP id rp8so133907pbb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 09 May 2012 00:13:52 -0700 (PDT)
In-Reply-To: <20120508223611.GA18723@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 5/8/12 3:36 PM, Pablo Neira Ayuso wrote:
> Hi Gaurav,
>
> On Tue, May 08, 2012 at 01:58:44PM -0700, Gaurav Sinha wrote:
>> Hi All,
>>
>> I am getting this error which points out the ulog-cprange that I am
>> using is incorrect. It
>> should be a value in between 1-50. The man page says 0 is allowed
>> too, i.e. any number of
>> bytes. But, I cannot configure zero as well.
>>
>> Is zero no longer supported? Probably the man page is not updated
>> with this information.
>>
>> iptables v1.4.12.2: ULOG: bad value for option "--ulog-cprange", or out of
>> range (1-50).
>>
>> Try `iptables -h' or 'iptables --help' for more information.
>> Error: [iptables -t raw -I MY_PREROUTING_HOOK 1 -i eth0 -j ULOG
>> --ulog-nlgroup 2 --ulog-cprange 64 --ulog-qthreshold 10] failed - 512
> A bug was accidentally introduced in:
>
> 1f2474a libipt_ULOG: use guided option parser
>
> I have applied the following patch to resolve this issue:
>
> http://git.netfilter.org/cgi-bin/gitweb.cgi?p=iptables.git;a=commitdiff;h=6111382a6c27e73c1cef1777c1253be0453a9dbb;hp=8db1044ba608a78035bbf89007aab6b6d8ff6f68
>
> Thanks for reporting the problem.
Thank you Pablo
