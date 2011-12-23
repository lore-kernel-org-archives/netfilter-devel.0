From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset: build updates
Date: Fri, 23 Dec 2011 21:31:28 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1112232130280.11694@blackhole.kfki.hu>
References: <1324136109-31504-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:48268 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880Ab1LWUba (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Dec 2011 15:31:30 -0500
In-Reply-To: <1324136109-31504-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Sat, 17 Dec 2011, Jan Engelhardt wrote:

> The following changes since commit 7c061f216ee04a8df5f49521b146f4a274b5f1ac:
> 
>   ipset 6.10 released (2011-11-25 09:36:04 +0100)
> 
> are available in the git repository at:
>   git://dev.medozas.de/ipset master
> 
> Jan Engelhardt (6):
>       Update .gitignore
>       build: use AC_CONFIG_AUX_DIR and stash away tools
>       build: process include/libipset/
>       build: include libipset/nfproto.h
>       build: install libipset/linux_ip_set_list.h
>       build: make distcheck work and use POSIX mode for tarball generation
> 
>  .gitignore                   |   12 ++++--------
>  Makefile.am                  |    4 +++-
>  configure.ac                 |    5 +++--
>  include/Makefile.am          |    1 -
>  include/libipset/Makefile.am |    7 +++++--
>  src/Makefile.am              |    2 +-
>  6 files changed, 16 insertions(+), 15 deletions(-)
>  delete mode 100644 include/Makefile.am

Thanks, all patches are applied.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
