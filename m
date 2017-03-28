From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 2/4] netfilter: ipset: generalize netmask to support cidr
 and mask values
Date: Tue, 28 Mar 2017 22:54:00 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1703282252520.20934@blackhole.kfki.hu>
References: <1490120944-1770-1-git-send-email-johunt@akamai.com> <1490120944-1770-3-git-send-email-johunt@akamai.com> <alpine.DEB.2.11.1703272110580.16553@blackhole.kfki.hu> <e813c815-6803-6268-2bc0-cfe28f128093@akamai.com> <alpine.DEB.2.11.1703282010360.20521@blackhole.kfki.hu>
 <c9e1322d-4436-cf3d-0780-e37c18228e2f@akamai.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
To: Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:60990 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751882AbdC1UyG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Mar 2017 16:54:06 -0400
In-Reply-To: <c9e1322d-4436-cf3d-0780-e37c18228e2f@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 28 Mar 2017, Josh Hunt wrote:

> > Thinking over it I understand better your approach: replace 
> > IPSET_ATTR_NETMASK with IPSET_ATTR_NETMASK_MASK completely and keeping 
> > the former for backward compatibility reasons only. What I propose is 
> > able to maintain syntax-compatibility in the sense that what is passed 
> > to the kernel as cidr/netmask can be saved from there in the same 
> > syntax.
> 
> I have not gone through all of your comments yet, but my intention was 
> to make sure that if cidrs are used they are presented the same way they 
> are today (prior to my patches.) If a user uses the new full netmask 
> support then that is what is shown. This way we stay consistent with 
> whatever the user inputs at create time.

Yes, you are right, some conversion confused me.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
