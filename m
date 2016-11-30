From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v4] datatype: Replace getnameinfo() by internal
 lookup table
Date: Wed, 30 Nov 2016 20:11:54 +0100
Message-ID: <20161130191154.GA9121@salvia>
References: <20161130011236.GA11108@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58930 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758111AbcK3TL7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2016 14:11:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B31EE12A68E
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2016 20:11:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A04D9DA801
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2016 20:11:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9852EDA841
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2016 20:11:55 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161130011236.GA11108@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 29, 2016 at 11:12:37PM -0200, Elise Lennion wrote:
> To avoid exceeding the inputs number limit of the flex scanner used,
> when calling getnameinfo() in inet_service_type_print().
> 
> The new symbol_table was associated with inet_service_type, to enable
> listing all pre-defined services using nft command line tool.
> 
> The listed services are all well-known and registered ports of my
> local /etc/services file, from Ubuntu 16.04. Service numbers are
> converted to respect network byte order.

Applied, thanks Elise.

BTW, we have to fix "nft describe", look:

 # nft describe tcp dport
 payload expression, datatype inet_service (internet network service) (basetype integer), 16 bits

 pre-defined symbolic constants:
        tcpmux                          0x0100
        echo                            0x0700
        ...

The user relies on nft describe to know what datatype and possible
values are possible for a given selector. In this case, they are
expressed in network byte order.

The problems seems to be in expr_describe(), the expression already
provides the byteorder, so I guess symbol_table_print() needs to get
this byteorder as parameter to swap bytes when required.

This is a fix, so I would appreciate if you focus on this, thanks!
