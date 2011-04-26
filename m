From: David Miller <davem@davemloft.net>
Subject: Re: kernel source code files with same name (different case) xt_*
Date: Tue, 26 Apr 2011 13:48:11 -0700 (PDT)
Message-ID: <20110426.134811.260073531.davem@davemloft.net>
References: <BANLkTinDLPBeYkLE17cyhQg5m-_ZTWbgXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: jg@jguk.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46221
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753389Ab1DZUso (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:48:44 -0400
In-Reply-To: <BANLkTinDLPBeYkLE17cyhQg5m-_ZTWbgXg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jon Grant <jg@jguk.org>
Date: Tue, 26 Apr 2011 21:47:07 +0100

> Would a patch be considered for review which amended the
> netfilter/KBuild to simply refer to the lower-case files, and deleted
> the CAPS version files?

Unlikely.  Please use a real filesystem when building the kernel
sources.

It's not like there's a shortage of them to choose from.

