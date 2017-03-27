From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Outreachy kernel] [PATCH 0/4] Constify option structures
Date: Mon, 27 Mar 2017 20:49:40 +0200
Message-ID: <20170327184940.GA21804@salvia>
References: <cover.1490640256.git.gs051095@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.orgm,
        outreachy-kernel@googlegroups.com
To: Gargi Sharma <gs051095@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37770 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751294AbdC0SuO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Mar 2017 14:50:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AB88B392E05
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 20:49:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9D830DA848
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 20:49:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9142DDA86B
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 20:49:43 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <cover.1490640256.git.gs051095@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 28, 2017 at 12:15:26AM +0530, Gargi Sharma wrote:
> The struct option is generally used only to initialise
> fields inside certain structs and is not modified anywhere.
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

Please indicate what userspace tree in the subject, I guess this is
iptables.

And merge them all into one single patch, they are part of the same
logical change.

Thanks!
