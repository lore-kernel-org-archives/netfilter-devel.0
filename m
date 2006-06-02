From: Andrew James Wade <andrew.j.wade@gmail.com>
Subject: Re: [PATCH] fix mem-leak in netfilter
Date: Fri, 2 Jun 2006 17:32:13 -0400
Message-ID: <200606021732.14628.ajwade@cpe001346162bf9-cm0011ae8cd564.cpe.net.cable.rogers.com>
References: <44643BFD.3040708@trash.net> <200606010943.31554.ajwade@cpe001346162bf9-cm0011ae8cd564.cpe.net.cable.rogers.com> <447EFF72.1050803@trash.net>
Reply-To: ajwade@cpe001346162bf9-cm0011ae8cd564.cpe.net.cable.rogers.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@osdl.org>, Stephen Frost <sfrost@snowman.net>,
	Amin Azez <azez@ufomechanic.net>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750931AbWFBVc0@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <447EFF72.1050803@trash.net>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thursday 01 June 2006 10:53, Patrick McHardy wrote:
> [CC-list trimmed]
> 
> Andrew James Wade wrote:
> > Hello Mr. McHardy,
> > 
> > The BUG below appears to be related to your ipt_recent rewrite. I
> > haven't tracked it down further yet. I've attached the (toy) firewall
> > script that's triggering the bug.
> 
> Yes, that was my fault. These two patches should fix it.
> 
> 
That fixed it, thanks.
