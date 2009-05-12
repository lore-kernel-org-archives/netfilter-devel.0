From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrackd: message building fix for uint16_t attributes
Date: Tue, 12 May 2009 23:11:43 +0200
Message-ID: <4A09E60F.2070208@netfilter.org>
References: <4A09A150.3060807@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Samuel GAUTHIER <samuel.gauthier@6wind.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48800 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbZELVME (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 May 2009 17:12:04 -0400
In-Reply-To: <4A09A150.3060807@6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Samuel GAUTHIER wrote:
> Dear Pablo,
> 
> I think that the patch attached to this email should be applied to
> current conntrack-tools tree.
> nfct_get_attr_u16 returns a uint16_t, so I think that in src/build.c,
> the result of nfct_get_attr_u16 should be put into a uint16_t, not a
> uint32_t.

Right. Thanks Samuel. Applied.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
