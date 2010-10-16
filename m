From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Missing kernel header files
Date: Sat, 16 Oct 2010 17:34:31 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010161734040.13972@obet.zrqbmnf.qr>
References: <AANLkTinPD=3yC=KF_juTvUumXwmuMzgjrXyRg4NmML-C@mail.gmail.com> <alpine.LNX.2.01.1010012248410.24065@obet.zrqbmnf.qr> <AANLkTi=S0f1DR0Y0YCqtV6jqU2ugHUsDWdSDRbMjYKr_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: David Corrales <corrales.david@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48679 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab0JPPed (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Oct 2010 11:34:33 -0400
In-Reply-To: <AANLkTi=S0f1DR0Y0YCqtV6jqU2ugHUsDWdSDRbMjYKr_@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-10-04 18:56, David Corrales wrote:

>> Choosing arbitrary kernels is not designed to work before 1.4.3.
>
>Oh, that's too bad :(
>
>> Why bother with patching when just using 1.4.9 yields equivalent
>> behavior?
>>
>
>Thing is that other software modules depend on this headers as well so
>I wanted to minimize the impact. I rather patch than bump the version
>number.

The risk of incomplete patching is higher than using a newer release.
