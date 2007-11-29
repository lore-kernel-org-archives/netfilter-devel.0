From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: iptables release
Date: Thu, 29 Nov 2007 11:49:45 +0900 (JST)
Message-ID: <200711290249.lAT2nk9g004082@toshiba.co.jp>
References: <474C4B67.3000200@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from imx12.toshiba.co.jp ([61.202.160.132]:58522 "EHLO
	imx12.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbXK2Ctu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Nov 2007 21:49:50 -0500
Received: from arc11.toshiba.co.jp ([133.199.90.127])
	by imx12.toshiba.co.jp  with ESMTP id lAT2nmZG011813
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Nov 2007 11:49:48 +0900 (JST)
Received: (from root@localhost)
	by arc11.toshiba.co.jp  id lAT2nmJs009246
	for netfilter-devel@vger.kernel.org; Thu, 29 Nov 2007 11:49:48 +0900 (JST)
Received: from mx.toshiba.co.jp (localhost [127.0.0.1])
	by ovp11.toshiba.co.jp  with ESMTP id lAT2nlvS021737
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Nov 2007 11:49:47 +0900 (JST)
In-Reply-To: <474C4B67.3000200@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 27 Nov 2007 17:52:55 +0100

> I have a large number of pending patches for iptables for new
> matches and targets. I'm not going apply patches for new things
> unless they are at least in a -rc kernel, so we have a chance to
> fix mistakes. So my question is whether we're ready to release
> the current iptables -rc anytime soon (before/when 2.6.24 is
> released) or whether we're more likely going to need until 2.6.25,
> in which case I would apply them now.
> 
> Any opinions?

Please wait a few hours at least to release iptables. Just after sending
this mail, I'll moves some libipt_*.man to libxt_*.man and remove
libip6t_state.c which I forgot to remove.

-- Yasuyuki Kozakai
