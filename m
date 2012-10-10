From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Documentation fixes to iptables
Date: Wed, 10 Oct 2012 14:38:11 +0200
Message-ID: <20121010123811.GA30034@1984>
References: <1349871992-31115-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58187 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062Ab2JJMie (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:38:34 -0400
Content-Disposition: inline
In-Reply-To: <1349871992-31115-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 10, 2012 at 02:26:23PM +0200, Jan Engelhardt wrote:
> 
> 
> I would say this is material that can go into nf/stable as well.

Oh no, we're discussing again the same thing... No please, only fixes
go into -stable.

These are enhancements, even if they are mostly doc updates.

Please, hold on a bit with updates (1 week?) until all the dust we got
settles down. Thanks.

> ===
> The following changes since commit 9921f2b9a241750e4730fc7d486687c6a32779f4:
> 
>   build: resolve compile abort in libxt_limit on RHEL5 (2012-10-10 13:28:29 +0200)
> 
> are available in the git repository at:
> 
>   git://git.inai.de/iptables master
> 
> for you to fetch changes up to 60f59034fca30c4b2b5177600e81c6e7f07651a6:
> 
>   src: remove faulty deprecated marker in libipt_LOG source (2012-10-10 14:25:25 +0200)
> 
> ----------------------------------------------------------------
> Jan Engelhardt (9):
>       doc: rename .8.in files to .8in
>       doc: add package version to all manpages
>       doc: fixup omissions in ip6tables-restore.8
>       doc: document iptables-restore's -t option
>       doc: document iptables-restore's -v option
>       doc: document iptables-restore's -M option
>       doc: document iptables-restore's -h option
>       doc: name the supported log levels for ipt_LOG
>       src: remove faulty deprecated marker in libipt_LOG source
> 
>  extensions/libip6t_LOG.c                                   |    2 +-
>  extensions/libip6t_LOG.man                                 |    5 ++++-
>  extensions/libipt_LOG.c                                    |    2 +-
>  extensions/libipt_LOG.man                                  |    5 ++++-
>  iptables/.gitignore                                        |    4 +---
>  iptables/Makefile.am                                       |    9 +++------
>  iptables/{ip6tables-restore.8 => ip6tables-restore.8in}    |   22 +++++++++++++++++++---
>  iptables/{ip6tables-save.8 => ip6tables-save.8in}          |    2 +-
>  iptables/{ip6tables.8.in => ip6tables.8in}                 |    2 +-
>  iptables/{iptables-apply.8 => iptables-apply.8in}          |    2 +-
>  .../{iptables-extensions.8.in => iptables-extensions.8in}  |    2 +-
>  iptables/{iptables-restore.8 => iptables-restore.8in}      |   20 +++++++++++++++++---
>  iptables/{iptables-save.8 => iptables-save.8in}            |    2 +-
>  iptables/{iptables.8.in => iptables.8in}                   |    2 +-
>  14 files changed, 56 insertions(+), 25 deletions(-)
>  rename iptables/{ip6tables-restore.8 => ip6tables-restore.8in} (72%)
>  rename iptables/{ip6tables-save.8 => ip6tables-save.8in} (96%)
>  rename iptables/{ip6tables.8.in => ip6tables.8in} (99%)
>  rename iptables/{iptables-apply.8 => iptables-apply.8in} (95%)
>  rename iptables/{iptables-extensions.8.in => iptables-extensions.8in} (94%)
>  rename iptables/{iptables-restore.8 => iptables-restore.8in} (71%)
>  rename iptables/{iptables-save.8 => iptables-save.8in} (96%)
>  rename iptables/{iptables.8.in => iptables.8in} (99%)
