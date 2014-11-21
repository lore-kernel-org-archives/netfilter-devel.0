From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: named vmaps
Date: Fri, 21 Nov 2014 09:22:00 +0100
Message-ID: <CAJO99T=5z-AC=YzOVTYH3++6kf74fXqSu=Q15Jqhb3bVYQ-mLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:45634 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758049AbaKUIWC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Nov 2014 03:22:02 -0500
Received: by mail-lb0-f177.google.com with SMTP id 10so746722lbg.8
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Nov 2014 00:22:00 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Is support for named vmaps removed from nft? Running kernel 3.18.0-rc5
and nft head.

I am able to create the named vmap:

nft add map filter my_vmap { type ipv4_addr : verdict\; }

..but when I try to add elements to it:

nft add element filter my_vmap { 1.0.0.0 : drop}
<cmdline>:1:40-43: Error: syntax error, unexpected drop
add element filter my_vmap { 1.0.0.0 : drop}
                                       ^^^^

also, when trying to use the vmap in a rule:

nft add rule filter input ip saddr vmap @my_vmap
<cmdline>:1:37-37: Error: syntax error, unexpected @, expecting '{'
add rule filter input ip saddr vmap @my_vmap

Dont find anything in "documentation" or online that tells me if and when this
functionality changed/broke/got removed.

-- 
Bj(/)rnar
