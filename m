From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 03/10] Remove support for compilation of conditional extensions
Date: Tue, 15 Apr 2008 13:41:23 +0200
Message-ID: <48049463.2080005@trash.net>
References: <1208255608-8044-1-git-send-email-jengelh@computergmbh.de> <bfc44342f0ecd2278412e98409f6d98ae307eb69.1208255176.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34752 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758246AbYDOLl3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 07:41:29 -0400
In-Reply-To: <bfc44342f0ecd2278412e98409f6d98ae307eb69.1208255176.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> ---
>  extensions/.condition-test             |    4 -
>  extensions/.condition-test6            |    4 -
>  extensions/.set-test                   |    4 -
>  extensions/GNUmakefile.in              |   27 +--
>  extensions/libip6t_condition.c         |   95 -----
>  extensions/libip6t_condition.man       |    4 -
>  extensions/libipt_condition.c          |   94 -----
>  extensions/libipt_condition.man        |    4 -
>  include/linux/netfilter_ipv4/ip_set.h  |  498 ++++++++++++++++++++++++
>  include/linux/netfilter_ipv4/ipt_set.h |   21 +
>  10 files changed, 522 insertions(+), 233 deletions(-)
>  delete mode 100755 extensions/.condition-test
>  delete mode 100755 extensions/.condition-test6
>  delete mode 100755 extensions/.set-test
>  delete mode 100644 extensions/libip6t_condition.c
>  delete mode 100644 extensions/libip6t_condition.man
>  delete mode 100644 extensions/libipt_condition.c
>  delete mode 100644 extensions/libipt_condition.man
>  create mode 100644 include/linux/netfilter_ipv4/ip_set.h
>  create mode 100644 include/linux/netfilter_ipv4/ipt_set.h

Applied.
