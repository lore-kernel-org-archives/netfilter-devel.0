From: Aft nix <aftnix@gmail.com>
Subject: Re: [PATCH] New Target Extension OBSF
Date: Tue, 18 Sep 2012 13:46:26 +0600
Message-ID: <CAGuaRCvVhf8+ZjvSG3NBnSXH1PStb3Di6fnydKVgXrLYhKdV1w@mail.gmail.com>
References: <1347895271.27332.1.camel@kernel-host-rh6>
	<alpine.LNX.2.01.1209180120530.22227@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51332 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab2IRHq1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Sep 2012 03:46:27 -0400
Received: by ieak13 with SMTP id k13so1846608iea.19
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Sep 2012 00:46:26 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1209180120530.22227@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 18, 2012 at 6:04 AM, Jan Engelhardt <jengelh@inai.de> wrote:
>
> On Monday 2012-09-17 17:21, aft wrote:
>>
>>1) it encrypts UDP traffic.
>>2) it adds false bytes(padding).
>>
>>Its purpose is to escape smarter DPIs which blocks certain kinds of
>>packets by several heuristic methods.
>
> But then why not use IPsec (udpencap), OpenVPN, or something?
> After all, you do already need a cooperating peer to decrypt
> your traffic, and hence might as well pick a _standardized_ solution.
>

The client does not support IPsec.

> If all you want is evading some DPI gateways, I guess even the
> lowly XOR non-encryption scheme will sufficiently work.
>

XOR used to work, but DPIs recently started detecting XORed packets.

>>+static struct xt_target obsf_tg_reg[] __read_mostly = {
>>+      {
>>+              .name = "OBSF",
>>+              .family = NFPROTO_UNSPEC,
>>+              .target = obsf_tg,
>>+              .checkentry = obsf_tg_check,
>>+              .targetsize = sizeof(struct xt_OBSF_tginfo),
>>+              .me = THIS_MODULE,
>>+      },
>>+      {
>>+              .name = "OBSF",
>>+              .revision = 1,
>>+              .family = NFPROTO_UNSPEC,
>>+              .target = obsf_tg_v1,
>>+              .targetsize = sizeof(struct xt_OBSF_tginfo_v1),
>>+              .checkentry = obsf_tg_check_v1,
>>+              .me = THIS_MODULE,
>>+      },
>>+};
>
> There is no need to use two revisions.
>

Well, i thought there are times when you will not inject false bytes,
just encryption will suffices. That's why i've made
Two versions. When to make two versions is not really clear to me.

My idea was, a feature will always available, and another feature will
be available on demand, So better divide it in two versions.

I will change it and post the patch.

cheers.


-- 
-aft
