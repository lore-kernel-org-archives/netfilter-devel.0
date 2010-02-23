From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables-addons: make ipv6 optional for RAWNAT and SYSRQ
Date: Wed, 24 Feb 2010 00:34:40 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002240034360.11034@obet.zrqbmnf.qr>
References: <1266580375.26314.6.camel@tablet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Peter Volkov <peter.volkov@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57109 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714Ab0BWXel (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Feb 2010 18:34:41 -0500
In-Reply-To: <1266580375.26314.6.camel@tablet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-02-19 12:52, Peter Volkov wrote:

>Hi, in case kernel was built without ipv6 support xt_RAWNAT and xt_SYSRQ
>fail to load with unknown symbols. Patches in attachment fix this issue.
>Please, apply.

Applied, thanks.
