From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC nf-next PATCH] netfilter: nf_conntrack_proto_tcp: propagate
 IP_CT_TCP_FLAG_BE_LIBERAL
Date: Thu, 20 Oct 2016 20:14:24 +0200
Message-ID: <20161020181424.GA10898@salvia>
References: <147695370184.31999.2434286995020619745.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, mat999@gmail.com
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38748 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752894AbcJTSO3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Oct 2016 14:14:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B5A5F9D33B
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 20:14:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A39CDDA816
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 20:14:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3594EDA846
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 20:14:25 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <147695370184.31999.2434286995020619745.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 20, 2016 at 11:00:49AM +0200, Arturo Borrero Gonzalez wrote:
> According to Mathew Heard, the IP_CT_TCP_FLAG_BE_LIBERAL
> is not being propagated properly while using userspace conntrackd to
> replicate connections states in a firewall cluster.
> 
> This change modifies the behaviour of the engine to always be liberal in
> the reply direction if we were liberal in the original direction as well.
> 
> More info in the Netfilter bugzilla:
>  https://bugzilla.netfilter.org/show_bug.cgi?id=1087
> 
> Suggested-by: Mathew Heard <mat999@gmail.com>
> Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
> ---
> RFC: I don't fully understand this patch. Specifically, I don't understand
> why this can't be done from userspace, in conntrackd, when creating/updating
> synced conntracks. We could just set the new/updated conntrack with the flags
> we want, don't we?
> 
> Also, I don't fully understand the consecuences of doing this flags change
> in the middle of tcp_packet().
> 
> So, please, review the patch and give us comments.

There is a 'TCPWindowTracking' option that you can set on from the
configuration file.

Is that probably what Mathew needs?
