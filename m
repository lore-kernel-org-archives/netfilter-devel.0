From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 3rd revision] Add SELinux context support to AUDIT target
Date: Wed, 08 Jun 2011 17:12:39 +0100
Message-ID: <4DEF9F77.1080406@googlemail.com>
References: <4DEDEB99.4070601@netfilter.org> <4DEDFE43.5060402@googlemail.com> <201106081049.48026.sgrubb@redhat.com>
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
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57423 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab1FHQMv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2011 12:12:51 -0400
Received: by wya21 with SMTP id 21so476075wya.19
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jun 2011 09:12:50 -0700 (PDT)
In-Reply-To: <201106081049.48026.sgrubb@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>




Mr Dash Four wrote:
> Logging the internal numerical representation of secctx is, as I have 
> already stated about 3 times by now, exposing internal 
> (private-to-the-kernel-only) information to userspace. That cannot be 
> allowed.
>
> Besides, this numerical representation isn't reliable - these numbers 
> are dynamic and can change - another reason why they should not be 
> allowed to be present in the audit log. What happens if I make changes 
> to my security policy and then run ausearch/aureport? I am either 
> going to see different (wrong!) context reported if ausearch/aureport 
> attempts to "convert" those numbers into SELinux context, or, I am 
> going to see meaningless numbers. Either way, useless or misleading 
> information is going to be reported and we don't want that, do we?

> else
> 	audit_log_format(ab, " osid=%u", skb->secmark);
>
> _All_  audit code records the number on a failed conversion.
>   
I am assuming you haven't read the above. Show me one good reason why I 
should alter my patch to include that abomination of yours?
