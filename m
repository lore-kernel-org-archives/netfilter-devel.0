From: "tung tran" <tunghack@gmail.com>
Subject: Re: Netfilter module help
Date: Sat, 12 Jul 2008 16:28:00 -0400
Message-ID: <13f1ba4c0807121328m527a4fclcf5df079cf7cc836@mail.gmail.com>
References: <13f1ba4c0807091558m5fff70ear7515557278001922@mail.gmail.com>
	 <alpine.LNX.1.10.0807100127040.27323@fbirervta.pbzchgretzou.qr>
	 <13f1ba4c0807091641j33a9ebe0ocbe6c0cb95883159@mail.gmail.com>
	 <1215648362.11885.5.camel@henriknordstrom.net>
	 <13f1ba4c0807091754oca9211dxd4166c1b56c0c66@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Henrik Nordstrom" <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:1675 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbYGLU2I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Jul 2008 16:28:08 -0400
Received: by yw-out-2324.google.com with SMTP id 9so2139743ywe.1
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Jul 2008 13:28:01 -0700 (PDT)
In-Reply-To: <13f1ba4c0807091754oca9211dxd4166c1b56c0c66@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi again,
I have another question, if I use QUEUE, is there any way  that I can
pass a packet back to a chain after processing it? For example, I use
libipq to receive a packet from kernel (through the special QUEUE
chain) and process the packet.  After processing the packet, I do not
want to ACCEPT or REJECT the packet, but pass it back to a different
chain, for example INPUT. Can I do this?
Thanks,
Tung.

On Wed, Jul 9, 2008 at 8:54 PM, tung tran <tunghack@gmail.com> wrote:
> Hi Henrik,
> Thank you very much. I really appreciate your help.
> Tung.
>
> On Wed, Jul 9, 2008 at 7:06 PM, Henrik Nordstrom
> <henrik@henriknordstrom.net> wrote:
>> On ons, 2008-07-09 at 18:41 -0500, tung tran wrote:
>>> Hi Jan,
>>> Thanks for your quick reply. Could you please give me some advices to
>>> accomplish the task? I need to pass the packet from kernel to a user
>>> space process to decide if the packet is accepted or denied.
>>
>> For that the existing NF_QUEUE mechanism should be used. If a hook
>> returns NF_QUEUE then the kernel suspends the packet and submits it to a
>> queue handler for querying the userspace. When the userspace responds
>> the packet is either rejected or allowed to continue processing at the
>> next hook handler.
>>
>> The normal ip_queue handler uses netlink to talk to userspace.
>>
>> There can only be one queue handler in the system.
>>
>> iptables has support for this via the QUEUE psuedo-target.
>>
>> Regards
>> Henrik
>>
>
