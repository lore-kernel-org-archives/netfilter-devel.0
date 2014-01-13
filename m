From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables/libnftables packages for Fedora
Date: Mon, 13 Jan 2014 00:29:30 +0000
Message-ID: <20140113002930.GB3373@macbook.localnet>
References: <20140112134024.2475a4f2@voldemort.scrye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kevin Fenzi <kevin@scrye.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51549 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaAMA3e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Jan 2014 19:29:34 -0500
Content-Disposition: inline
In-Reply-To: <20140112134024.2475a4f2@voldemort.scrye.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 12, 2014 at 01:40:24PM -0700, Kevin Fenzi wrote:
> 3. nftables hard codes installing as root, which is no good for
> building packages (patch attached that just removes the owner/group
> setting there). 

Please resubmit with a subject, a brief changelog and a Signed-off-by:
line and I'm going to apply it.

Thanks.
