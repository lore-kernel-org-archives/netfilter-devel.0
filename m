From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: Constify option struct
Date: Mon, 27 Mar 2017 21:12:39 +0200
Message-ID: <20170327191239.GA18080@salvia>
References: <1490641815-12741-1-git-send-email-gs051095@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Gargi Sharma <gs051095@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44982 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751396AbdC0TMw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Mar 2017 15:12:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C6F40392E0B
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 21:12:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B93B3DA86C
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 21:12:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A1273DA725
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 21:12:46 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1490641815-12741-1-git-send-email-gs051095@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 28, 2017 at 12:40:15AM +0530, Gargi Sharma wrote:
> The struct  of the type option is only used to initialise a field
> inside the xtables_match struct and is not modified anywhere.
> Done using Coccinelle:
> 
> @r1 disable optional_qualifier@
> identifier s,i;
> position p;
> @@
> 
> static struct option i@p[] ={...};
> 
> @ok1@
> identifier r1.i;
> expression e;
> position p;
> @@
> e = i@p
> 
> @bad@
> position p != {r1.p,ok1.p};
> identifier r1.i;
> @@
> e@i@p
> 
> @depends on !bad disable optional_qualifier@
> identifier r1.i;
> @@
> static
> +const
> struct option i[] = { ... };

Applied, thanks.

You can probably have a look at ebtables.git, probably there are more
things to constify there.
