From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next v2 3/3] netfilter: nf_conntrack: add efficient
 mark to zone mapping
Date: Mon, 20 Jul 2015 22:05:16 +0200
Message-ID: <55AD547C.9000500@iogearbox.net>
References: <cover.1436574843.git.daniel@iogearbox.net> <8b1e8907e8dd9a51f2e40b39cd5f5c2b0eae94fd.1436574843.git.daniel@iogearbox.net> <20150715175056.GA7436@salvia> <55A6BCD8.2010905@iogearbox.net> <55AD1F6F.1090607@iogearbox.net> <20150720170327.GA22681@salvia> <55AD2F75.7090607@iogearbox.net> <20150720182429.GA3572@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:59090 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbbGTUFU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jul 2015 16:05:20 -0400
In-Reply-To: <20150720182429.GA3572@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07/20/2015 08:24 PM, Pablo Neira Ayuso wrote:
...
> I see, thanks for explaining.
>
> I would like to avoid the use of the ct->status bit to set this. Can
> you see a clean way to store this bit in the zone extension instead?

Okay, understood, i.e. since it's unfortunately exported through UAPI
and there's limited space. I'm thinking of renaming the u16 for the
direction in the zones structure into 'flags' and just add an indicator
there [as we still have unused bits there] ... would that seem better?

Thanks,
Daniel
