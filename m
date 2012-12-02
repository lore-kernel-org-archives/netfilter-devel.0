From: arif <aftnix@gmail.com>
Subject: Re: Target extension with nf_hooks
Date: Sun, 02 Dec 2012 16:58:13 +0600
Message-ID: <50BB3445.70706@gmail.com>
References: <CAGuaRCtEa2VGPb3-jYvuK9+t++L44xTeOm15xpsFXmzLHoui3g@mail.gmail.com> <alpine.LNX.2.01.1211111434430.6241@nerf07.vanv.qr> <CAGuaRCsgOhwaUf8Pn+gu=axd7O1M4tYPoBje_gMT+LmQzMeNOw@mail.gmail.com> <alpine.LNX.2.01.1211111802590.6241@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52100 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab2LBLAs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Dec 2012 06:00:48 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1Tf7GY-0008GZ-BK
	for netfilter-devel@vger.kernel.org; Sun, 02 Dec 2012 11:59:18 +0100
Received: from 103.23.169.14 ([103.23.169.14])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sun, 02 Dec 2012 11:59:18 +0100
Received: from aftnix by 103.23.169.14 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sun, 02 Dec 2012 11:59:18 +0100
In-Reply-To: <alpine.LNX.2.01.1211111802590.6241@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/11/2012 11:15 PM, Jan Engelhardt wrote:
>
> On Sunday 2012-11-11 15:47, Aft nix wrote:
>>
>> Thanks for the reply. Now mangle tables has this:
>>
>> include/uapi/linux/netfilter_ipv4.h:    NF_IP_PRI_MANGLE = -150,
>>
>> What i get from this list that which table will get priority.
>>
>> But i'm trying to know which function will be called first?
>
> The one with a lower numerical value.
> What is to happen when two hooks have the same priority value
> is unspecified.
>
>> But i'm still confused about which function (one registered with
>> struct xt_target , another registered with struct nf_hook_ops) will
>> get priority?
>
> Those are two very different things.
>
>> How does a table associated with different chains?

Thanks for the help. So my use case seems unspecified and can't be done.
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


