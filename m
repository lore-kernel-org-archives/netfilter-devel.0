From: Jack Ma <Jack.Ma@alliedtelesis.co.nz>
Subject: Re: conntrack enhancement
Date: Thu, 25 Jan 2018 21:31:10 +0000
Message-ID: <1516915870809.26703@alliedtelesis.co.nz>
References: <89a1d74339b14c6e813ccbea864c24e0@svr-chch-ex1.atlnz.lc>
 <20180116141712.GC15198@breakpoint.cc>
 <1516847646457.65736@alliedtelesis.co.nz>,<20180125062211.GE14192@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:52125 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751187AbeAYVbN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jan 2018 16:31:13 -0500
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id B3EFB8365F
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jan 2018 10:31:11 +1300 (NZDT)
In-Reply-To: <20180125062211.GE14192@breakpoint.cc>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,=0A=
=0A=
=0A=
Lets start with iptables setting=0A=
=0A=
iptables -t mangle=0A=
=0A=
Chain EXAMPLE_MAIN=0A=
=0A=
pkts bytes target     prot opt in     out     source               destinat=
ion =0A=
3709K  204M MARK       all  --  any    any     anywhere             anywher=
e             MARK and 0xfffff=0A=
37  6952 CONNMARK   all  --  any    any     anywhere             anywhere  =
           CONNMARK restore mask 0xfff00000=0A=
0     0 MARK       udp  --  any    any     anywhere             anywhere   =
          match .... and MARK xset 0xabc00000/0xfff00000         =0A=
    5   308 CONNMARK   all  --  any    any     anywhere             anywher=
e             CONNMARK save mask 0xfff00000=0A=
=0A=
=0A=
For the first packet of 'a' flow we mark the packet with fwmark =3D ct->mar=
k.=0A=
=0A=
ip rule=0A=
=0A=
then direct traffic using such fwmark.=0A=
=0A=
250:    from all fwmark 0xabc lookup TABLE=0A=
=0A=
However, we also implemented firewall feature, packet inspection feature...=
. etc to use fwmark at the same time.=0A=
=0A=
which makes such 32 bit far more occupied than ct->mark (32)..=0A=
=0A=
Hopefully this can help!=0A=
=0A=
Please let me know if this confuses you..=0A=
=0A=
Thanks,=0A=
Jack=
