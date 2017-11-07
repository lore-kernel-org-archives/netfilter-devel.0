From: Taehee Yoo <ap420073@gmail.com>
Subject: Re: [PATCH] netfilter: nf_nat_snmp_basic: use asn1 decoder library
Date: Tue, 7 Nov 2017 19:47:07 +0900
Message-ID: <CAMArcTVjG6Z9vt+d3QNOuntj=9J5NwO17A279nUOr50hHgVDXA@mail.gmail.com>
References: <20171029123453.2267-1-ap420073@gmail.com> <20171106144402.GA10271@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Florian Westphal <fw@strlen.de>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:45173 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752791AbdKGKrI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Nov 2017 05:47:08 -0500
Received: by mail-qk0-f182.google.com with SMTP id c16so552859qke.2
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Nov 2017 02:47:08 -0800 (PST)
In-Reply-To: <20171106144402.GA10271@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2017-11-06 23:44 GMT+09:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Sun, Oct 29, 2017 at 09:34:53PM +0900, Taehee Yoo wrote:
>> The basic SNMP ALG parse snmp ASN.1 payload
>> however, since 2012 linux kernel provide ASN.1 decoder library.
>> If we use ASN.1 decoder in the /lib/asn1_decoder.c, we can remove
>> about 1000 line of ASN.1 parsing routine.
>>
>> To use asn1_decoder.c, we should write mib file(nf_nat_snmp_basic.asn1)
>> then /script/asn1_compiler.c makes *-asn1.c and *-asn1.h file
>> at the compiletime.(nf_nat_snmp_basic-asn1.c, nf_nat_snmp_basic-asn1.h)
>> The nf_nat_snmp_basic.asn1 is made by RFC1155, RFC1157, RFC1902, RFC1905,
>> RFC2578, RFC3416. of course that mib file supports only the basic SNMP ALG.
>>
>> Previous SNMP ALG mangles only first octet of IPv4 address.
>> but after this patch, the SNMP ALG mangles whole IPv4 Address.
>> And SNMPv3 is not supported.
>>
>> I tested with snmp commands such ans snmpd, snmpwalk, snmptrap.
>
> OK, something is missing here, I see no definition for
> nf_nat_snmp_basic_decoder.

I apologize for incomplete patch.
I forgot to add nf_nat_snmp_basic.asn1 file. so I will resend v2 patch.
Thank you for review!
