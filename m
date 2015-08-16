From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/12] add support for VLAN header filtering in bridge family
Date: Sun, 16 Aug 2015 21:05:43 +0200
Message-ID: <1439751955-31190-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34742 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963AbbHPTGH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Aug 2015 15:06:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds the following features:
- stacked headers: vlan sits on top of ethernet, so when vlan id 42 is requested,
  add a dependency on eth and also adjust payload offsets by the size of ethernet
  header.

- allow matching header fields of lengths and/or offsets that are not byte divisible,
  e.g. vlan id, vlan pcp, ip hdrlength, etc.

Missing/not working:

- concat support for vlan ids, e.f. this will not work:
vlan id . ip saddr { 1 . 1.2.3.4 }

- payload merging of fields that have lengths/sizes not divisible by 8.

IOW when asking for vlan id 42 vlan pcp 0 then we generate 2 payload instructions,
2 binops, 2 cmps.

Oddities:

bridge filter input ip saddr 1.2.3.4

... will never match in some cases.

'Problem' (or feature...?) is that nft adds dependency on 'ether type ip'
so if all traffic is VLAN encapsulated this will not match.

[ can use 'vlan type ip ip saddr 1.2.3.4' to match eth-vlan-ip packets ].

There might be a lot of pitfalls that i've missed.

Unless there are objections I will push the first two patches soon.

The vlan patch set has seen minimal testing inside kvm on x86_64,
using a (pending) kernel patch to nft_payload to transparently insert
the missing/stripped vlan header into the register set.

I'd be happy to receive feedback on these patches, I'm sure that some
things can be implemented in a more straightforward fashion.

Cheers,
Florian

