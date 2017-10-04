From: Juergen Borleis <jbe@pengutronix.de>
Subject: Re: [PATCH] iptables: change large file support handling
Date: Wed, 4 Oct 2017 16:39:23 +0200
Message-ID: <201710041639.23481.jbe@pengutronix.de>
References: <201709281059.45061.jbe@pengutronix.de> <20171004141458.GA28637@salvia>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:58483 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752452AbdJDOjZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2017 10:39:25 -0400
In-Reply-To: <20171004141458.GA28637@salvia>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Wednesday 04 October 2017 16:14:58 Pablo Neira Ayuso wrote:
> > The configure script handles the "--*-largefile" parameter badly. It
> > defaults to large file support if not given and always disables
> > largefile support if given (and it doesn't matter if 'enable' or
> > 'disable' was used)
>
> It seems the default behaviour for a while has been to enable
> largefile by default.
>
> Then, someone came in to add this --disable-largefile configure time
> option, see:
>
> commit 967cb7106f0f61cd7b8fbb10bc2451a3f7372a43
> Author: Karl Hiramoto <karl@hiramoto.org>
> Date:   Mon May 10 17:50:41 2010 +0200
>
>     iptables: optionally disable largefile support
>
> So I would just fix --enable-* --disable-*.
>
> Would you follow up on this? Let me know, thanks.

With my change the default is still "enabled" and you can disable it on 
demand. To have still support for "disable on demand" makes sense for some 
small 32 bit embedded systems.

Juergen

-- 
Pengutronix e.K.                             | Juergen Borleis             |
Industrial Linux Solutions                   | http://www.pengutronix.de/  |
