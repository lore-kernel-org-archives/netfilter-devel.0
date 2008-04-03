From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 05/24] [NETFILTER]: remove arpt_(un)register_target indirection
 macros
Date: Thu, 03 Apr 2008 13:51:25 +0200
Message-ID: <47F4C4BD.1090101@trash.net>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de> <d33c9f4c65b3e61ed77cdd2425c80a0134dacd96.1207134547.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64606 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbYDCLve (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 07:51:34 -0400
In-Reply-To: <d33c9f4c65b3e61ed77cdd2425c80a0134dacd96.1207134547.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> ---
>  include/linux/netfilter_arp/arp_tables.h |    5 -----
>  net/ipv4/netfilter/arpt_mangle.c         |    8 +++-----
>  2 files changed, 3 insertions(+), 10 deletions(-)

Applied.
