From: Patrick McHardy <kaber@trash.net>
Subject: Re: [iptables PATCH trunk7285 4/7] escape strings
Date: Tue, 29 Jan 2008 14:28:00 +0100
Message-ID: <479F29E0.1060204@trash.net>
References: <20080127182421.15959.52088.stgit@woodpecker.roonstrasse.net> <20080127182503.15959.75218.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54999 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933356AbYA2Nn7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:43:59 -0500
In-Reply-To: <20080127182503.15959.75218.stgit@woodpecker.roonstrasse.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
> ---
> 
>  extensions/libipt_LOG.c   |    6 ++++--
>  extensions/libipt_ULOG.c  |    6 ++++--
>  extensions/libxt_NFLOG.c  |    6 ++++--
>  extensions/libxt_helper.c |    3 ++-
>  include/xtables.h         |    6 ++++++
>  xtables.c                 |   37 +++++++++++++++++++++++++++++++++++++
>  6 files changed, 57 insertions(+), 7 deletions(-)

Also applied. A short rationale in the patch description would
be good for the changelogs though.
