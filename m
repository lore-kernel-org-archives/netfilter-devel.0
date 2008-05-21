From: David Miller <davem@davemloft.net>
Subject: Re: include/linux/netfilter.h after make headers_install is
 incomplete
Date: Wed, 21 May 2008 14:08:49 -0700 (PDT)
Message-ID: <20080521.140849.201705704.davem@davemloft.net>
References: <20080520.142121.15017166.davem@davemloft.net>
	<48340064.4090805@trash.net>
	<a27c0c970805211356h4b13d001r6fa44bc36e74c3fd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: greg@nest.cx
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52885
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757077AbYEUVIy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 17:08:54 -0400
In-Reply-To: <a27c0c970805211356h4b13d001r6fa44bc36e74c3fd@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: "Greg Steuck" <greg@nest.cx>
Date: Wed, 21 May 2008 13:56:32 -0700

> On Wed, May 21, 2008 at 3:58 AM, Patrick McHardy <kaber@trash.net> wrote:
> > Greg, does this fix the problem?
> >
> >
> > commit 34d75b526704f4aa4d71f57a81cc15d8b18f5555
> 
> It sure does. Thank you very much for such an immediate fix!

Thanks for testing, I've applied Patrick's patch.
