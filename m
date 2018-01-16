From: Jack Ma <Jack.Ma@alliedtelesis.co.nz>
Subject: conntrack enhancement
Date: Tue, 16 Jan 2018 02:26:45 +0000
Message-ID: <89a1d74339b14c6e813ccbea864c24e0@svr-chch-ex1.atlnz.lc>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:34127 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751062AbeAPC0w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jan 2018 21:26:52 -0500
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id ADBBB86CE8
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2018 15:26:50 +1300 (NZDT)
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=0A=
Hi there,=0A=
=0A=
I am planing to add new user option to allow connmark to be shifted to enab=
le more advanced routing options.=0A=
=0A=
Currently, it might be something like:=0A=
=0A=
Conntrack parameters and options:=0A=
 =0A=
-sl, --shift-left bits                      shift mark by n bit to the left=
=0A=
-sr, --shift-right bits                    shift mark by n bit to the right=
.=0A=
=0A=
We run out of nfmark (skb->mark) in our systems due to increasing number of=
 routes we are supporting.=0A=
=0A=
One common user-case:=0A=
=0A=
Using connmark to direct traffic via ip rule onto different route tables.=
=0A=
=0A=
But the the first packet of this flow needs to be per-inspected by the IP-t=
ables first to be marked with an ID (Route number ID in our case.).=0A=
=0A=
If we can have "SHIFT" operation working in conntrack, we would be able to =
support much more numbers of 'ID'.=0A=
=0A=
I wounder if this "SHIFT" idea can be considered to be accepted by upstream=
 ?=0A=
=0A=
Thanks,=0A=
Jack =
