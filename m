From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V3 0/5] netfilter: nf_nat_snmp_basic: use ASN.1 decoder
Date: Wed, 6 Dec 2017 10:06:59 +0100
Message-ID: <20171206090659.GA7437@salvia>
References: <20171119150559.18125-1-ap420073@gmail.com>
 <20171206081544.GA3861@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44944 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753669AbdLFJHD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Dec 2017 04:07:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 858D4C0B2C
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2017 10:07:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 764E6DA812
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2017 10:07:02 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171206081544.GA3861@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 06, 2017 at 09:15:44AM +0100, Pablo Neira Ayuso wrote:
> On Mon, Nov 20, 2017 at 12:05:54AM +0900, Taehee Yoo wrote:
> > The goal of this patch set are to use the ASN.1 decoder library
> > to parse SNMP ASN.1 payload.
> 
> Series applied, thanks.

I'm hitting this here:

net/ipv4/netfilter/nf_nat_snmp_basic.c:57:36: fatal error: nf_nat_snmp_basic-asn1.h: File or directory does not exist
