From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [RFC nftables kernel PATCH] netfilter: nf_tables: fix nft_meta_target
 module
Date: Thu, 28 Nov 2013 15:32:29 +0200
Message-ID: <529745ED.5050201@linux.intel.com>
References: <20131128111557.6154.40370.stgit@nfdev.cica.es> <5297382F.60707@linux.intel.com> <CAOkSjBj+XER8sn1eakaTDyDJPUn=t50WFYLE8zF4uP7Ef9TTOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:30161 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab3K1Ncb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Nov 2013 08:32:31 -0500
In-Reply-To: <CAOkSjBj+XER8sn1eakaTDyDJPUn=t50WFYLE8zF4uP7Ef9TTOA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

>> All expression have a short, one-word based name, which is nice.
> Yes, any suggestion?

Always the tricky part ^^ (complaining about is easy...).
But we might avoid that:

>> Anyway, doesn't it work already: if you create an immediate expression (to
>> load the value you want, at default dreg 0 aka NFT_REG_VERDICT) and a meta
>> expression without the NFTA_META_DREG set? (didn't try myself)
>>
> I commented the immediate load with Pablo. He suggested the value to
> be fetched from the metatarget directly.

Ok I see it optimize things, then below:

>> If not maybe there is a shorter way to fix this, instead of creating a full
>> new expression. Looks like it was the original plan.
>>
> You mean the original plan was to avoid creating a new expression?
> In that case, I will have to revisit this, as I wasn't considering
> this approach.

Thus, why not adding an attribute to the meta expression. Like: 
NFTA_META_SVAL? (Of course NFTA_META_DREG and this new attribute are 
mutually exclusive)
I guess then you only need to adapt struct nft_policy in 
nft_meta_target.c to handle it, and adding value element in its nft_meta 
struct, and there you are.

Less code and API change.

Tomasz
