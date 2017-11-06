From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_nat_snmp_basic: use asn1 decoder library
Date: Mon, 6 Nov 2017 15:44:02 +0100
Message-ID: <20171106144402.GA10271@salvia>
References: <20171029123453.2267-1-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56694 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753584AbdKFOoO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2017 09:44:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E302B1B8401
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 15:44:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D3A41BAC34
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 15:44:12 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171029123453.2267-1-ap420073@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 29, 2017 at 09:34:53PM +0900, Taehee Yoo wrote:
> The basic SNMP ALG parse snmp ASN.1 payload
> however, since 2012 linux kernel provide ASN.1 decoder library.
> If we use ASN.1 decoder in the /lib/asn1_decoder.c, we can remove
> about 1000 line of ASN.1 parsing routine.
> 
> To use asn1_decoder.c, we should write mib file(nf_nat_snmp_basic.asn1)
> then /script/asn1_compiler.c makes *-asn1.c and *-asn1.h file
> at the compiletime.(nf_nat_snmp_basic-asn1.c, nf_nat_snmp_basic-asn1.h)
> The nf_nat_snmp_basic.asn1 is made by RFC1155, RFC1157, RFC1902, RFC1905,
> RFC2578, RFC3416. of course that mib file supports only the basic SNMP ALG.
> 
> Previous SNMP ALG mangles only first octet of IPv4 address.
> but after this patch, the SNMP ALG mangles whole IPv4 Address.
> And SNMPv3 is not supported.
> 
> I tested with snmp commands such ans snmpd, snmpwalk, snmptrap.

OK, something is missing here, I see no definition for
nf_nat_snmp_basic_decoder.
