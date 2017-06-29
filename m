From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nft: make raw payloads work
Date: Thu, 29 Jun 2017 18:18:40 +0200
Message-ID: <20170629161840.GA6789@salvia>
References: <1498036020-22214-1-git-send-email-l@libres.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laurent Fasnacht <l@libres.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48458 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751690AbdF2QSx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Jun 2017 12:18:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C9A769B80F
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jun 2017 18:18:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F4B3CFDF4
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jun 2017 18:18:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E2241CFDE6
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jun 2017 18:18:33 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1498036020-22214-1-git-send-email-l@libres.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Laurent,

On Wed, Jun 21, 2017 at 11:07:00AM +0200, Laurent Fasnacht wrote:
> In nftables, there is a rather (IMO) undocumented feature, raw payloads.
> 
> It would be useful both for development and to quickly extend nftables for corner cases.
> 
> Unfortunately, it is broken in current master (syntax is not consistent between print and parse,
> and any practical usage doesn't work).
> 
> This patch defines a new syntax, and makes it usable in practice:
> 
> @<protocol>,<base>,<data type>,<offset>,<length>
> 
> Example (rewrite arp packet target hardware address if target protocol address matches a given address):
> 
> meta iif enp2s0 arp ptype 0x0800 arp htype 1 arp hlen 6 arp plen 4 @arp,nh,ipv4_addr,192,32 192.168.143.16 @arp,nh,ether_addr,144,48 set 11:22:33:44:55:66 accept;

One thing related to this example: Would you send a patch to extend
the arp family to match sender/target fields in the header? We only
support ARP IPv4, so we can assume the header is "fixed size" for the
offset layout definitions. See src/proto.c, have a look at the arp
protocol definition.

Regarding raw protocol matching. Depending on the datatype, we may not
need the size. I mean, in case of the ipv4_addr datatype, this is
already 4 bytes. For (the generic) integer type fields, we need this
size indeed.

So I think we should allow two different syntax, one with size, and
another with no size. If you select a datatype with a fixed size, then
bail out during the parser/evaluation phase.

Something else: If the user specifies a raw expression that matches a
protocol field that is already defined by nft, this should
automatically translate this to the native nft representation.

It would be also great if you could add a bit of tests for the
tests/py infrastructure, or at least, document the bunch of examples
you have used to test this.

Thanks!
