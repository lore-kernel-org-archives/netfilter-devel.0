From: Philip Craig <philipc@snapgear.com>
Subject: Re: [NETFILTER 42/69]: nf_conntrack: optimize hash_conntrack()
Date: Tue, 29 Apr 2008 16:00:35 +1000
Message-ID: <4816B983.4030906@snapgear.com>
References: <481589D2.2050901@snapgear.com>	<4815D842.8010303@trash.net>	<4816A89B.7050300@snapgear.com> <20080428.224400.193700589.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	rmk@arm.linux.org.uk
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:41568 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753156AbYD2GAh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:00:37 -0400
In-Reply-To: <20080428.224400.193700589.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Miller wrote:
> Now these elements cannot be assumed to have any particular
> alignment, so gcc will emit byte-at-a-time accesses to these
> elements.

Ah, so the problem is the __attribute__(packed) removes align
restrictions for the whole structure, in addition to removing
padding.

Is there any way to tell gcc to pack but still align the whole
thing?

eg what does it do for this:
	struct t {
		struct s {
			u16 a;
			u16 b;
		} __attribute__(packed);
	};

