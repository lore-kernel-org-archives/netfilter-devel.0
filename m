From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v5 3/3] src: add xt compat support
Date: Wed, 13 Jul 2016 11:53:27 +0200
Message-ID: <20160713095327.GB14902@salvia>
References: <20160712200417.21890-1-pablombg@gmail.com>
 <20160712200417.21890-3-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42237 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbcGMJxk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jul 2016 05:53:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8D78AEAA70
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jul 2016 11:53:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7C50B9EBC9
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jul 2016 11:53:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 54E91FAB4F
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jul 2016 11:53:32 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160712200417.21890-3-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 12, 2016 at 10:04:17PM +0200, Pablo M. Bermudo Garay wrote:
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
> $ iptables-save > ruleset
> 
> $ cat ruleset
> *filter
> :INPUT ACCEPT [0:0]
> :FORWARD ACCEPT [0:0]
> :OUTPUT ACCEPT [0:0]
> -A INPUT -p tcp -m multiport --dports 80,81 -j REJECT
> COMMIT
> 
> $ sudo iptables-compat-restore ruleset
> 
> $ sudo nft list rulseset
> table ip filter {
>     chain INPUT {
>         type filter hook input priority 0; policy accept;
>         ip protocol tcp tcp dport { 80,81} counter packets 0 bytes 0 reject
>     }
> 
>     chain FORWARD {
>         type filter hook forward priority 0; policy drop;
>     }
> 
>     chain OUTPUT {
>         type filter hook output priority 0; policy accept;
>     }
> }
> 
> A translation of the extension is shown if this is available. In other
> case, match or target definition is preceded by a hash. For example,
> classify target has not translation:
> 
> $ sudo nft list chain mangle POSTROUTING
> table ip mangle {
>     chain POSTROUTING {
>         type filter hook postrouting priority -150; policy accept;
>         ip protocol tcp tcp dport 80 counter packets 0 bytes 0 # CLASSIFY set 20:10
>                                                               ^^^
>     }
> }
> 
> If the whole ruleset is translatable, the users can (re)load it using
> "nft -f" and get nft native support for all their rules.

Applied, thanks!
