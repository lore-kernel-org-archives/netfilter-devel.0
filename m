From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] New Target Extension OBSF
Date: Wed, 19 Sep 2012 04:36:39 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1209190434080.13470@nerf07.vanv.qr>
References: <1347895271.27332.1.camel@kernel-host-rh6> <alpine.LNX.2.01.1209180120530.22227@nerf07.vanv.qr> <CAGuaRCvVhf8+ZjvSG3NBnSXH1PStb3Di6fnydKVgXrLYhKdV1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Aft nix <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:47907 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981Ab2ISCgl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Sep 2012 22:36:41 -0400
In-Reply-To: <CAGuaRCvVhf8+ZjvSG3NBnSXH1PStb3Di6fnydKVgXrLYhKdV1w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2012-09-18 09:46, Aft nix wrote:
>
>On Tue, Sep 18, 2012 at 6:04 AM, Jan Engelhardt <jengelh@inai.de> wrote:
>>
>> On Monday 2012-09-17 17:21, aft wrote:
>>>
>>>1) it encrypts UDP traffic.
>>>2) it adds false bytes(padding).
>>>
>>>Its purpose is to escape smarter DPIs which blocks certain kinds of
>>>packets by several heuristic methods.
>>
>> But then why not use IPsec (udpencap), OpenVPN, or something?
>> After all, you do already need a cooperating peer to decrypt
>> your traffic, and hence might as well pick a _standardized_ solution.
>
>The client does not support IPsec.

Why would it not? If you can make kernel changes, you can as well run
a simple userspace program. (Example for a userspace program that
does IPsec using tun interface: vpnc.)

>>>+      },
>>>+      {
>>>+              .name = "OBSF",
>>>+              .revision = 1,
>>>+              .family = NFPROTO_UNSPEC,
>>>+              .target = obsf_tg_v1,
>>>+              .targetsize = sizeof(struct xt_OBSF_tginfo_v1),
>>>+              .checkentry = obsf_tg_check_v1,
>>>+              .me = THIS_MODULE,
>>>+      },
>>>+};
>>
>> There is no need to use two revisions.
>
>Well, i thought there are times when you will not inject false bytes,
>just encryption will suffices. That's why i've made
>Two versions. When to make two versions is not really clear to me.

A new ABI is needed when the struct you are using to pass options
such as "pad or not" does not suffice to hold your option data
any more.
