From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables-addons: fix installation in case only modules in subdirs
 of extensions are enabled
Date: Mon, 18 Jan 2010 17:53:08 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1001181753030.21972@obet.zrqbmnf.qr>
References: <1263805716.31396.1018.camel@tablet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Peter Volkov <pva@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45010 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab0ARQxK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jan 2010 11:53:10 -0500
In-Reply-To: <1263805716.31396.1018.camel@tablet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-01-18 10:08, Peter Volkov wrote:

>In case only modules that are built in subdirectories of extensions are
>enabled (and thus nothing is build in extensions directory itself)
>installation fails with the error (only build_ACCOUNT=y in mconfig):

Applied, thanks.
