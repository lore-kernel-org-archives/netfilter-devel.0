From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] netfilter: implement TCPMSS target for IPv6
Date: Mon, 15 Jan 2007 09:40:13 +0100
Message-ID: <45AB3DED.8090404@trash.net>
References: <20070114192011.GA6270@clipper.ens.fr> <Pine.LNX.4.61.0701142110250.11926@yvahk01.tjqt.qr> <20070115003508.GA8085@clipper.ens.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932117AbXAOIkR@vger.kernel.org>
To: David Madore <david.madore@ens.fr>
In-Reply-To: <20070115003508.GA8085@clipper.ens.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

David Madore wrote:
> On Sun, Jan 14, 2007 at 09:10:45PM +0100, Jan Engelhardt wrote:
> 
>>On Jan 14 2007 20:20, David Madore wrote:
>>
>>>Implement TCPMSS target for IPv6 by shamelessly copying from
>>>Marc Boucher's IPv4 implementation.
>>
>>Would not it be worthwhile to merge ipt_TCPMSS and
>>ip6t_TCPMSS to xt_TCPMSS instead?
> 
> 
> It may be, but I'm afraid that's outside my competence.  I happened to
> need ip6t_TCPMSS badly and soon, so I went for the quickest solution.
> Of course, I'd appreciate it if someone were to do it in a better way.

I'll give it a shot.
