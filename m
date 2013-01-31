From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Accumulated fixes v2
Date: Thu, 31 Jan 2013 03:13:32 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1301310313210.5099@nerf07.vanv.qr>
References: <1359381586-11940-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:51339 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab3AaCNe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2013 21:13:34 -0500
In-Reply-To: <1359381586-11940-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2013-01-28 14:59, Jan Engelhardt wrote:

>----------------------------------------------------------------
>Jan Engelhardt (6):
>      build: also use libtool for install stage
>      build: do not dereference symlinks on installation
>      libxtables: centralize checking for a .save function
>      extensions: eui64: set userspacesize=0
>      iptables: fall back to using save function when print is not defined
>      iptables: reword warning on using an alias

Any disposition on this?
