From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: IP sets: Suggestion: additional value match
Date: Mon, 3 Aug 2015 11:13:39 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1508031058510.26858@blackhole.kfki.hu>
References: <55BA42E9.70808@aon.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Rudolf_AT <Rudolf_AT.nf@aon.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:57673 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbbHCJNG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Aug 2015 05:13:06 -0400
In-Reply-To: <55BA42E9.70808@aon.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Thu, 30 Jul 2015, Rudolf_AT wrote:

> when working with IP sets, I came up with the following idea:
> adding a value match:
> 
>  -j SET --add-set set1 flag[,flag]=value
>  --match-set set1 flag[,flag]=value
>
> Where value is an integer which is set in the added list element of the 
> SET target. The value does not change the dimension of the list. The 
> match is true only if the given value is equal to the value stored in 
> the found element.
> 
> Optionally adding an arbitrary value could help using IP sets in even 
> more ways than now, for example easily tracking packets independently of 
> other extensions or matches.
> 
> For example, instead of using three sets to distinguish between three
> different states:
>  -j SET --add-set state1set src,dst,dst
>  -j SET --del-set state2set src,dst,dst
>  -j SET --del-set state3set src,dst,dst
> one would write:
>  -j SET --add-set aset1 src,dst,dst=<integer>
> Where <integer> resembles state1|state2|state3 then.
>
> Maybe you can think of more uses for this feature.
> As a further enhancement bit operators might be useful, too.

The stored value is not a dimension-like parameter, so it should not be 
denoted/matched/updated as a dimension related one.

As far as I see it's quite similar to the "connmark/CONNMARK" match 
and target. Why cannot that simply be used?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
