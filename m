From: Stanislav Fomichev <stfomichev@yandex-team.ru>
Subject: Re: [PATCH] netfilter: skip checksum verification for outgoing
 rejected ipv6 packets
Date: Tue, 22 Oct 2013 16:40:46 +0400
Message-ID: <20131022124046.GA3255@stfomichev-desktop>
References: <20131022083631.GA28194@stfomichev-desktop>
 <20131022105540.GD12157@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kaber@trash.net, kadlec@blackhole.kfki.hu
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:38937 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751257Ab3JVMrY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Oct 2013 08:47:24 -0400
Content-Disposition: inline
In-Reply-To: <20131022105540.GD12157@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Could you try using nf_ip6_checksum() here instead of csum_ipv6_magic()?
Yes, it works, at least on my checksumming HW. Will resend the patch.

Thanks
