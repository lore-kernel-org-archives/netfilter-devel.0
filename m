From: Tarkan Erimer <tarkan.erimer@f-secure.com>
Subject: Re: 10GbE Connectivity & Netfilter
Date: Wed, 14 Mar 2012 09:21:25 +0200
Message-ID: <4F6046F5.3030106@f-secure.com>
References: <4F5F49FC.1080207@f-secure.com> <alpine.LNX.2.01.1203131458170.5880@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fsmail-out.f-secure.com ([193.110.108.171]:56586 "EHLO
	fsmail-out.f-secure.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab2CNHV1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:21:27 -0400
In-Reply-To: <alpine.LNX.2.01.1203131458170.5880@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/13/2012 04:02 PM, Jan Engelhardt wrote:
> On Tuesday 2012-03-13 14:22, Tarkan Erimer wrote:
>> 1- Is netfilter subsystem multi-threaded/multi-core enabled ? So that, it can
>> spread the loads across the CPUs/Cores.
> Like most kernel subsystems, it is.
>
>> 2- Can it handle such loads consistently (without any issues/bottlenecks) as
>> I've mentioned above ?
> Question is more like, can your hardware handle it.
>
>> 4- What kind of netfilter/kernel configs recommended for such a load ?
> Does not really matter.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Thanks very much for your answers.

Cheers,

Tarkan
