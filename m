From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 3rd revision] Add SELinux context support to AUDIT target
Date: Wed, 08 Jun 2011 19:04:04 +0100
Message-ID: <4DEFB994.1030309@googlemail.com>
References: <4DEDEB99.4070601@netfilter.org> <201106081049.48026.sgrubb@redhat.com> <4DEF9F77.1080406@googlemail.com> <201106081314.55947.sgrubb@redhat.com>
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
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45722 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1FHSEK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2011 14:04:10 -0400
Received: by wya21 with SMTP id 21so562261wya.19
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jun 2011 11:04:08 -0700 (PDT)
In-Reply-To: <201106081314.55947.sgrubb@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> It doesn't matter if its private. If its important enough to log to the audit system, 
> we can't let something like this slide.
>   
Oh, yes it does! For you may be it doesn't, but that doesn't necessarily 
mean that applies to everyone else.

>>> Besides, this numerical representation isn't reliable - these numbers
>>> are dynamic and can change - another reason why they should not be
>>> allowed to be present in the audit log. 
>>>       
>
> Doesn't matter.
Oh, yes it does! If you are content or used to putting heaps of useless 
and meaningless "data" in the audit logs (and lets be frank, that is 
what this number is to the admins or other people who will be looking at 
those logs), then you may wish to submit another patch to the 
netfilter-dev list for review with whatever takes your fancy in it, and 
see how far does that take you!

I won't be doing that as I am not at all convinced that the number you 
are asking me to add is anything more than a piece of useless junk!

>  Its the event that we want and all its attributes. If the label is not 
> correct, how else are we going to know?
This isn't a label! It is, for all intents and purposes, a random number 
which may have been used to point to something.

How many times would you like me, or other people on this list, to 
repeat that until there is a remote chance that you will finally get it?

>>> What happens if I make changes to my security policy and then run
>>> ausearch/aureport? 
>>>       
>
> Nothing.
>   
Absolute rubbish and what's worse is that you know it!

>>> I am either going to see different (wrong!) context reported if ausearch/aureport
>>> attempts to "convert" those numbers into SELinux context, or, I am
>>> going to see meaningless numbers. Either way, useless or misleading
>>> information is going to be reported and we don't want that, do we?
>>>       
>
> Yes, we do.
>   
You do what?! Put a complete rubbish in the audit logs? May be you do, 
but I don't.

Again, I am not contributing to something which places misleading and/or 
useless information in the audit logs. It is not desired and unless I am 
convinced otherwise, there is little chance of me altering my patch, so 
it stays as I originally submitted it.
