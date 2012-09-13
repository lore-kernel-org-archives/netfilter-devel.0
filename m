From: hdemir@metu.edu.tr
Subject: Re: Ipset Problem
Date: Thu, 13 Sep 2012 23:12:08 +0300
Message-ID: <efd86f46bf8b3fd78b796b99cfccea21.squirrel@sqrl.metu.edu.tr>
References: <5051EB6F.2050406@metu.edu.tr>
    <alpine.DEB.2.00.1209131649290.11289@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Lutfi ODUNCUOGLU" <lutfio@metu.edu.tr>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from frigya.general.services.metu.edu.tr ([144.122.145.140]:46195
	"EHLO frigya.general.services.metu.edu.tr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756092Ab2IMUV0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Sep 2012 16:21:26 -0400
In-Reply-To: <alpine.DEB.2.00.1209131649290.11289@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> On Thu, 13 Sep 2012, Lutfi ODUNCUOGLU wrote:
>
>> I have two iptables configuration, for inet4 and inet6. In order to stop
>> the
>> iptables;
>>
>> ipset flush
>> ipset destroy
>>
>> and for ip6tables
>>
>> ipset flush
>> ipset destroy
>
> Unnecessary, the sets are already flushed and destroyed above.

Why unnecessary? Can I need to only flush and destroy inet6 sets? If I can
define them separetly, why not? Mostly iptables and ip6tables are
different. They are handled separate. One can need to flush and destroy
them, I think.


thanks.

>
>> Can we make them just to flush and destroy inet6 or inet4? Is there any
>> way?
>
> "ipset flush" flushes all sets, and "ipset destroy" destroys all sets,
> both inet and inet6.
>
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics, Hungarian Academy of
> Sciences
>           H-1525 Budapest 114, POB. 49, Hungary
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


