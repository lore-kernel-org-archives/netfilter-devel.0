From: Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH v3 0/5]  ipset: add "inner" flag support
Date: Fri, 05 Jul 2013 21:33:32 +0100
Message-ID: <51D72D9B.9040003@googlemail.com>
References: <51CF5256.3010004@googlemail.com> <alpine.DEB.2.00.1307052001200.20246@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:49604 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3GEUdl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jul 2013 16:33:41 -0400
Received: by mail-we0-f171.google.com with SMTP id m46so2260128wev.16
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2013 13:33:40 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1307052001200.20246@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Jozsef Kadlecsik wrote:
> I have just noticed one single issue with your patches: the revision 
> bumping for the set types are missing.
>   
Interesting. I wasn't aware you've introduced this feature and by 
looking at the logs, this has been present since 6.14 - shame on me for 
not noticing it.

> So please extend the second patch with the type revisions incremented 
> (have a look at the hash:net type how the revision comments are kept)
> and add a userspace patch with the revisions bumped in userspace too (it's 
> fine to copy the most recent ones and increase the revisions, adjust the 
> descriptions).
In other words, something like:

kernel/net/netfilter/ip_set_*.c
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-#define IPSET_TYPE_REV_MAX    3 /* Counters support added */
+/*                             3    Counters support added */
+#define IPSET_TYPE_REV_MAX    4 /* Inner flag support added */

lib/ipset_*.c
~~~~~~~~~~~~~
copy the entire ipset_hash_netX struct, bump the ".revision" and adjust 
the ".description" fields?

Would that suffice?

Also, would you like me to modify my 3rd patch (which is where I've made 
the changes to all sets - in patch two I reimplemented the "internal" 
functions) and issue a separate one for all lib/ipset_*.c changes or 
would you like me to reissue the whole set of patches (1-6)?

>  That's all and then the patchset is ready for inclusion.
>   
Thanks.

