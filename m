From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnetfilter_conntrack: build improvements
Date: Thu, 06 Jan 2011 03:26:54 +0100
Message-ID: <4D25286E.6010008@netfilter.org>
References: <1293752503-13178-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45332 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab1AFC06 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jan 2011 21:26:58 -0500
In-Reply-To: <1293752503-13178-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 31/12/10 00:41, Jan Engelhardt wrote:
> The following changes since commit e6ba25eb57957e6634d5e7cec539b1d6e4204b27:
> 
>   Merge branch 'master' of git://dev.medozas.de/libnetfilter_conntrack (2010-12-21 20:25:32 +0100)
> 
> are available in the git repository at:
> 
>   git://dev.medozas.de/libnetfilter_conntrack master
> 
> Jan Engelhardt (4):
>       build: remove unused LIBTOOL_DEPS
>       build: use -Wall across the entire source
>       utils: resolve compiler warnings
>       qa: resolve compiler warnings
> 
>  Make_global.am                  |    1 +
>  configure.ac                    |    2 --
>  qa/test_api.c                   |    9 +++++----
>  qa/test_filter.c                |    6 +++++-
>  src/Makefile.am                 |    2 --
>  src/conntrack/Makefile.am       |    2 --
>  src/expect/Makefile.am          |    2 --
>  utils/conntrack_create.c        |    4 +++-
>  utils/conntrack_create_nat.c    |    4 +++-
>  utils/conntrack_delete.c        |    4 +++-
>  utils/conntrack_dump.c          |    4 ++--
>  utils/conntrack_events.c        |    6 ++----
>  utils/conntrack_filter.c        |    7 +++----
>  utils/conntrack_flush.c         |    4 ++--
>  utils/conntrack_get.c           |    4 +++-
>  utils/conntrack_grp_create.c    |    4 +++-
>  utils/conntrack_master.c        |    4 +++-
>  utils/conntrack_update.c        |    4 +++-
>  utils/ctexp_events.c            |    1 +
>  utils/expect_create.c           |    4 +++-
>  utils/expect_create_userspace.c |    4 +++-
>  utils/expect_delete.c           |    4 +++-
>  utils/expect_dump.c             |    3 ++-
>  utils/expect_events.c           |    3 ++-
>  utils/expect_flush.c            |    3 ++-
>  utils/expect_get.c              |    4 +++-
>  26 files changed, 60 insertions(+), 39 deletions(-)

also applied, thanks again jan.
