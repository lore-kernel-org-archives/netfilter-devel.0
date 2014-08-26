From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: Re: [{ip,ip6}tables-compat PATCH] nft: fix network prefixes
Date: Tue, 26 Aug 2014 13:43:03 +0200
Message-ID: <CAFpD06RPw3pMaLHzXWdMZ7BnzXH1Sh7n68biqpR+o4k5j9=Nkg@mail.gmail.com>
References: <1409000096-4335-1-git-send-email-giuseppelng@gmail.com>
	<20140826085513.GA3800@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45718 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbaHZLnF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:43:05 -0400
Received: by mail-vc0-f174.google.com with SMTP id la4so16574807vcb.19
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Aug 2014 04:43:03 -0700 (PDT)
In-Reply-To: <20140826085513.GA3800@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,
To fix that the add_cmp_ptr() function should be called after
add_bitwise_* in add_addr() function.
But this change make the output wrong, see below:

# iptables-compat -A INPUT -p tcp -s 192.168.0.0/24 --dport 22 -m
conntrack --ctstate NEW -j ACCEPT
# iptables-compat -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
ACCEPT     tcp  --  anywhere             anywhere             tcp
dpt:ssh ctstate NEW

I'm going to investigate more in depth.

Regards
