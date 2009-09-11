From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH xt-addons 1/2] xt_psd: use skb_header_pointer
Date: Fri, 11 Sep 2009 21:50:58 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0909112146570.23562@obet.zrqbmnf.qr>
References: <1252659955-13181-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48452 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbZIKTu4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:50:56 -0400
In-Reply-To: <1252659955-13181-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2009-09-11 11:05, Florian Westphal wrote:

>[PATCH]
>Don't rely on tcphdr being in the linear area.
>


Both applied, thanks.

