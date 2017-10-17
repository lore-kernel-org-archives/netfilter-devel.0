From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Bitwise Out Of Bound Read in Netfilter Conntrack
Date: Tue, 17 Oct 2017 15:53:32 +0200
Message-ID: <20171017135332.GA22904@salvia>
References: <804512f5-786b-d4d0-bc8e-299c5c2683bf@x41-dsec.de>
 <20171012000346.GE26835@breakpoint.cc>
 <732a5fa7-1ccc-24f4-862c-18ff61b0fabb@x41-dsec.de>
 <20171017130917.GA21110@salvia>
 <f3b8d5d7-cdb9-e357-899d-adbcb0401bc0@x41-dsec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57168 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754945AbdJQNxi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 09:53:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E561E5230B
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 15:53:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CC1D778438
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 15:53:36 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <f3b8d5d7-cdb9-e357-899d-adbcb0401bc0@x41-dsec.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 17, 2017 at 03:48:13PM +0200, Eric Sesterhenn wrote:
> Hello Pablo,
> 
> they fix different issues, therefore both should
> be applied.

OK, thanks for explaining. Let me get back to this asap.
