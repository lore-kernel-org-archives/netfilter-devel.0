From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] xtables-translate: Fix chain type when
 translating nat table
Date: Tue, 29 Nov 2016 23:01:43 +0100
Message-ID: <20161129220143.GD29033@salvia>
References: <20161128121416.27659-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46794 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753993AbcK2WBv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2016 17:01:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7D04C174D13
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 23:01:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C3F5DA38E
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 23:01:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 729E7DA385
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 23:01:48 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161128121416.27659-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 28, 2016 at 01:14:16PM +0100, Phil Sutter wrote:
> This makes the type of translated chains in nat table to be of type
> 'nat' instead of 'filter' which is incorrect.
> 
> Verified like so:
> 
> | $ iptables-restore-translate -f /dev/stdin <<EOF
> | *nat
> | :POSTROUTING ACCEPT [0:0]
> | [0:0] -A POSTROUTING -j MASQUERADE
> | COMMIT
> | EOF
> | # Translated by ./install/sbin/iptables-restore-translate v1.6.0 on Mon Nov 28 12:11:30 2016
> | add table ip nat
> | add chain ip nat POSTROUTING { type nat hook postrouting priority 0; policy accept; }
> | add rule ip nat POSTROUTING counter masquerade
> 
> Ditto for ip6tables-restore-translate.

Also applied, thanks.
