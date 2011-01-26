From: Glauco Junquera <glaucoaok@gmail.com>
Subject: Re: Filter input traffic by uid
Date: Wed, 26 Jan 2011 07:52:45 -0300
Message-ID: <AANLkTinCsGe1Ly_q6+Acq81CA41BY-bEJr-VMknSGK+7@mail.gmail.com>
References: <AANLkTikXDsRGoV4aFDxpWzdU9Pov=_-=6dMB=cbmtpQu@mail.gmail.com>
	<4D3ED8CD.9040902@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62691 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab1AZKwq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jan 2011 05:52:46 -0500
Received: by iyj18 with SMTP id 18so234638iyj.19
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jan 2011 02:52:46 -0800 (PST)
In-Reply-To: <4D3ED8CD.9040902@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks Patrick!
I gave a quick look in the patches and I think they will help me a lot.

On Tue, Jan 25, 2011 at 11:06 AM, Patrick McHardy <kaber@trash.net> wrote:
> On 25.01.2011 13:04, Glauco Junquera wrote:
>> Hi All,
>>
>> Iptables can filter output traffic by uid, for example iptables -A
>> OUTPUT -m owner --uid-owner 100 -p udp -j DROP.
>> I need to implement the same for input traffic. Anyone have any idea
>> of how can i do it (where i must start)? I am new to netfilter
>> development i tried some simple modifications on code with no success.
>> I would really appreciate any kind of help.
>
> I've added socket layer hooks a couple of years ago for that
> purpose, but we've never merged it. James Morris based some
> work on them, I think this should be the latest version:
>
> http://people.redhat.com/jmorris/selinux/skfilter/kernel/
>
