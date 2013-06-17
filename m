From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: Re: [PATCH v3 1/2] iptables-nftables: function nft_chain_zero_counters
 added.
Date: Mon, 17 Jun 2013 15:17:26 +0200
Message-ID: <CAFpD06T49mEBTQHey2CungHn5ew-ohgaSOAZyai2EzsSSqJ5CA@mail.gmail.com>
References: <20130617092600.2814.15883.stgit@localhost>
	<51BEE134.5010406@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ve0-f169.google.com ([209.85.128.169]:56322 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948Ab3FQNR1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:17:27 -0400
Received: by mail-ve0-f169.google.com with SMTP id m1so2064350ves.14
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2013 06:17:26 -0700 (PDT)
In-Reply-To: <51BEE134.5010406@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Tomasz,

> I guess you don't want to continue looping after you found your chain. On
> success, make it break.

Looking the code, in other functions like nft_chain_user_del,
i guess that the loop continue after found the chain.
Am i wrong?

> And on error your function should return the error code.

return ret == 0 ? 1 : 0;
is it ok this code?

Thanks
