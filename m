From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrackd PATCH v2] conntrackd: add basic systemd notification
 support
Date: Mon, 26 Oct 2015 21:12:36 +0100
Message-ID: <20151026201236.GA13580@salvia>
References: <144524350598.16550.11699956757376724904.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, jengelh@inai.de
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54965 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbbJZUFb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Oct 2015 16:05:31 -0400
Content-Disposition: inline
In-Reply-To: <144524350598.16550.11699956757376724904.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

On Mon, Oct 19, 2015 at 10:33:15AM +0200, Arturo Borrero Gonzalez wrote:
> This patch adds a basic systemd notification support.
> 
> Most of distros (Debian, RHEL, Ubuntu, ArchLinux...) use systemd as
> init system.
> Notifiying systemd that conntrackd is now running has many
> benefits, the main being users concatenating systemd services depending on
> the main conntrackd daemon being started.
> 
> The systemd support means conntrackd will require libsystemd, so a
> configure swith is added:
> 
>  % ./configure --disable-systemd
> 
> We can further integrate conntrackd with systemd:
>  * add watchdog support
>  * report daemon errors (f.e, errno codes)
>  * tell systemd conntrackd PID
>  * report about conntrackd Unix socket

Interesting. I would really like to see a patchset that adds one of
these features above at least. So I basically need more meat here...

Another comment below.

> diff --git a/configure.ac b/configure.ac
> index 70d3729..8bb9581 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -61,6 +61,9 @@ AC_ARG_ENABLE([cthelper],
>  AC_ARG_ENABLE([cttimeout],
>          AS_HELP_STRING([--disable-cttimeout], [Do not build timeout support]),
>          [enable_cttimeout="no"], [enable_cttimeout="yes"])

I'd appreciate if you send me patches to fix these AC_ARG_ENABLE above
in first place.

Thanks!
