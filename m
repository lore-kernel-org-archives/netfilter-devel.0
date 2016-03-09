From: FaTe <gokuvsvegita@gmail.com>
Subject: Regarding libxt_multiport translation in nft
Date: Wed, 9 Mar 2016 12:35:55 +0530
Message-ID: <56DFCB53.8090601@gmail.com>
References: <20160307212141.GA10594@sonyv> <20160308105346.GB4008@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33930 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbcCIHFj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2016 02:05:39 -0500
Received: by mail-pa0-f54.google.com with SMTP id fe3so16253832pab.1
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Mar 2016 23:05:39 -0800 (PST)
In-Reply-To: <20160308105346.GB4008@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Pablo,

I would require some guidance regarding the libxt_multiport translation in nft.

If the translation is over ip4 family :
$ iptables-translate -A INPUT -p tcp -m multiport --ports 3:4  -j ACCEPT
nft add rule ip filter INPUT ip protocol tcp dport { 3-4 } tcp sport { 3-4 } counter accept
		             ^^^^^^^^^^^
			     this causes problem.
Similarly for ipv6 :
$ ip6tables-translate -A input -p tcp -m multiport --dports 1024:2048,2049:3333 -j ACCEPT
nft add rule ip6 filter input meta l4proto tcp dport { 1024-2048,2049-3333 } counter accept
			      ^^^^^^^^^^^^
			      this is causing problem.

both the strings "ip protocol" and "meta l4proto" is not introduced by libxt_multiport.
And in the absence of both , the command works.

For example , 
$ nft add rule ip filter INPUT tcp dport { 3-4 } tcp sport { 3-4 } counter accept

$ nft add rule ip6 filter input tcp dport { 1024-2048,2049-3333 } counter accept

Any comment regarding this behaviour ?
