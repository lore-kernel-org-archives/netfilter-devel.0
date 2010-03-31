From: Roman Tsisyk <roman@tsisyk.com>
Subject: Re: NetFlow / sFlow / IPFIX network probe proposal
Date: Wed, 31 Mar 2010 20:47:39 +0700
Message-ID: <n2yfaefb3f11003310647uef53fd2k518c4c8f0367adc5@mail.gmail.com>
References: <faefb3f11003300706x16b73a2coefe5079284583db2@mail.gmail.com>
	 <alpine.LSU.2.01.1003301647320.19967@obet.zrqbmnf.qr>
	 <4BB22952.2050305@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	linux-net@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>,
	Stig Thormodsrud <stig@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f186.google.com ([209.85.222.186]:58366 "EHLO
	mail-pz0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933284Ab0CaNrs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Mar 2010 09:47:48 -0400
In-Reply-To: <4BB22952.2050305@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 31, 2010 at 2:06 AM, Stig Thormodsrud <stig@vyatta.com> wrote:
> Hi Roman,
>
> You mentioned that netflow exporter is the most requested feature on
> Vyatta.  That was true until today when VC6 was release with our 1st
> netflow/sflow exporter.  I used pmacct (http://www.pmacct.net) and ULOG
> to get the packets to uacctd.  There's certainly a lot more that can be
> done to support higher bandwidth interfaces.  I'm considering PF_RING.

I've read Vyatta site before VC6 was released :)
This is a ULOG-based solution or not?

On Tue, Mar 30, 2010 at 11:39 PM, Patrick McHardy <kaber@trash.net> wrote:
> We already have conntrack and ctnetlink to gather per-connection
> statistics, which should decrease the overhead for doing this in
> userspace a lot. There also exists a netflow plugin for ulogd2,
> but I'm not sure it was already submitted and merged.
>

Thank you for pointing it out, I didn't know about conntrack support in ulogd.

As far as I understood, IPFIX output in ulogd is in a early stage and
don't work. So, I tested ulogd + ctnetlink with null output and it
worked very well.
CPU load was about 5-10%, and it's just nothing on this router.
However, I'm not sure that output is correct and all flows was
accounted. I also don't know what is about active and inactive
timeouts in this approach.
I'll look to ulogd_inpflow_NFCT more closely.

Patrick, decision is to optimize ctnetlink and not to make accounting
in the kernel space?

-- 
WBR, Tsisyk Roman
