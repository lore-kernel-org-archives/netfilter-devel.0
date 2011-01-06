From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libmnl: build improvements
Date: Thu, 06 Jan 2011 03:21:35 +0100
Message-ID: <4D25272F.8030003@netfilter.org>
References: <1293752607-13822-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60536 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab1AFCVk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jan 2011 21:21:40 -0500
In-Reply-To: <1293752607-13822-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 31/12/10 00:43, Jan Engelhardt wrote:
> The following changes since commit 091286e666a9d34818a875152ac7659b38656f06:
> 
>   build: libmnl 1.0.1 release (2010-12-26 21:17:54 +0100)
> 
> are available in the git repository at:
>   git://dev.medozas.de/libmnl master
> 
> Jan Engelhardt (2):
>       build: use AM_CPPFLAGS
>       build: use only AC_CANONICAL_HOST
> 
>  Make_global.am |    2 +-
>  configure.ac   |    9 +++++----
>  2 files changed, 6 insertions(+), 5 deletions(-)

Applied, thanks Jan.
