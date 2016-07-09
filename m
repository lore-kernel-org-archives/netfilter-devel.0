From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v4 3/3] src: add xt compat support
Date: Sat, 9 Jul 2016 13:39:20 +0200
Message-ID: <20160709113920.GB1357@salvia>
References: <20160709102454.2978-1-pablombg@gmail.com>
 <20160709102454.2978-3-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45539 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbcGILj2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Jul 2016 07:39:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C354BC9EC5
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Jul 2016 13:39:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B52056449F
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Jul 2016 13:39:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B763A9EBAE
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Jul 2016 13:39:21 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160709102454.2978-3-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 09, 2016 at 12:24:54PM +0200, Pablo M. Bermudo Garay wrote:
> From: Pablo Neira <pablo@netfilter.org>
> 
> At compilation time, you have to pass this option.
> 
>   # ./configure --with-xtables
> 
> And libxtables needs to be installed in your system.
> 
> This patch allows to list a ruleset containing xt extensions loaded
> through iptables-compat-restore tool.
> 
> Example:
> 
> $ cat iptables-save
> *filter
> :INPUT ACCEPT [0:0]
> :FORWARD ACCEPT [0:0]
> :OUTPUT ACCEPT [0:0]
> -A INPUT -p tcp -m multiport --dports 80,81 -j REJECT
> COMMIT
> 
> $ sudo iptables-compat-restore iptables-save

Note that this command above doesn't work, this should be
instead:

        # iptables-save > file
        # iptables-compat-restore < file

> $ sudo nft list chain filter INPUT

Then, better use this:

        # nft list ruleset
        ...

to display the full translated ruleset.

Please, make sure the descriptions you provide in your patchset are
fine.

Apart from that comment, PATCH 3/3 looks good to me. Thanks.
