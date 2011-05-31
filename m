From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset 6.7 released
Date: Tue, 31 May 2011 22:46:07 +0100
Message-ID: <4DE5619F.5040408@googlemail.com>
References: <alpine.DEB.2.00.1105312155260.29607@blackhole.kfki.hu> <1306878128.3171.4.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62002 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758298Ab1EaVqM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2011 17:46:12 -0400
In-Reply-To: <1306878128.3171.4.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> tc filter add dev ifb0 protocol ip parent 10: handle 2 \
> 	flow ipset ipset keys src \
> 	flowid 1:40
>
> Any plan on this side ?
>   
++1!

I have been waiting for this for quite some time and am currently 
"hardcoding" a lot of stuff in tc, which I was very reluctant to do as I 
have everything tied to ipset these days. So, in other words, I'll be 
glad if that would be possible!

