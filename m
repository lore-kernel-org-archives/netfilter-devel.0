From: "tung tran" <tunghack@gmail.com>
Subject: Re: Netfilter module help
Date: Wed, 9 Jul 2008 18:41:02 -0500
Message-ID: <13f1ba4c0807091641j33a9ebe0ocbe6c0cb95883159@mail.gmail.com>
References: <13f1ba4c0807091558m5fff70ear7515557278001922@mail.gmail.com>
	 <alpine.LNX.1.10.0807100127040.27323@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:35982 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbYGIXlD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jul 2008 19:41:03 -0400
Received: by yx-out-2324.google.com with SMTP id 8so942620yxm.1
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Jul 2008 16:41:03 -0700 (PDT)
In-Reply-To: <alpine.LNX.1.10.0807100127040.27323@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,
Thanks for your quick reply. Could you please give me some advices to
accomplish the task? I need to pass the packet from kernel to a user
space process to decide if the packet is accepted or denied.
Best,
Tung.

On Wed, Jul 9, 2008 at 6:27 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Thursday 2008-07-10 00:58, tung tran wrote:
>
>>Hi all,
>>I am writing a kernel module that hooks into netfilter.
>>netfilter_ops.hook              =       main_hook;
>>netfilter_ops.pf                =       PF_INET;
>>netfilter_ops.hooknum           =       NF_IP_PRE_ROUTING;
>>netfilter_ops.priority          =       NF_IP_PRI_FIRST;
>>nf_register_hook(&netfilter_ops);
>>
>>In the main_hook function, I needs to put the process to sleep and
>>will be woken up by another process because the decision to Accept or
>>Deny a packet depends on a process running in the user space. However,
>>all sleeping mechanism I tried  cause the kernel hang.
>
> You cannot sleep in an interrupt handler.
>
