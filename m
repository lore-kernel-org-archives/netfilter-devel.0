From: Patrick McHardy <kaber@trash.net>
Subject: nft cache updates
Date: Mon, 9 Nov 2015 15:30:56 +0000
Message-ID: <20151109153055.GI8098@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:48998 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751572AbbKIPa7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Nov 2015 10:30:59 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

I'm wondering what the rational for the current cache update behaviour is.
The changelog states it is somehow related to the requested command, but
that doesn't seem to be true.

Even "nft describe" fails with EPERM as user since the cache appears to be
initialized unconditionally, which is a bit unfortunate. Also I used to
test things parsing, evaluation and even netlink generation without actually
adding those rules as user, which does not work anymore. This might be harder
to get working again, but I'm not sure why we do a full initialization anyways.
The only thing that appears to be needed are sets, and those only in some
specific circumstances.

Cheers,
Patrick
