From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 01/24] [NETFILTER]: remove arpt_table indirection macro
Date: Thu, 03 Apr 2008 13:38:42 +0200
Message-ID: <47F4C1C2.2010101@trash.net>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de> <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64259 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbYDCLir (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 07:38:47 -0400
In-Reply-To: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> ---
>  include/linux/netfilter_arp/arp_tables.h |   11 ++++-----
>  net/ipv4/netfilter/arp_tables.c          |   27 ++++++++++-----------
>  net/ipv4/netfilter/arptable_filter.c     |    2 +-

Applied.
