From: Scott Baillie <scott.a.baillie@gmail.com>
Subject: Re: ip6tables-save LOG target output is different to iptables-save
Date: Sat, 6 Jul 2013 15:07:15 +1000
Message-ID: <CAC+BxFovBteFJQ=K7LHPX47CxAAbGpBuzCvdTdsU00AvxJ-pag@mail.gmail.com>
References: <CAC+BxFrOpO8UWdd4xa146AsZN52A2hSOmaTiyvOmQK-qktzVPg@mail.gmail.com>
	<20130706044121.GA15084@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qe0-f48.google.com ([209.85.128.48]:61584 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3GFFHQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Jul 2013 01:07:16 -0400
Received: by mail-qe0-f48.google.com with SMTP id 2so1508926qea.21
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2013 22:07:15 -0700 (PDT)
In-Reply-To: <20130706044121.GA15084@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

It is not a huge issue, it is just inconsistent.

ip6tables-save will always quote the prefix string and iptables-save
will sometimes quote the prefix string.

It just makes it a little bit harder to parse the output , because
both tools should produce the same output
wherever possible in my opinion.

Regards,

Scott.

On Sat, Jul 6, 2013 at 2:41 PM, Phil Oester <kernel@linuxace.com> wrote:
> On Sat, Jul 06, 2013 at 01:42:00PM +1000, Scott Baillie wrote:
>> Hi All,
>>
>> I am using  ip6tables-save  version  v1.4.14 and have noticed
>> that the output of the LOG target is different to the output from
>> iptables-save  version  v1.4.14.
>
> Yes, quotes are not included if there is no whitespace, but it is
> quoted if whitespace is present:
>
> -A INPUT -s 1.2.3.4/32 -j LOG --log-prefix "foo doo"
> -A INPUT -s 1.2.3.4/32 -j LOG --log-prefix foo
>
> Is this an issue?
>
> Phil
