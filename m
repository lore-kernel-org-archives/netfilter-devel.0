From: David Miller <davem@davemloft.net>
Subject: Re: cups slow on linux-2.6.24
Date: Thu, 14 Feb 2008 14:50:42 -0800 (PST)
Message-ID: <20080214.145042.210615931.davem@davemloft.net>
References: <Pine.LNX.4.64.0802102257420.14442@boston.corp.fedex.com>
	<Pine.LNX.4.64.0802141536560.22526@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jeff.chua.linux@gmail.com, kaber@trash.net,
	linux-kernel@vger.kernel.org, ole@ans.pl, cups-bugs@easysw.com,
	netfilter-devel@vger.kernel.org, torvalds@linux-foundation.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53600
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758461AbYBNWuK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:50:10 -0500
In-Reply-To: <Pine.LNX.4.64.0802141536560.22526@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date: Thu, 14 Feb 2008 16:02:29 +0100 (CET)

> Hi,
> 
> On Sun, 10 Feb 2008, Jeff Chua wrote:
> 
> > Please note the lastest git commit is missing one part (which was in Jozsef's
> > original patch).
> 
> Sorry everyone, that's my fault: the patch I sent for the stable branch 
> was correct, however I mistyped a state in the patch for the newest 
> git tree - Jeff spotted it, thanks! So here follows the patch against the 
> newest git tree which corrects the mistake. Please review and commit.

I'll apply this since Patrick still isn't feeling well.

Thanks!
