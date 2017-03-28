From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 2/4] netfilter: ipset: generalize netmask to support cidr
 and mask values
Date: Tue, 28 Mar 2017 20:28:54 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1703282010360.20521@blackhole.kfki.hu>
References: <1490120944-1770-1-git-send-email-johunt@akamai.com> <1490120944-1770-3-git-send-email-johunt@akamai.com> <alpine.DEB.2.11.1703272110580.16553@blackhole.kfki.hu> <e813c815-6803-6268-2bc0-cfe28f128093@akamai.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
To: Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:34122 "EHLO smtp0.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753517AbdC1S27 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Mar 2017 14:28:59 -0400
In-Reply-To: <e813c815-6803-6268-2bc0-cfe28f128093@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Josh,

On Tue, 28 Mar 2017, Josh Hunt wrote:

> > Overall, I like the feature and the patches. After reviewing I comment
> > only the parts where I believe some modifications are needed.
> 
> Thanks for the review. I'll go through this and send a v2 in the next 
> few days.

Thinking over it I understand better your approach: replace 
IPSET_ATTR_NETMASK with IPSET_ATTR_NETMASK_MASK completely and keeping the 
former for backward compatibility reasons only. What I propose is able to 
maintain syntax-compatibility in the sense that what is passed to the 
kernel as cidr/netmask can be saved from there in the same syntax.

The exemption from adding multiple entries from a range in the case of 
non-cidr value netmask must also be documented in the manpage. Maybe it'd 
be even better additionally to return an explicit error in such cases: 
thus it cannot lead to a misunderstanding from user point of view.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
