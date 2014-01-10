From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftables v2] Add support for ct set
Date: Fri, 10 Jan 2014 11:37:58 +0100
Message-ID: <20140110103758.GA4732@localhost>
References: <1389170211-7024-1-git-send-email-kristian.evensen@gmail.com>
 <20140110005015.GA18032@localhost>
 <CAKfDRXg_Ks3uPY6T9vr0pa_OgMT7ZrxdnGPTqxOvfFjoznMUeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58494 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756695AbaAJKiN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:38:13 -0500
Content-Disposition: inline
In-Reply-To: <CAKfDRXg_Ks3uPY6T9vr0pa_OgMT7ZrxdnGPTqxOvfFjoznMUeA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 10, 2014 at 09:26:12AM +0100, Kristian Evensen wrote:
> Hi Pablo,
> 
> On Fri, Jan 10, 2014 at 1:50 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Please, rework this. It would be good to rework the meta/set part
> > available in libnftables next-3.14. If you cannot make it, let me know
> > and I'll schedule time to fix that. Thanks.
> 
> Thank you for your feedback, I will try to rework the patch today and
> if not, then over the weekend.
> 
> Btw, during development I noticed that the dreg in ct (in libnftables)
> is store as a uint32, while meta uses a uint8 for dreg/sreg. I use a
> uint32 for sreg to be consistent with what is already there, but after
> looking more into the code this seems not be needed as kernel
> sreg/dreg is only 8 bits wide. Should I change the storage type for
> sreg/dreg at the same time, or does it qualify as obscure behavior
> too?

That's inconsistent and needs to be fixed. My suggestion is to fix it
by using u32 for registers. Thanks.
