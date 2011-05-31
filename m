From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] ipset 6.7 released
Date: Tue, 31 May 2011 23:48:24 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1105312347170.14867@frira.zrqbmnf.qr>
References: <alpine.DEB.2.00.1105312155260.29607@blackhole.kfki.hu> <1306878128.3171.4.camel@edumazet-laptop> <4DE5619F.5040408@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:41795 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758298Ab1EaVsZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2011 17:48:25 -0400
In-Reply-To: <4DE5619F.5040408@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-05-31 23:46, Mr Dash Four wrote:

>
>> tc filter add dev ifb0 protocol ip parent 10: handle 2 \
>> 	flow ipset ipset keys src \
>> 	flowid 1:40
>>
>> Any plan on this side ?
>>  
> ++1!

There is already m_xt in iproute2... now it would only need f_xt.
Maybe you can convince Jamal..
