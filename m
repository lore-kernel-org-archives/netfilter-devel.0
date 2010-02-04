From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Question about the "dst" field in sk_buff
Date: Thu, 4 Feb 2010 12:56:14 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002041255100.30438@obet.zrqbmnf.qr>
References: <2a3692de1002031015l7ff6e1a1w61caa03d46afb55b@mail.gmail.com>  <alpine.LSU.2.01.1002031930070.27969@obet.zrqbmnf.qr> <2a3692de1002040134v7c4bcbbby6d3708506d37f053@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Dominik Kaspar <dokaspar.ietf@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41758 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235Ab0BDL4Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Feb 2010 06:56:16 -0500
In-Reply-To: <2a3692de1002040134v7c4bcbbby6d3708506d37f053@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-02-04 10:34, Dominik Kaspar wrote:

>Hi Jan,
>
>How about in general...? What is required to make code compile that
>has "skb->dst" in it?

Changing it to skb_dst, which is what v1.22-2-gcf7a40f does.
