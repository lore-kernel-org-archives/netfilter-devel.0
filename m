From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Building iptables from source with kernel source
Date: Mon, 30 Jul 2012 13:58:41 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207301314470.23976@frira.zrqbmnf.qr>
References: <1343646082.3347.7.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Arif Hossain <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:50266 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab2G3L6s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jul 2012 07:58:48 -0400
In-Reply-To: <1343646082.3347.7.camel@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2012-07-30 13:01, Arif Hossain wrote:

>Hi,
>
>I'm trying to build iptables from git tree.
>
>The extension i've written resides in extensions/libxt_mymatch.c
>
>Now the header is in
><kernel_source>/include/linux/netfilter/xt_mymatch.h

iptables is independent of any particular kernel tree. Copy (or
symlink) your file into <iptables>/include/linux/netfilter, that is
easiest.

>
>But when i'm trying to build iptables, its not finding xt_mymatch.h.
>
>I've tried these configure options
>
>$./configure --with-ksource=<kernel_source_path>
>and
>$./configure --with-ksource=<kernel_source_path>/include
>
>But both failed.

That is too unspecified to derive any cause.
(Also note that ksource uses the source dir, not the include dir.)
