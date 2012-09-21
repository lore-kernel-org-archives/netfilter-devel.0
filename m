From: Aft nix <aftnix@gmail.com>
Subject: Re: [PATCH] New Target Extension OBSF
Date: Fri, 21 Sep 2012 17:36:30 +0600
Message-ID: <CAGuaRCvT1oLxq=RNBufFpOGe9NXhbBcgfJ2vNibyP7wWhOWC_A@mail.gmail.com>
References: <1347895271.27332.1.camel@kernel-host-rh6>
	<alpine.LNX.2.01.1209180120530.22227@nerf07.vanv.qr>
	<CAGuaRCvVhf8+ZjvSG3NBnSXH1PStb3Di6fnydKVgXrLYhKdV1w@mail.gmail.com>
	<alpine.LNX.2.01.1209190434080.13470@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44942 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab2IULga (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Sep 2012 07:36:30 -0400
Received: by ieak13 with SMTP id k13so5149270iea.19
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Sep 2012 04:36:30 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1209190434080.13470@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 19, 2012 at 8:36 AM, Jan Engelhardt <jengelh@inai.de> wrote:
>
> On Tuesday 2012-09-18 09:46, Aft nix wrote:
>>
>>On Tue, Sep 18, 2012 at 6:04 AM, Jan Engelhardt <jengelh@inai.de> wrote:
>>>
>>> On Monday 2012-09-17 17:21, aft wrote:
>>>>
>>>>1) it encrypts UDP traffic.
>>>>2) it adds false bytes(padding).
>>>>
>>>>Its purpose is to escape smarter DPIs which blocks certain kinds of
>>>>packets by several heuristic methods.
>>>
>>> But then why not use IPsec (udpencap), OpenVPN, or something?
>>> After all, you do already need a cooperating peer to decrypt
>>> your traffic, and hence might as well pick a _standardized_ solution.
>>
>>The client does not support IPsec.
>
> Why would it not? If you can make kernel changes, you can as well run
> a simple userspace program. (Example for a userspace program that
> does IPsec using tun interface: vpnc.)

I'm doing these in Server's kernel. The client is a mobile device. AES/ARC4
are implemented in the client application directly.


>
>>>>+      },
>>>>+      {
>>>>+              .name = "OBSF",
>>>>+              .revision = 1,
>>>>+              .family = NFPROTO_UNSPEC,
>>>>+              .target = obsf_tg_v1,
>>>>+              .targetsize = sizeof(struct xt_OBSF_tginfo_v1),
>>>>+              .checkentry = obsf_tg_check_v1,
>>>>+              .me = THIS_MODULE,
>>>>+      },
>>>>+};
>>>
>>> There is no need to use two revisions.
>>
>>Well, i thought there are times when you will not inject false bytes,
>>just encryption will suffices. That's why i've made
>>Two versions. When to make two versions is not really clear to me.
>
> A new ABI is needed when the struct you are using to pass options
> such as "pad or not" does not suffice to hold your option data
> any more.

I've changed it in my recent version, see newer pathces, where i
changed it to reflect your suggestion.
Thanks for clearing that out. I had a confused conception about when
to use more than one DS.


-- 
-aft
