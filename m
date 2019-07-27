Return-Path: <SRS0=WUGc=VY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D2B8C433FF
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Jul 2019 17:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBAEE2083B
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Jul 2019 17:24:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=fami-braun.de header.i=@fami-braun.de header.b="aiKrIvK+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387762AbfG0RYh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 27 Jul 2019 13:24:37 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.24]:12200 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387665AbfG0RYg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 Jul 2019 13:24:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1564248274;
        s=strato-dkim-0002; d=fami-braun.de;
        h=Message-ID:From:CC:To:Subject:References:In-Reply-To:Date:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=YJfohOXF55rbgcNHtpgJv0cFwxGRpaTgGzWoNbr4ylo=;
        b=aiKrIvK+/WJsTGUOILokRTpJgqVm+xvRO+Tj3NPusIuquRn60UfAi2KoUfH+8OjQWu
        q/bI04eo7N7oy9ecd7f6ORbo7OKPRdnvyKF5NPij1nAdjMjsFkeB8J13kVG8ehisb3wz
        HfBOU3Vet5g9kX+OgvKv/PILX3WXyHgUjtMLNavhan81428P5dDbOfmj4oIGBBTClcbv
        nJtj9yrFtX3Fboyqau02at+MS0e3VFUqmEe5NkpZtZSYG9Ia16AyCOj8YczBjxTrwr0y
        5ETPt17UjAJXu8iOEi+OEuwRPnAX8pbwFgQgvlDtSJvZlHjZKMAG49rOHFvLD88z0ZGv
        th/Q==
X-RZG-AUTH: ":P20JeEWkefDI1ODZs1HHtgV3eF0OpFsRaGIBEm4ljegySSvO7VhbcRIBGrxpcA5nVfJ6oTd1q41mDHe5HAM39FTUY78sxlCk0WBRHPgh9K7A"
X-RZG-CLASS-ID: mo00
Received: from dynamic.fami-braun.de
        by smtp.strato.de (RZmta 44.24 AUTH)
        with ESMTPSA id R034b8v6RHOY6uM
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Sat, 27 Jul 2019 19:24:34 +0200 (CEST)
Received: from dynamic.fami-braun.de (localhost [127.0.0.1])
        by dynamic.fami-braun.de (fami-braun.de) with ESMTP id DAB1D154160;
        Sat, 27 Jul 2019 19:24:33 +0200 (CEST)
Received: from [172.20.10.4] (ip-109-41-130-216.web.vodafone.de [109.41.130.216])
        by dynamic.fami-braun.de (fami-braun.de) with ESMTPSA id 2407415822D;
        Sat, 27 Jul 2019 19:24:26 +0200 (CEST)
Date:   Sat, 27 Jul 2019 19:24:24 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <20190715180639.5osmyxjg6b2r7db3@salvia>
References: <20190715165901.14441-1-michael-dev@fami-braun.de> <20190715180639.5osmyxjg6b2r7db3@salvia>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCHv2] Fix dumping vlan rules
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     netfilter-devel@vger.kernel.org, michael-dev@fami-braun.de
From:   michael-dev@fami-braun.de
Message-ID: <9B7A6B88-AA54-4F0C-8078-AEF49AA80EC5@fami-braun.de>
X-Virus-Scanned: clamav-milter 0.101.2 at gate
X-Virus-Status: Clean
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



Am 15=2E Juli 2019 20:06:39 MESZ schrieb Pablo Neira Ayuso <pablo@netfilte=
r=2Eorg>:
>> Given the following bridge rules:
>> 1=2E ip protocol icmp accept
>> 2=2E ether type vlan vlan type ip ip protocol icmp accept
>
>No testcase for #2?

The added testcase covers #2 due to the netlink dump check and thus is bas=
ically a synonym with respect to the netlink parser=2E

>
>So, what happens here is that:
>
>        #1 vlan type ip kills ether type vlan
>        #2 ip protocol icmp kills vlan type ip
>
>right?

Right

>> +		 */
>> +		if (dep->left->etype =3D=3D EXPR_PAYLOAD && dep->op =3D=3D OP_EQ &&
>> +		    expr->flags & EXPR_F_PROTOCOL &&
>> +		    expr->payload=2Ebase =3D=3D dep->left->payload=2Ebase)
>
>If the current expression is a key (EXPR_F_PROTOCOL expressions tells
>us what it comes in the upper layer) and base of such expression is
>the same as the dependency=2E
>
>I'd prefer this rule is restricted to vlan, and wait for more similar
>usecases before this rule can be generalized=2E
>
>OK?

I used nft list ruleset to generate /etc/nftables=2Econf=2E In case too fe=
w statements are killed, nftables=2Econf becomes a bit longer but it is sti=
ll correct and parseable although not minimal=2E In case too many statement=
s are killed, the semantic changes on next reboot or for review with all ki=
nds of implications=2E
Therefore killing to many statements seems critical too many, kill too few=
 only like a minor issue=2E I'd therefore prefer to take the risk of being =
overly broad here rathen than having incorrect information and thus not res=
trict this to vlan=2E

Stacked protocols like ipsec, ipip tunnel or vlan tend to have the same up=
per layer payload protocol, e=2Eg=2E udp in ip, udp in ipip or udp in esp/a=
h=2E Therefore killing protocol type statements for stacked protocols gener=
ally does not look safe to me, as the upper layer will not imply any stacke=
d protocol=2E

Regards,
M=2E Braun
