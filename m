From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 07/10] Dynamically create xtables.h.in with version
Date: Tue, 15 Apr 2008 13:44:43 +0200
Message-ID: <4804952B.3080205@trash.net>
References: <1208255608-8044-1-git-send-email-jengelh@computergmbh.de> <f29980fc99ea95ed8c1aa362fd1f780ef1a630e4.1208255176.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34852 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbYDOLot (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 07:44:49 -0400
In-Reply-To: <f29980fc99ea95ed8c1aa362fd1f780ef1a630e4.1208255176.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> ---
>  configure.ac         |    2 +-
>  include/xtables.h    |  216 -----------------------------------------
>  include/xtables.h.in |  218 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 219 insertions(+), 217 deletions(-)
>  delete mode 100644 include/xtables.h
>  create mode 100644 include/xtables.h.in
>

Applied.
