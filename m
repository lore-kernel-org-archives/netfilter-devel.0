From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 7/8] Remove support for compilation of conditional extensions
Date: Mon, 14 Apr 2008 08:46:48 +0200
Message-ID: <4802FDD8.301@trash.net>
References: <1208075154-5666-1-git-send-email-jengelh@computergmbh.de> <2b2e38a1bfc0069830bd5cfe535fa52b7ee8a0da.1208075035.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63316 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbYDNGqx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 02:46:53 -0400
In-Reply-To: <2b2e38a1bfc0069830bd5cfe535fa52b7ee8a0da.1208075035.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> ---
>  extensions/.condition-test       |    4 -
>  extensions/.condition-test6      |    4 -
>  extensions/.set-test             |    4 -
>  extensions/GNUmakefile.in        |   27 +----
>  extensions/libip6t_condition.c   |   95 ----------------
>  extensions/libip6t_condition.man |    4 -
>  extensions/libipt_SET.c          |  174 ------------------------------
>  extensions/libipt_SET.man        |   16 ---
>  extensions/libipt_condition.c    |   94 ----------------
>  extensions/libipt_condition.man  |    4 -
>  extensions/libipt_set.c          |  161 ---------------------------
>  extensions/libipt_set.h          |  104 ------------------
>  extensions/libipt_set.man        |   17 ---
>  13 files changed, 3 insertions(+), 705 deletions(-)
>  delete mode 100755 extensions/.condition-test
>  delete mode 100755 extensions/.condition-test6
>  delete mode 100755 extensions/.set-test
>  delete mode 100644 extensions/libip6t_condition.c
>  delete mode 100644 extensions/libip6t_condition.man
>  delete mode 100644 extensions/libipt_SET.c
>  delete mode 100644 extensions/libipt_SET.man
>  delete mode 100644 extensions/libipt_condition.c
>  delete mode 100644 extensions/libipt_condition.man
>  delete mode 100644 extensions/libipt_set.c
>  delete mode 100644 extensions/libipt_set.h
>  delete mode 100644 extensions/libipt_set.man


Was there some resolution on the discussion that this
is the way to go? I mainly would like to see an ACK
from Jozsef for this change before applying it.
