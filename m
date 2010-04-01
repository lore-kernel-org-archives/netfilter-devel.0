From: Patrick McHardy <kaber@trash.net>
Subject: Re: NetFlow / sFlow / IPFIX network probe proposal
Date: Thu, 01 Apr 2010 12:22:03 +0200
Message-ID: <4BB473CB.5030300@trash.net>
References: <faefb3f11003300706x16b73a2coefe5079284583db2@mail.gmail.com>	 <alpine.LSU.2.01.1003301647320.19967@obet.zrqbmnf.qr>	 <4BB22952.2050305@trash.net> <n2yfaefb3f11003310647uef53fd2k518c4c8f0367adc5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Stig Thormodsrud <stig@vyatta.com>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	linux-net@vger.kernel.org,
	Holger Eitzenberger <heitzenberger@astaro.com>
To: Roman Tsisyk <roman@tsisyk.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49260 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab0DAKWG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Apr 2010 06:22:06 -0400
In-Reply-To: <n2yfaefb3f11003310647uef53fd2k518c4c8f0367adc5@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Roman Tsisyk wrote:
> On Wed, Mar 31, 2010 at 2:06 AM, Stig Thormodsrud <stig@vyatta.com> wrote:
> On Tue, Mar 30, 2010 at 11:39 PM, Patrick McHardy <kaber@trash.net> wrote:
>> We already have conntrack and ctnetlink to gather per-connection
>> statistics, which should decrease the overhead for doing this in
>> userspace a lot. There also exists a netflow plugin for ulogd2,
>> but I'm not sure it was already submitted and merged.
>>
> 
> Thank you for pointing it out, I didn't know about conntrack support in ulogd.
> 
> As far as I understood, IPFIX output in ulogd is in a early stage and
> don't work. So, I tested ulogd + ctnetlink with null output and it
> worked very well.

IIRC Holger Eitzenberger (CCed) has done some work to make this work
properly. Maybe he can tell use more.

> CPU load was about 5-10%, and it's just nothing on this router.
> However, I'm not sure that output is correct and all flows was
> accounted. I also don't know what is about active and inactive
> timeouts in this approach.
> I'll look to ulogd_inpflow_NFCT more closely.
> 
> Patrick, decision is to optimize ctnetlink and not to make accounting
> in the kernel space?

Accounting is done in kernel space by conntrack, but aggregation should
be done in userspace in my opinion. I don't think you need a lot of
optimization, AFAIK Holger's patches already scale to large setups
very well.
