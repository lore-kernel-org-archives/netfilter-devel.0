From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: How to fix 'undefined symbol: ip6tc_ops'
Date: Mon, 18 Jun 2012 11:31:09 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1206181126481.18601@frira.zrqbmnf.qr>
References: <CAMOvP7fEFDofXnWHMnOtCV+1hB4H=rxJo6BYE5PtndK+Uc1KFg@mail.gmail.com> <CAMOvP7ec28fqR+H_tWUnhf3zDePLg6sQ1ajh+aLQPSYK-oVODw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Yang Yang <kormny@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:36731 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab2FRJbK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:31:10 -0400
In-Reply-To: <CAMOvP7ec28fqR+H_tWUnhf3zDePLg6sQ1ajh+aLQPSYK-oVODw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2012-06-18 08:45, Yang Yang wrote:
>>
>> Actually I've posted this question to 'netfilter@vger.kernel.org', but
>> I didn't get an answer. So I'm looking for help here.

You did get an answer, from myself
( http://marc.info/?l=netfilter&m=133992686911732&w=2 )

>> I just have cross compiled iptables for my ARM-Linux board, but when I
>> tried run it, the error 'iptables: symbol lookup error: iptables:
>> undefined symbol: ip6tc_ops' occurred.

So again, what have you _actually_ done? Telling us that you
"ran iptables" is certainly not the whole picture.

You compiled it yourself, so send _complete_ logs, not just a summary in 
the style intended for {users with less of a technical background}.


>> commad: iptables
>> Error : iptables: symbol lookup error: iptables: undefined symbol: ip6tc_ops
>
>This time I've tried to use iptables-1.4.3.1, and it works. I believe
>there is some bug in some latest version of iptables. (
>iptables-1.4.13 didn't work either )
