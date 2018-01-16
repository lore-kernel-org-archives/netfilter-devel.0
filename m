From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next v2] netfilter: ipv6: nf_defrag: Pass on packets
 to stack per RFC2460
Date: Tue, 16 Jan 2018 01:47:51 +0100
Message-ID: <20180116004751.qfg3uveq4pbbvtkk@salvia>
References: <1515803787-23838-1-git-send-email-subashab@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40214 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750796AbeAPAr7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jan 2018 19:47:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 63D9B53AA26
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2018 01:47:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 53331BAC30
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2018 01:47:57 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1515803787-23838-1-git-send-email-subashab@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 12, 2018 at 05:36:27PM -0700, Subash Abhinov Kasiviswanathan wrote:
> ipv6_defrag pulls network headers before fragment header. In case of
> an error, the netfilter layer is currently dropping these packets.
> This results in failure of some IPv6 standards tests which passed on
> older kernels due to the netfilter framework using cloning.
> 
> The test case run here is a check for ICMPv6 error message replies
> when some invalid IPv6 fragments are sent. This specific test case is
> listed in https://www.ipv6ready.org/docs/Core_Conformance_Latest.pdf
> in the Extension Header Processing Order section.
> 
> A packet with unrecognized option Type 11 is sent and the test expects
> an ICMP error in line with RFC2460 section 4.2 -
> 
> 11 - discard the packet and, only if the packet's Destination
>      Address was not a multicast address, send an ICMP Parameter
>      Problem, Code 2, message to the packet's Source Address,
>      pointing to the unrecognized Option Type.
> 
> Since netfilter layer now drops all invalid IPv6 frag packets, we no
> longer see the ICMP error message and fail the test case.
> 
> To fix this, save the transport header . If defrag is unable to process
> the packet due to RFC2460, restore the transport header and allow packet
> to be processed by stack. There is no change for other packet
> processing paths.
> 
> Tested by confirming that stack sends an ICMP error when it receives
> these packets. Also tested that fragmented ICMP pings succeed.

Applied, thanks Subash.
