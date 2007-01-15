From: David Madore <david.madore@ens.fr>
Subject: Re: [patch] netfilter: implement TCPMSS target for IPv6
Date: Mon, 15 Jan 2007 01:35:08 +0100
Message-ID: <20070115003508.GA8085@clipper.ens.fr>
References: <20070114192011.GA6270@clipper.ens.fr> <Pine.LNX.4.61.0701142110250.11926@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751762AbXAOAf0@vger.kernel.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0701142110250.11926@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, Jan 14, 2007 at 09:10:45PM +0100, Jan Engelhardt wrote:
> On Jan 14 2007 20:20, David Madore wrote:
> >Implement TCPMSS target for IPv6 by shamelessly copying from
> >Marc Boucher's IPv4 implementation.
> 
> Would not it be worthwhile to merge ipt_TCPMSS and
> ip6t_TCPMSS to xt_TCPMSS instead?

It may be, but I'm afraid that's outside my competence.  I happened to
need ip6t_TCPMSS badly and soon, so I went for the quickest solution.
Of course, I'd appreciate it if someone were to do it in a better way.

Happy hacking,

-- 
     David A. Madore
    (david.madore@ens.fr,
     http://www.madore.org/~david/ )
