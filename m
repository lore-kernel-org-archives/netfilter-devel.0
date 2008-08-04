From: Patrick McHardy <kaber@trash.net>
Subject: Re: Put xtables.c into its own library, libxtables.so
Date: Mon, 04 Aug 2008 18:38:35 +0200
Message-ID: <4897308B.10704@trash.net>
References: <alpine.LNX.1.10.0808040952170.28732@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, hadi@cyberus.ca,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	denys@visp.net.lb
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59014 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758693AbYHDQih (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:38:37 -0400
In-Reply-To: <alpine.LNX.1.10.0808040952170.28732@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Put xtables.c into its own library, libxtables.so
> 
> iproute2's tc's m_ipt.c poses as a pseudo-iptables program to make
> use of the info structure composition of iptables extensions.
> Since tc would have to clone a lot of code, xtables.c is put into
> its own shared library and should not be relied upon by any other
> programs.

Applied, thanks Jan.
