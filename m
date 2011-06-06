From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 2nd revision] Add SELinux context support to AUDIT target
Date: Mon, 06 Jun 2011 14:10:48 +0100
Message-ID: <4DECD1D8.60804@googlemail.com>
References: <4DDE9194.4030303@netfilter.org> <201106060830.52644.sgrubb@redhat.com> <4DECCB27.6040706@googlemail.com> <201106060853.57940.sgrubb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-audit@redhat.com, netfilter-devel@vger.kernel.org,
	Thomas Graf <tgraf@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Eric Paris <eparis@parisplace.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Steve Grubb <sgrubb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61526 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab1FFNLA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:11:00 -0400
Received: by wwa36 with SMTP id 36so3780483wwa.1
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jun 2011 06:10:59 -0700 (PDT)
In-Reply-To: <201106060853.57940.sgrubb@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Exactly my point. There is no leak if its text or numeric.
>   
No, there is no leak if it is a text, but there *is* a leak if it is a 
numeric. I think I've made that quite clear.

>> As for exposing the (internal) numerical representation of the secctx - this was
>> discussed previously and the approach you are suggesting was dropped. To quote
>> Eric on this very issue "[It] exports the internal secid to userspace.
>> These are dynamic, can change on lsm changes, and have no meaning in
>> userspace. We should instead be sending lsm contexts to userspace
>> instead.".
>>     
>
> Doesn't matter. The requirements of the protection profiles say to log the object's 
> label.
> It does not care if its text or numeric. It also does not say sometimes or only 
> when its convenient. :)
Again, I disagree. Logging the internal numerical representation of 
secctx is, as I have already stated about 3 times by now, exposing 
internal (private-to-the-kernel-only) information to userspace. That 
cannot be allowed.

Besides, this numerical representation isn't reliable - these numbers 
are dynamic and can change - another reason why they should not be 
allowed to be present in the audit log. What happens if I make changes 
to my security policy and then run ausearch/aureport? I am either going 
to see different (wrong!) context reported if ausearch/aureport attempts 
to "convert" those numbers into SELinux context, or, I am going to see 
meaningless numbers. Either way, useless or misleading information is 
going to be reported and we don't want that, do we?

>   Its either important enough to log even if text conversion 
> fails or its not important enough to log at all.
>   
That is exactly what the current patch does - if secctx is present (and 
retrievable) it is logged, if not, then it isn't. Quite simple really.
