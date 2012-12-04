From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Target extension with nf_hooks
Date: Tue, 4 Dec 2012 19:17:58 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1212041917430.18665@nerf07.vanv.qr>
References: <CAGuaRCtEa2VGPb3-jYvuK9+t++L44xTeOm15xpsFXmzLHoui3g@mail.gmail.com> <alpine.LNX.2.01.1211111434430.6241@nerf07.vanv.qr> <CAGuaRCsgOhwaUf8Pn+gu=axd7O1M4tYPoBje_gMT+LmQzMeNOw@mail.gmail.com> <alpine.LNX.2.01.1211111802590.6241@nerf07.vanv.qr>
 <50BB3445.70706@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: arif <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:51774 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab2LDSSE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2012 13:18:04 -0500
In-Reply-To: <50BB3445.70706@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2012-12-02 11:58, arif wrote:
>>
>>> But i'm still confused about which function (one registered with
>>> struct xt_target , another registered with struct nf_hook_ops) will
>>> get priority?
>>
>> Those are two very different things.
>>
>>> How does a table associated with different chains?
>
> Thanks for the help. So my use case seems unspecified and can't be done.

Well I don't know, you never said anything about your case.
