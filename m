From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnetfilter_log: build improvements
Date: Thu, 06 Jan 2011 03:24:25 +0100
Message-ID: <4D2527D9.4040307@netfilter.org>
References: <1293752536-13491-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45223 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab1AFCYd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jan 2011 21:24:33 -0500
In-Reply-To: <1293752536-13491-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 31/12/10 00:42, Jan Engelhardt wrote:
> The following changes since commit 9ce233ad4377b609ecb8d3bb84036bb629f7b291:
> 
>   src: declare non-modified data as const (2010-12-21 20:54:42 +0100)
> 
> are available in the git repository at:
>   git://dev.medozas.de/libnetfilter_log master
> 
> Jan Engelhardt (4):
>       build: remove unused LIBTOOL_DEPS
>       build: create a Make_global.am file
>       build: use -Wall across the entire source
>       utils: resolve compiler warnings
> 
>  Make_global.am      |    2 ++
>  configure.ac        |    2 --
>  src/Makefile.am     |    3 +--
>  utils/Makefile.am   |    2 +-
>  utils/nfulnl_test.c |    4 ++--
>  utils/ulog_test.c   |    4 ++--
>  6 files changed, 8 insertions(+), 9 deletions(-)
>  create mode 100644 Make_global.am

also applied, thanks.
