From: Julien Lafaye <jlafaye@gmail.com>
Subject: Re: Packet statistics accounting module: request for comments
Date: Wed, 5 Oct 2011 21:27:34 +0200
Message-ID: <CAFAca_C06BCQsovvjW8wUzAo=hR2tceAiTyEjGyU1e2D+b-EFQ@mail.gmail.com>
References: <CAFAca_CyLYGH+FyzyONsM7CiA6K3=BNdwY6PvTd+d1HEFKX6XQ@mail.gmail.com>
	<alpine.LNX.2.01.1110041256500.22180@frira.zrqbmnf.qr>
	<CAFAca_CH4QD-7XngGE=H_pTKo+gN3F_nf2RTf+1S8kbvPXkj-g@mail.gmail.com>
	<alpine.LNX.2.01.1110042220390.10811@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59428 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934402Ab1JET1f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:27:35 -0400
Received: by vws1 with SMTP id 1so1629142vws.19
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Oct 2011 12:27:34 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1110042220390.10811@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan

> I still think this could be integrated, perhaps as an extra option to
> choose a particular recording mode, to xt_quota2 (including the fifo).
> Speaking of which, your module seems to lack locking on the ctx, so it's
> not very consistent on SMP as of yet.
>

I will fix the usage of the fifo so that there is not any odd behavior
in SMP context.

As for the inclusion into xt_quota2, I am bit skeptical, for three reasons:

- the two modules, xt_quota2  and xt_pktstat, have different features:
quota enforcement and poll-based network accounting for the first one,
and event driven high resolution network accounting for the second
one. Where I agree that the two modules could share portions of code,
I don't see how the core parts can be merged. I fear that merging the
modules would require putting the two codes side by side and not
actually merging them. But you have more experience than me on
netfilter modules, and obviously on xt_quota2, and you could give me
some hints on how to merge them in a way that would benefit the two
projects.

- xt_quota2 is clearly not a good name for the feature I propose.

- since the features provided by xt_quota2 and xt_pktstat are
separated, why trying to join them into a swiss-army knife with two
sets of parameters: one to be used for a first feature and the other
one for a second feature. This could prove to be misleading for the
user.

What do you think ?

Regards,

Julien
