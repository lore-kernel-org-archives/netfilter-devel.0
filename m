From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Linux-2.6.9-rc1 netfilter compile problems
Date: Wed, 25 Aug 2004 06:48:01 +0200
Sender: linux-net-owner@vger.kernel.org
Message-ID: <20040825044801.GB7310@mars.ravnborg.org>
References: <20040824205315.77265dcd@laptop.delusion.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Network Mailing List <linux-net@vger.kernel.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <linux-net-owner@vger.kernel.org>
To: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
Content-Disposition: inline
In-Reply-To: <20040824205315.77265dcd@laptop.delusion.de>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Aug 24, 2004 at 08:53:15PM -0700, Udo A. Steinberg wrote:
> 
> 
> Problem #1:
> ----------
> 
> uas@laptop:~/linux-2.6.9-rc1> make
> /bin/sh: line 1: [: too many arguments
>   SPLIT   include/linux/autoconf.h -> include/config/*

Fixed in Linus' tree - so should be present in next snapshot.

	Sam
