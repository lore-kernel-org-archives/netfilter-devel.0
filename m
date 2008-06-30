From: David Miller <davem@davemloft.net>
Subject: Re: textsearch: fix Boyer-Moore text search bug
Date: Mon, 30 Jun 2008 12:43:57 -0700 (PDT)
Message-ID: <20080630.124357.59689985.davem@davemloft.net>
References: <20080630155609.24326.34250.sendpatchset@localhost.localdomain>
	<20080630155611.24326.60153.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56843
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751478AbYF3Tn4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:43:56 -0400
In-Reply-To: <20080630155611.24326.60153.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 30 Jun 2008 17:56:11 +0200 (MEST)

> textsearch: fix Boyer-Moore text search bug
> 
> The current logic has a bug which cannot find matching pattern, if the
> pattern is matched from the first character of target string.
> for example:
> 	pattern=abc, string=abcdefg
> 	pattern=a,   string=abcdefg
> Searching algorithm should return 0 for those things.
> 
> Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Also applied, thanks everyone.
