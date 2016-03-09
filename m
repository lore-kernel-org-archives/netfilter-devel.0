From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libxt_multiport: Add translation to nft
Date: Wed, 9 Mar 2016 13:32:38 +0100
Message-ID: <20160309123238.GA30363@salvia>
References: <20160307212141.GA10594@sonyv>
 <20160308105346.GB4008@salvia>
 <56DFC995.7090009@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: FaTe <gokuvsvegita@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57375 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbcCIMcp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2016 07:32:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9F6A91BFA80
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Mar 2016 13:32:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8F720DA384
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Mar 2016 13:32:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id ADDDFDA384
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Mar 2016 13:32:39 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <56DFC995.7090009@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 09, 2016 at 12:28:29PM +0530, FaTe wrote:
> Added translation for the match multiport.
> 
> Example :
> $ iptables-translate -A INPUT -p tcp -m multiport --ports 3:4  -j ACCEPT
> nft add rule ip filter INPUT ip protocol tcp dport { 3-4 } tcp sport { 3-4 }
> counter accept
> 
> $ iptables-translate -A INPUT -p tcp -m multiport --sports http,ssh,ftp  -j
> ACCEPT
> nft add rule ip filter INPUT ip protocol tcp sport { 80,22,21 } counter accept
> 
> $ iptables-translate -A INPUT -p tcp -m multiport --dports 1024:2048  -j ACCEPT
> nft add rule ip filter INPUT ip protocol tcp dport { 1024-2048 } counter accept
> 
> $  iptables-translate -A input -p tcp -m multiport --dports 1024:2048,2049:3333
> -j ACCEPT
> nft add rule ip filter input ip protocol tcp dport { 1024-2048,2049-3333 }
> counter accept

This translation is not correct as it's been discussed in a different
thread.
