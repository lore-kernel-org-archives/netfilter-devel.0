From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH 2/2] netfilter: nft: add queue module
Date: Mon, 02 Dec 2013 10:32:08 +0100
Message-ID: <1385976728.19102.7.camel@ice-age2.regit.org>
References: <1385808722.4321.19.camel@ice-age2.regit.org>
	 <1385808978-19833-1-git-send-email-eric@regit.org>
	 <1385808978-19833-2-git-send-email-eric@regit.org>
	 <529C2B33.9020205@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:55082 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab3LBJcP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Dec 2013 04:32:15 -0500
In-Reply-To: <529C2B33.9020205@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Mon, 2013-12-02 at 08:39 +0200, Tomasz Bursztyka wrote:
> Hi Eric,
> 
> > +
> > +#define NFT_QUEUE_FLAG_BYPASS		0x01 /* for compatibility with v2 */
> > +#define NFT_QUEUE_FLAG_CPU_FANOUT	0x02 /* use current CPU (no hashing) */
> > +#define NFT_QUEUE_FLAG_MASK		0x03
> 
> Why not declaring them in an enum, as for nft_rule_compat_flags, 
> nft_set_flags or nft_set_elem_flags?

Simple answer: It was not an enum in the original NFQUEUE code ;)

Real answer: We have only two values, third one is a mask. So it may be
a bit overkill to use an enum here.

BR,
-- 
Eric Leblond <eric@regit.org>

