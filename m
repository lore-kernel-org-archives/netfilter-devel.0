Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B88F8C433DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Mar 2021 06:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BC7564F04
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Mar 2021 06:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhCRGiw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Mar 2021 02:38:52 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:60871 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbhCRGio (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Mar 2021 02:38:44 -0400
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 85B5D891AC
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Mar 2021 19:38:42 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1616049522;
        bh=MRTpP2Cz3tdoRBoNA2N9GJPxNhMZ5KXFRNVDDzmMyvw=;
        h=From:To:Subject:Date;
        b=IvJXfK2UeYE9qOD+fkDjIpRfIEalV89kBx7Q0kNmbZVM/RLZMzeYF0jX2zH8RFb0G
         7CiJQE8tMAd+L5B+/6cIHjwpCte3eNgvGH7UwHcuKcs84i9OPV+rII5TvMLrumrFY7
         U/gd/i6pNThu0vNVIFP8WiDO8LMcjy9uj71AOcj5JnJPUynvr8x0fWnGl4RM5louNF
         jBVX7Zd0gDta4mSmdbZPnrMCgR2V4rQjzhLiG2e88U8/Er+fhjFRNg+F0DS/2T2W6K
         b97l1+KnBi2jRTndOLKkF30xwqySI+5Pao1MTo0+tN6yCccF4Ezrfho7M2vAX3eTjy
         fIAD9cSjX44Ow==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6052f5720000>; Thu, 18 Mar 2021 19:38:42 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Thu, 18 Mar 2021 19:38:42 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.012; Thu, 18 Mar 2021 19:38:42 +1300
From:   Luuk Paulussen <Luuk.Paulussen@alliedtelesis.co.nz>
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Bug when updating ICMP flows using conntrack tools
Thread-Topic: Bug when updating ICMP flows using conntrack tools
Thread-Index: AQHXG7k7k74eLq21kkORPdIQT/E1TQ==
Date:   Thu, 18 Mar 2021 06:38:41 +0000
Message-ID: <1616049521015.25557@alliedtelesis.co.nz>
Accept-Language: en-NZ, en-US
Content-Language: en-NZ
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=GfppYjfL c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=8nJEP1OIZ-IA:10 a=dESyimp9J3IA:10 a=-0oH3AFOhN1E7VtuXv8A:9 a=wPNLvfGTeEIA:10
X-SEG-SpamProfiler-Score: 0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,=0A=
=0A=
We recently upgraded the version of conntrack-tools and libnetfilter-conntr=
ack that we are using and have found a bug when using conntrack to update I=
CMP flows. I've tracked down where the bug is occurring, but am looking for=
 some guidance on the preferred way to fix it.=0A=
=0A=
E.g. Doing the following when there are icmp flows present has no effect on=
 ICMP flows:=0A=
conntrack -f ipv4 -U --mark=3D1=0A=
=0A=
In conntrack-tools in conntrack.c in update_cb, the ORIG data and META data=
 are copied, but not the REPL data. This has been this way for quite some t=
ime.=0A=
nfct_copy(tmp, ct, NFCT_CP_ORIG);=0A=
nfct_copy(tmp, obj, NFCT_CP_META);=0A=
=0A=
However, in libnetfilter-conntrack the way that the message is built has be=
en changed, and in nfct_nlmsg_build, the check about whether to build the R=
EPL tuple has been extended to include=0A=
test_bit(ATTR_ICMP_TYPE, ct->head.set) ||=0A=
test_bit(ATTR_ICMP_CODE, ct->head.set) ||=0A=
test_bit(ATTR_ICMP_ID, ct->head.set)=0A=
=0A=
In the old building functions, these bits weren't present, so it wouldn't t=
ry to build the REPL tuple, so everything worked. However, now it tries to =
build the REPL tuple, and because none of the REPL data is present, buildin=
g the tuple fails and it errors out without sending the request to the kern=
el.=0A=
=0A=
My question is whether it is better to remove the checks in libnetfilter-co=
nntrack or add the copy of the REPL data in conntrack tools.=0A=
=0A=
Upgraded:=0A=
libnetfilter-conntrack from 1.0.6 to 1.0.8=0A=
conntrack-tools from 1.4.4 to 1.4.6=0A=
=0A=
Kind regards,=0A=
Luuk=
