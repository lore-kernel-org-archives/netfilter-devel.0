From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: Re: [{ip,ip6}tables-compat PATCH] nft: fix network prefixes
Date: Wed, 27 Aug 2014 13:17:14 +0200
Message-ID: <CAFpD06STYKUKz1UL+ND0yj+XMLU0v3GJy9pu1_fEpnuVCx3RtQ@mail.gmail.com>
References: <1409000096-4335-1-git-send-email-giuseppelng@gmail.com>
	<20140826085513.GA3800@salvia>
	<CAFpD06RPw3pMaLHzXWdMZ7BnzXH1Sh7n68biqpR+o4k5j9=Nkg@mail.gmail.com>
	<CAFpD06SEXxqe2297-N-129tK2=Z2tAiV5fs_1Xc9AvWLnsEuVg@mail.gmail.com>
	<20140826192918.GA3394@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yh0-f41.google.com ([209.85.213.41]:62829 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbaH0LRP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Aug 2014 07:17:15 -0400
Received: by mail-yh0-f41.google.com with SMTP id b6so55048yha.14
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2014 04:17:14 -0700 (PDT)
In-Reply-To: <20140826192918.GA3394@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,
I catched the mistake.

The nft_ipv*_parse_payload function calls get_cmp_data(),
and it gets the next expression, that's bitwise instead of cmp.

So in nft_rule_to_iptables_command_state() the bitwise expr is skipped.

I could add an operation family like nft_*_parse_cmp, but in this way
I can't set the inverse flag when parsing the payload.

Otherwise, I can implement the parse_bitwise as function and not as
operation family and call it in parse_payload (as done for get_cmp_data).

Another solution could be to add the inverse flag in nft context.

Do you have any hint?

Thanks
