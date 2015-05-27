From: Eddi Linder <eddi@guardicore.com>
Subject: Re: REOUTE target extenstion
Date: Wed, 27 May 2015 14:56:04 +0300
Message-ID: <CADgXnSPkPdWdWcNJHrcv_9=oomWsE4ZfzoJZ3CTur=zW5LY9cQ@mail.gmail.com>
References: <CADgXnSPNQM2xq_pAs72ddDCX-8DCx=J6mr--J_jPdMUcQS-PZw@mail.gmail.com>
	<20150527113746.GA23992@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Florian Westphal <fw@strlen.de>, jengelh@inai.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:35813 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbbE0L4E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2015 07:56:04 -0400
Received: by iesa3 with SMTP id a3so11321357ies.2
        for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2015 04:56:04 -0700 (PDT)
In-Reply-To: <20150527113746.GA23992@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

TEE is for gateway redirections, which means the redirected device has
to have a configured ip, and to be reachable from the original device.
Florian, I didn't find the mirror target in the mainline documentation or code.
REROUTE redirection is more like the openvswitch output action, copy
the packet from one device into another.



On Wed, May 27, 2015 at 2:37 PM, Florian Westphal <fw@strlen.de> wrote:
> Eddi Linder <eddi@guardicore.com> wrote:
>> Hey,
>>
>> I am planning to write a "redirection" extension that based on a match
>> will copy the matched packet to other interfaces.
>> The extension should work both on input chains and output chains
>> (ingress and egress traffic), and will be able to copy the packet as
>> egress or ingress of the selected interface.
>
> Whats wrong with TEE target?
>
> We also have mirred action in tc to do packet mirroring and redirects.
