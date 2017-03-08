From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 2/2] libxtables: pass AI_ADDRCONFIG flag to
 getaddrinfo()
Date: Wed, 8 Mar 2017 15:00:06 +0100
Message-ID: <20170308140006.GA11040@salvia>
References: <1488978970-30802-1-git-send-email-pablo@netfilter.org>
 <1488978970-30802-2-git-send-email-pablo@netfilter.org>
 <alpine.LSU.2.20.1703081453420.4389@n3.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, alexander@alemayhu.com
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45704 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753624AbdCHOBG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 09:01:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5786C1AEA63
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 15:00:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 40259DA80C
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 15:00:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D6FDBDA7FA
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 15:00:15 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1703081453420.4389@n3.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 08, 2017 at 02:56:24PM +0100, Jan Engelhardt wrote:
> 
> On Wednesday 2017-03-08 14:16, Pablo Neira Ayuso wrote:
> >
> >If hints.ai_flags includes the AI_ADDRCONFIG flag, then IPv4 addresses
> >are returned in the list pointed to by res only if the local system has
> >at least one IPv4 address configured, and IPv6 addresses are only
> >returned if the local system has at least one IPv6 address configured.
> 
> But even if a system has no IPv4 address - think of a bridge -, you may
> want to resolve an `iptables -A FORWARD -s ... ` request.

Right, the br_netfilter Frankenstein needs this. Will make a second
shot at this.
