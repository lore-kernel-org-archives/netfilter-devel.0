From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/3] ebtables: Constify option struct
Date: Tue, 28 Mar 2017 14:22:51 +0200
Message-ID: <20170328122251.GA1100@salvia>
References: <cover.1490699407.git.gs051095@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Gargi Sharma <gs051095@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43860 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751856AbdC1MYV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Mar 2017 08:24:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 10D7DC1260
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Mar 2017 14:23:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 02C2EBAAA6
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Mar 2017 14:23:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D6D3ADA729
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Mar 2017 14:23:02 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <cover.1490699407.git.gs051095@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 28, 2017 at 04:57:48PM +0530, Gargi Sharma wrote:
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
> 
> Gargi Sharma (3):
>   ebtables: extensions: Constify option struct
>   ebtables: extensions: Constify option struct
>   ebtables: extensions: Constify option struct

Please, collapse this patches in one single.

They are part of the same logical update and...

>  extensions/ebt_802_3.c    | 2 +-
>  extensions/ebt_among.c    | 2 +-
>  extensions/ebt_arp.c      | 2 +-
>  extensions/ebt_arpreply.c | 2 +-
>  extensions/ebt_inat.c     | 4 ++--
>  extensions/ebt_ip.c       | 2 +-
>  extensions/ebt_limit.c    | 2 +-
>  extensions/ebt_log.c      | 2 +-
>  extensions/ebt_mark.c     | 2 +-
>  extensions/ebt_mark_m.c   | 2 +-
>  extensions/ebt_nat.c      | 4 ++--
>  extensions/ebt_nflog.c    | 2 +-
>  extensions/ebt_pkttype.c  | 2 +-
>  extensions/ebt_redirect.c | 2 +-
>  extensions/ebt_standard.c | 2 +-
>  extensions/ebt_stp.c      | 2 +-
>  extensions/ebt_ulog.c     | 2 +-
>  extensions/ebt_vlan.c     | 2 +-
>  18 files changed, 20 insertions(+), 20 deletions(-)

diffstat shows this update is rather small.
