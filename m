From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: IPSet target SET subnet options
Date: Sat, 27 Jun 2015 23:46:49 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1506272345390.12398@blackhole.kfki.hu>
References: <558EB6AF.5090402@oonux.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: WaaX <waax@oonux.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:50929 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbbF0Vql (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Jun 2015 17:46:41 -0400
In-Reply-To: <558EB6AF.5090402@oonux.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 27 Jun 2015, WaaX wrote:

> I hve explored the manual of SETtarget:
> 
>      SET target options:
> --add-set name flags [--exist] [--timeout n]
> --del-set name flags
>          add/del src/dst IP/port from/to named sets,
> where flags are the comma separated list of
> 'src' and 'dst' specifications.
> 
> I can not find solution for add a subnet mask to a hash:net with the target.

It is documented in the ipset manpage:

   hash:net
       ....

       When  adding/deleting IP addresses  to the set  by  the  SET  netfilter
       target,  it   will   be added/deleted by the most specific prefix which
       can be found in  the set, or by the host prefix value  if  the  set  is
       empty.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
