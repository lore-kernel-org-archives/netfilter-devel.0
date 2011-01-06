From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnetfilter_queue: build improvements
Date: Thu, 06 Jan 2011 03:18:38 +0100
Message-ID: <4D25267E.7020707@netfilter.org>
References: <1293752575-13611-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33625 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509Ab1AFCSm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jan 2011 21:18:42 -0500
In-Reply-To: <1293752575-13611-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 31/12/10 00:42, Jan Engelhardt wrote:
> The following changes since commit e07ff761686629a3a7cf5af67f281a5b6ce4d8c5:
> 
>   doc: fix wrong documentation on NFQNL_COPY_NONE (2010-12-07 10:06:21 +0100)
> 
> are available in the git repository at:
>   git://dev.medozas.de/libnetfilter_queue master
> 
> Jan Engelhardt (3):
>       build: remove unused LIBTOOL_DEPS
>       build: create a Make_global.am file
>       build: use -Wall across the entire source
> 
>  Make_global.am    |    2 ++
>  configure.ac      |    2 --
>  src/Makefile.am   |    3 +--
>  utils/Makefile.am |    3 +--
>  4 files changed, 4 insertions(+), 6 deletions(-)
>  create mode 100644 Make_global.am

Applied, thanks Jan.
