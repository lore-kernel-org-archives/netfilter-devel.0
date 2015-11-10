From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: Re: [PATCH nft,v2] src: add interface wildcard matching
Date: Tue, 10 Nov 2015 18:18:24 +0100
Message-ID: <CAJO99TnYBByUPE4_2ACL-tcPVv5z2VROxCaQyWp6AVkZXt92hA@mail.gmail.com>
References: <1446464915-2407-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:34954 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbbKJRS0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Nov 2015 12:18:26 -0500
Received: by lfdo63 with SMTP id o63so2039289lfd.2
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2015 09:18:24 -0800 (PST)
In-Reply-To: <1446464915-2407-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2015-11-02 12:48 GMT+01:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> Contrary to iptables, we use the asterisk character '*' as wildcard.
>
>  # nft --debug=netlink add rule test test iifname eth\*

Any reason this is not iifprefix instead of iifname.. I find the
wildcard confusing,
since it can only be placed in the end.

-- 
Bj(/)rnar
