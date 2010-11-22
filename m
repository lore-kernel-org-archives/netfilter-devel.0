From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 00/00] Remove deprecated items from Makefiles
Date: Mon, 22 Nov 2010 08:17:31 -0800 (PST)
Message-ID: <20101122.081731.226770168.davem@davemloft.net>
References: <1290387808-2239-1-git-send-email-tdent48227@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: marcel@holtmann.org, padovan@profusion.mobi,
	linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
	sjur.brandeland@stericsson.com, socketcan@hartkopp.net,
	urs.thuermann@volkswagen.de, socketcan-core@lists.berlios.de,
	sage@newdream.net, ceph-devel@vger.kernel.org,
	wang840925@gmail.com, jlayton@redhat.com, kaber@trash.net,
	pekkas@netcore.fi, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	samuel@sortiz.org
To: tdent48227@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38265
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756093Ab0KVQRH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:17:07 -0500
In-Reply-To: <1290387808-2239-1-git-send-email-tdent48227@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Tracey Dent <tdent48227@gmail.com>
Date: Sun, 21 Nov 2010 20:03:11 -0500

> I changed Makefiles to use <modules>-y instead of <modules>-objs because -objs
> is deprecated and not even mentioned in Documentation/kbuild/makefiles.txt.
> 
> Also, remove some if-conditional statments because I used the ccflags-$ flag 
> instead of EXTRA_CFLAGS because EXTRA_CFLAGS.

All applied, thanks Tracey.
