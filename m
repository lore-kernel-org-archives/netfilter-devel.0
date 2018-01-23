From: Jack Ma <Jack.Ma@alliedtelesis.co.nz>
Subject: Re: conntrack enhancement
Date: Tue, 23 Jan 2018 01:16:08 +0000
Message-ID: <1516670168566.10188@alliedtelesis.co.nz>
References: <89a1d74339b14c6e813ccbea864c24e0@svr-chch-ex1.atlnz.lc>,<20180116141712.GC15198@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:44690 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751285AbeAWBQL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jan 2018 20:16:11 -0500
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 118A583645
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 14:16:10 +1300 (NZDT)
In-Reply-To: <20180116141712.GC15198@breakpoint.cc>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

(Re-send this again including CC)=0A=
=0A=
Hi Florian,=0A=
=0A=
I suspect this is for -j CONNMARK  --restore-mark / --save-mark ?=0A=
=0A=
>> Yes, current thought is to shift bits when mark is restored.=0A=
=0A=
Something like=0A=
=0A=
skb->mark =3D ct->mark >> $lshift; ?=0A=
=0A=
>> Yes, we shift ct marks.=0A=
=0A=
I don't really understand how this is supposed to work.=0A=
Could you elaborate a bit?=0A=
=0A=
>> It's common to run out of fwmark, skb->mark first. This suggestion basic=
ally attempts to 'grab' certain bits from ct->mark,=0A=
      so we can restore the desired bits into skb->mark. Once skb is marked=
 correctly, we can easily achieve more versatile=0A=
      routing per skb. However, this solution is not going to be scalable i=
n the future. Currently, we still have enough bits in ct->mark=0A=
      left, but way less bits left in skb->mark (which have been occupied b=
y other features thats connectionless)...=0A=
=0A=
=0A=
Thanks,=0A=
=0A=
Jack=
