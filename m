From: Jack Ma <Jack.Ma@alliedtelesis.co.nz>
Subject: shift by n bits while performing '--restore-mark'
Date: Tue, 6 Feb 2018 23:46:07 +0000
Message-ID: <1517960766867.47573@alliedtelesis.co.nz>
References: <89a1d74339b14c6e813ccbea864c24e0@svr-chch-ex1.atlnz.lc>
 <20180116141712.GC15198@breakpoint.cc>
 <1516847646457.65736@alliedtelesis.co.nz>,<20180125062211.GE14192@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:42238 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753346AbeBFXqJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 18:46:09 -0500
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id E79258365B
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 12:46:07 +1300 (NZDT)
In-Reply-To: <20180125062211.GE14192@breakpoint.cc>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=0A=
Hi Florian,=0A=
=0A=
Our current condition is:=0A=
=0A=
1) only 0xfff00000 (three F available in skb->mark), but 0xfffff000 (five F=
 available in ct->mark)=0A=
=0A=
We wish to copy either 0xfff00000 or 0x00fff000 from ct->mark into skb->mar=
k,=0A=
=0A=
=0A=
What about '-j CONNMARK  --restore-mark --mask 0xfffff000 << 8 ( left shift=
 2 F)'=0A=
=0A=
This will result in skb->mark =3D ct->mark << 8=0A=
=0A=
if ct->mark =3D 0xabcde000, now skb->mark is changed to:  skb->mark =3D 0xc=
de00000.=0A=
=0A=
Does this make sense :) ?=0A=
=0A=
=0A=
Regards,=0A=
Jack=0A=
=0A=
=0A=
________________________________________=0A=
From: Florian Westphal <fw@strlen.de>=0A=
Sent: Thursday, January 25, 2018 7:22 PM=0A=
To: Jack Ma=0A=
Subject: Re: conntrack enhancement=0A=
=0A=
Jack Ma <Jack.Ma@alliedtelesis.co.nz> wrote:=0A=
> Hi Florian,=0A=
>=0A=
> Any comments? Please let me know if anything is unclear to you.=0A=
=0A=
It would be nice if you could show a pseudo-ruleset that uses=0A=
this proposed feature, save and restore rule should be enough.=0A=
=0A=
Just so I can see why existing mask support isn't sufficient for your=0A=
use case.=0A=
=0A=
Thanks,=0A=
Florian=0A=
