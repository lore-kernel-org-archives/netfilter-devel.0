From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset "contains" question
Date: Tue, 26 Jul 2011 11:55:40 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1107261151210.20945@blackhole.kfki.hu>
References: <4E2DED59.1030902@wildgooses.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:48455 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab1GZJzn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2011 05:55:43 -0400
In-Reply-To: <4E2DED59.1030902@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, 25 Jul 2011, Ed W wrote:

> Many thanks for ipset.  Quick question please: I'm implementing a
> captive portal and I have an ipset (CP) containing bitmap:ip,mac.  How
> should I best implement rules to:
> 
> - Drop packets from same IP, different MAC
> 
> I might be missing the obvious, but how do I query to match on IP, then
> drop IP with a mismatching MAC (in the bitmap ipset)? Can this be done
> without a second ipset tracking only IP?

At a first glance I'd allow packets from (IP, MAC) and drop everything 
else, i.e. (same IP, different MAC) and (different IP, same MAC), etc.

If you want to match the IP address only, too, then a single set is not 
sufficient, unfortunately.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
