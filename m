From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Packet statistics accounting module: request for comments
Date: Tue, 4 Oct 2011 22:27:12 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1110042220390.10811@frira.zrqbmnf.qr>
References: <CAFAca_CyLYGH+FyzyONsM7CiA6K3=BNdwY6PvTd+d1HEFKX6XQ@mail.gmail.com> <alpine.LNX.2.01.1110041256500.22180@frira.zrqbmnf.qr> <CAFAca_CH4QD-7XngGE=H_pTKo+gN3F_nf2RTf+1S8kbvPXkj-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Julien Lafaye <jlafaye@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:34074 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933567Ab1JDU1O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Oct 2011 16:27:14 -0400
In-Reply-To: <CAFAca_CH4QD-7XngGE=H_pTKo+gN3F_nf2RTf+1S8kbvPXkj-g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-10-04 21:03, Julien Lafaye wrote:
>
>My objective was to count incoming packets & bytes received during 
>short time frames,[...] So, I chose to build time buckets directly in 
>the softirq handler and export them with /proc. I agree that polling 
>the xt_quota2 counter and resetting at each poll will achieve the same 
>functionality but I would run tests to check that polling is actually 
>scheduled at regular enough intervals.

I still think this could be integrated, perhaps as an extra option to 
choose a particular recording mode, to xt_quota2 (including the fifo).
Speaking of which, your module seems to lack locking on the ctx, so it's 
not very consistent on SMP as of yet.
