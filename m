From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next v3 1/3] netfilter: nf_conntrack: push zone object
 into functions
Date: Mon, 03 Aug 2015 18:00:35 +0200
Message-ID: <55BF9023.3050505@iogearbox.net>
References: <cover.1437561897.git.daniel@iogearbox.net> <2f95183cf2520b93d8443be935372fbef3499b96.1437561897.git.daniel@iogearbox.net> <20150730160744.GA15008@salvia> <55BA5228.6050908@iogearbox.net> <20150803155909.GA17212@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:55103 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbbHCQAi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Aug 2015 12:00:38 -0400
In-Reply-To: <20150803155909.GA17212@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/03/2015 05:59 PM, Pablo Neira Ayuso wrote:
> On Thu, Jul 30, 2015 at 06:34:48PM +0200, Daniel Borkmann wrote:
>> CTA_ZONE_DIR seems better, sure. I don't have any other extensions at
>> the moment, but it seems it makes sense to make this nested at this
>> point in time, so we have CTA_ZONE and CTA_ZONE_INFO as a container
>> for CTA_ZONE_DIR and whatever future might bring. I will look into it.
>
> thinking it well, this is part of the tuple, so I'd suggest you add
> CTA_TUPLE_ZONE to enum ctattr_tuple. We will probably need later to
> place each tuple in different zones.

That's fine with me, will do after your tree rebase.

Thanks again,
Daniel
