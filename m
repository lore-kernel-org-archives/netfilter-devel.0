From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nftables: Drop hard coded install using root user owner
 and group.
Date: Mon, 13 Jan 2014 06:37:53 +0000
Message-ID: <20140113063753.GA11397@macbook.localnet>
References: <20140112194211.0570d298@voldemort.scrye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kevin Fenzi <kevin@scrye.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53766 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaAMGh5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jan 2014 01:37:57 -0500
Content-Disposition: inline
In-Reply-To: <20140112194211.0570d298@voldemort.scrye.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 12, 2014 at 07:42:11PM -0700, Kevin Fenzi wrote:
>  Packaging systems build as a non priv user, so can't install as root. Users
>  installing from source can 'sudo make install' or run 'make install' as root

Applied, thanks.
