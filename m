From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: set pktinfo->thoff at AH header
 if found
Date: Sat, 4 Mar 2017 23:58:17 +0100
Message-ID: <20170304225817.GA1023@salvia>
References: <1488653627-4815-1-git-send-email-pablo@netfilter.org>
 <20170304194342.GA6457@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, phil@nwl.cc
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36072 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752186AbdCDW6Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Mar 2017 17:58:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2130896EDF
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Mar 2017 23:58:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 114D6DA795
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Mar 2017 23:58:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0DB66DA7E0
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Mar 2017 23:58:19 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170304194342.GA6457@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 04, 2017 at 08:43:42PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Phil Sutter reports that IPv6 AH header matching is broken. From
> > userspace, nft generates bytecode that expects to find the AH header at
> > NFT_PAYLOAD_TRANSPORT_HEADER both for IPv4 and IPv6. However,
> > pktinfo->thoff is set to the inner header after the AH header in IPv6,
> > while in IPv4 pktinfo->thoff points to the AH header indeed. This
> > behaviour is inconsistent. This patch fixes this problem by updating
> > ipv6_find_hdr() to get the IP6_FH_F_AUTH flag so this function stops at
> > the AH header, so both IPv4 and IPv6 pktinfo->thoff point to the AH
> > header.
> 
> This looks wrong.  We need to search until we find a l4 header,
> after this patch "tcp dort 22" won't match anymore if an AH header
> exists.

Look Florian:

# nft --debug=netlink add rule inet x y tcp dport 22 counter
inet x y 
  [ meta load l4proto => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 2b @ transport header + 2 => reg 1 ]
  [ cmp eq reg 1 0x00001600 ]
  [ counter pkts 0 bytes 0 ]

<cmdline>:1:1-39: Error: Could not process rule: No such file or directory

If we leave things the way they are:

1) A packet that looks like IPv4 + AH + TCP dport 22 will match.
2) A packet that looks like IPv6 + AH + TCP dport 22 will *not* match.

If you really want to keep this inconsistent behaviour around, I let
you inaugurate the errata section of the nft manpage ;-)

Seriously, I think it's better if we just fix this and focus on
designing a way to match at inner headers if you really need to match
on tcp ports encapsulated in ah traffic.
