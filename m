From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset suggestion, idle-timeout
Date: Mon, 21 Apr 2014 21:25:15 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1404212121400.17211@blackhole.kfki.hu>
References: <5354A37C.8080308@fremnet.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Shannon Wynter <freman@fremnet.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:41295 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235AbaDUTZI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Apr 2014 15:25:08 -0400
In-Reply-To: <5354A37C.8080308@fremnet.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 21 Apr 2014, Shannon Wynter wrote:

> It would essentially work like the regular timeout, removing the entry from
> the set but only if no matches on the entry for the duration of the timeout
> 
> eg:
> Add a match for 8.8.8.8 for 300 seconds.
> If there is a match on 8.8.8.8 at 250 seconds then the timer is reset.
> If there is no match on 8.8.8.8 for 300 then the entry is removed
> 
> I wouldn't mind having a look at this myself but don't really know the first

That's equivalent with "match and re-add the element", which can easily be 
achieved with a rule like:

... -m set --match-set .... -j SET --add-set ...

(or if you need multiple actions, then jump to a proper chain).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
