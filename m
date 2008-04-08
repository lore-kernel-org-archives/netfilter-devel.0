From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 6/8] [NETFILTER]: const annotations in nf_conntrack_{sctp,dccp},
 nf_nat_proto_gre
Date: Tue, 08 Apr 2008 17:19:14 +0200
Message-ID: <47FB8CF2.2040403@trash.net>
References: <1207664257-1927-1-git-send-email-jengelh@computergmbh.de> <6b37f059ec4bd658ae8a7fd34c3e0babcd5c71da.1207664141.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42183 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbYDHPTY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:19:24 -0400
In-Reply-To: <6b37f059ec4bd658ae8a7fd34c3e0babcd5c71da.1207664141.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> ---
>  net/ipv4/netfilter/nf_nat_proto_dccp.c  |    2 +-
>  net/ipv4/netfilter/nf_nat_proto_gre.c   |    2 +-
>  net/netfilter/nf_conntrack_proto_dccp.c |   19 ++++++++++++-------
>  net/netfilter/nf_conntrack_proto_sctp.c |   17 +++++++++++------
>  4 files changed, 25 insertions(+), 15 deletions(-)

Applied without the DCCP conntrack parts. That code is work
in progress and the patch doesn't apply. I also tend to fix
these things myself before finally pushing it upstream.
