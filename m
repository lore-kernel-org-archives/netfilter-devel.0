From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: Re: [PATCH v3 1/2] iptables-nftables: function nft_chain_zero_counters
 added.
Date: Mon, 17 Jun 2013 14:22:56 +0200
Message-ID: <CAFpD06SurkbCHH=54yPWwF06doyH5tnRbX4_ODA8Rj9g41QruA@mail.gmail.com>
References: <20130617092600.2814.15883.stgit@localhost>
	<51BEE134.5010406@linux.intel.com>
	<20130617112917.GA3734@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:48971 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813Ab3FQMW5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:22:57 -0400
Received: by mail-vc0-f176.google.com with SMTP id ha12so1874859vcb.7
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2013 05:22:57 -0700 (PDT)
In-Reply-To: <20130617112917.GA3734@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Tomasz,

>> >+
>> >+            nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, h->family,
>>
>> This line seems to have more than 80 characters.
>>
>> There is a script in linux kernel sources that might help you before
>> sending any patches: scripts/checkpatch.pl
>> Run it against your patches, it will tell you about such style
>> issues. At least at the beginning, at some point code style becomes
>> a reflex.
>>

I runned checkscript.pl with my patch, but i don't get any style issues.
This is the output:

./scripts/checkpatch.pl --file /home/giuseppe/nft_chain_zero_counters.patch
/home/giuseppe/nft_chain_zero_counters.patch:83: ERROR: trailing whitespace
/home/giuseppe/nft_chain_zero_counters.patch:92: ERROR: trailing whitespace
total: 2 errors, 0 warnings, 141 lines checked
