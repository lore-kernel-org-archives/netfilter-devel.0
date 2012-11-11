From: Aft nix <aftnix@gmail.com>
Subject: Re: Target extension with nf_hooks
Date: Sun, 11 Nov 2012 20:47:30 +0600
Message-ID: <CAGuaRCsgOhwaUf8Pn+gu=axd7O1M4tYPoBje_gMT+LmQzMeNOw@mail.gmail.com>
References: <CAGuaRCtEa2VGPb3-jYvuK9+t++L44xTeOm15xpsFXmzLHoui3g@mail.gmail.com>
	<alpine.LNX.2.01.1211111434430.6241@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57693 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2KKOra (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Nov 2012 09:47:30 -0500
Received: by mail-ie0-f174.google.com with SMTP id k13so7912190iea.19
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Nov 2012 06:47:30 -0800 (PST)
In-Reply-To: <alpine.LNX.2.01.1211111434430.6241@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 11, 2012 at 7:36 PM, Jan Engelhardt <jengelh@inai.de> wrote:
>
> On Sunday 2012-11-11 11:56, Aft nix wrote:
>>
>>static struct xt_target obsf_tg_reg __read_mostly = {
>>
>>        .name = "OBSF",
>>        .family = NFPROTO_UNSPEC,
>>        .target = obsf_tg,
>>        .checkentry = obsf_tg_check,
>>        .targetsize = sizeof(struct xt_OBSF_tginfo),
>>        .me = THIS_MODULE,
>>};
>>
>>static struct nf_hook_ops inward_obsf_ops __read_mostly = {
>>    .pf = NFPROTO_IPV4,
>>    .priority = 1,
>>    .hooknum = NF_INET_PRE_ROUTING,
>>    .hook = ibss_obsf_inward_begin,
>>};
>>
>>a) Between ibss_obsf_inward_begin() and obsf_tg() who will be called first?
>
> The filter,mangle,etc. tables all have a specific and different priority
> assigned (git grep NF_IP_PRI_ include/).

Hi jan,

Thanks for the reply. Now mangle tables has this:

include/uapi/linux/netfilter_ipv4.h:    NF_IP_PRI_MANGLE = -150,

What i get from this list that which table will get priority.

But i'm trying to know which function will be called first? I guess i
should build a demo module to test to see which one called first.

But i'm still confused about which function (one registered with
struct xt_target , another registered with struct nf_hook_ops) will
get priority?

How does a table associated with different chains?


--
-aft
