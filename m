From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH nf_conntrack_extend] new extensions without changes
 kernel source
Date: Tue, 29 Oct 2013 13:22:12 +0100
Message-ID: <20131029122212.GA8019@localhost>
References: <525EEAB7.4090901@guap.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Vitaly E. Lavrov" <lve@guap.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39474 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab3J2MWV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Oct 2013 08:22:21 -0400
Content-Disposition: inline
In-Reply-To: <525EEAB7.4090901@guap.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Vitaly,

On Wed, Oct 16, 2013 at 11:36:23PM +0400, Vitaly E. Lavrov wrote:
> How to add additional data to the conntrack? This is needed to
> the implementation of ndpi-netfilter.
> 
> Now it is possible to add data to a struct "nf_conn-> ext" through
> nf_conntrack_extend, but it requires a change in the kernel code.
> 
> I have developed a patch to register custom extensions in nf_conn->ext.
> In the kernel configuration, you can specify the maximum number of additional
> extensions (0..8). When registering a custom extension to specify an
> additional unique identifier extension (u32). In the extension properties
> seq_print added optional method to display data in "/proc/net/nf_conntrack".
> 
> What lacks is in this patch?

I'm reticent to get this extremely generic infrastructure into
mainstream, we need to know more on the ndpi needs and discuss some
generic infrastructure that most layer 7 implementation can benefit
from.

BTW, please try to avoid /proc interfaces, we try to run away from them
if possible, using ctnetlink would be better.
