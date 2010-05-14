From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] iptables: add noreturn attribute to exit_tryhelp()
Date: Fri, 14 May 2010 13:26:51 +0200
Message-ID: <4BED337B.5040109@trash.net>
References: <20100219022638.GB32672@wo.int.altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42819 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab0ENL0w (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 May 2010 07:26:52 -0400
In-Reply-To: <20100219022638.GB32672@wo.int.altlinux.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dmitry V. Levin wrote:
> Found by gcc -Wmissing-noreturn.

Applied, thanks.
