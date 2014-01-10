From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: [PATCH libnftables v2] Add support for ct set
Date: Fri, 10 Jan 2014 09:26:12 +0100
Message-ID: <CAKfDRXg_Ks3uPY6T9vr0pa_OgMT7ZrxdnGPTqxOvfFjoznMUeA@mail.gmail.com>
References: <1389170211-7024-1-git-send-email-kristian.evensen@gmail.com>
	<20140110005015.GA18032@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:34787 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaAJI0N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 03:26:13 -0500
Received: by mail-pb0-f53.google.com with SMTP id ma3so4152232pbc.12
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2014 00:26:12 -0800 (PST)
In-Reply-To: <20140110005015.GA18032@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Fri, Jan 10, 2014 at 1:50 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Please, rework this. It would be good to rework the meta/set part
> available in libnftables next-3.14. If you cannot make it, let me know
> and I'll schedule time to fix that. Thanks.

Thank you for your feedback, I will try to rework the patch today and
if not, then over the weekend.

Btw, during development I noticed that the dreg in ct (in libnftables)
is store as a uint32, while meta uses a uint8 for dreg/sreg. I use a
uint32 for sreg to be consistent with what is already there, but after
looking more into the code this seems not be needed as kernel
sreg/dreg is only 8 bits wide. Should I change the storage type for
sreg/dreg at the same time, or does it qualify as obscure behavior
too?

-Kristian
