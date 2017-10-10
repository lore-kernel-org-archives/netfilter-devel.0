From: "Doddamadaiah, Abhijit (Nokia - IN/Bangalore)"
        <abhijit.doddamadaiah@nokia.com>
Subject: Support for attribute based deletion operation in nftables
Date: Tue, 10 Oct 2017 10:24:03 +0000
Message-ID: <VI1PR0701MB273655E25FAF498838F8D0A68F750@VI1PR0701MB2736.eurprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "M J, Pramoda (Nokia - IN/Bangalore)" <pramoda.m_j@nokia.com>,
        "Shukla, Ashutosh 1. (Nokia - IN/Bangalore)"
        <ashutosh.1.shukla@nokia.com>,
        "Priyadarshi, Amit 1. (Nokia - IN/Bangalore)"
        <amit.1.priyadarshi@nokia.com>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ve1eur01on0100.outbound.protection.outlook.com ([104.47.1.100]:21737
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751398AbdJJKYG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Oct 2017 06:24:06 -0400
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Iptables had the facility of deleting a rule using the same attribute set a=
s that which were used during its addition. In nftables, the deletion opera=
tion requires the "handle" parameter which is a numeric value assigned by t=
he kernel. In order to get the "handle" corresponding to a rule, it is nece=
ssary to list the chain with necessary option or dump the rules and impleme=
nt a parser to get the same. Any application using nftables to implement a =
firewall shall not be able to refer to the table every time when it needs t=
o delete a rule.

Is there any facility to get the handle (at this moment with the available =
version of nftables) without referring the table. The wiki page states that=
 the deletion operation based on attributes is under implementation. If so,=
 is there any time frame by which we can expect the support for the same in=
 nftables library. Request you to please respond to the same.

-Thanks & Regards
Abhjit

