From: David Miller <davem@davemloft.net>
Subject: Re: Request: Remove duplicate file names in the kernel source
Date: Tue, 02 Sep 2008 16:06:01 -0700 (PDT)
Message-ID: <20080902.160601.109446139.davem@davemloft.net>
References: <BLU122-W19B435CA307A7ED8A80E18DA5F0@phx.gbl>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: hallberg68@hotmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58051
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753387AbYIBXGH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2008 19:06:07 -0400
In-Reply-To: <BLU122-W19B435CA307A7ED8A80E18DA5F0@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Peter Hallberg <hallberg68@hotmail.com>
Date: Tue, 2 Sep 2008 23:53:35 +0200

> The netfilter sources in the Linux Kernel contains a number of files
> that is duplicates expect for the case, like foo.c and FOO.c, this
> creates a problem when untaring the kernel source on a filesystem
> that doesn't support it like the common Windows file systems,
> sometimes you have the need to study the kernel source on other
> systems and it really is unecessary and confusing to have this
> naming so I would like to ask you to change it, below is a list of
> the files:

We can't change these, especially the ones under include/linux,
without breaking userspace as userspace includes these files.

I find it strange that you want to study an advanced OS using such a
primitive filesystem :-)
