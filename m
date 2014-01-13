From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables/libnftables packages for Fedora
Date: Mon, 13 Jan 2014 00:17:29 +0000
Message-ID: <20140113001729.GB3251@macbook.localnet>
References: <20140112134024.2475a4f2@voldemort.scrye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kevin Fenzi <kevin@scrye.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51470 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaAMARe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Jan 2014 19:17:34 -0500
Content-Disposition: inline
In-Reply-To: <20140112134024.2475a4f2@voldemort.scrye.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 12, 2014 at 01:40:24PM -0700, Kevin Fenzi wrote:
> 2. There is some question about the /etc/nftables/* scripts. In Fedora
> land, things in /etc/ should be config files, but these aren't really
> config files. They call nft without a full path (/usr/sbin/nft, etc).
> Should these really be in /usr/share ? or is it expected users will
> modify them? Could you clarify the use case there?

These files are to be included, they are mainly executable for easier
testing.

> 4. nftables sets make to '-s' (ie, silent) on subdirs. It's good for
> building packages to have verbose output in build logs. Would it be
> possible to remove that? If not I can patch it out here. 

No problem adding an option to disable the silent output (I think
current autoconf supports this), but I'd like to keep it as default.
