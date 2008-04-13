From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 04/13] Add support for xt_hashlimit match revision 1
Date: Sun, 13 Apr 2008 07:11:40 +0200
Message-ID: <4801960C.5030309@trash.net>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de> <412fa1aec727849e6c218e6548cb57d67bd6768f.1207813085.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33216 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbYDMFLo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2008 01:11:44 -0400
In-Reply-To: <412fa1aec727849e6c218e6548cb57d67bd6768f.1207813085.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> ---
>  extensions/libxt_hashlimit.c           |  398 ++++++++++++++++++++++--
>  extensions/libxt_hashlimit.man         |   86 ++++--
>  include/linux/netfilter/xt_hashlimit.h |   38 ++-
>  3 files changed, 458 insertions(+), 64 deletions(-)

Applied.
