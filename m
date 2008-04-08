From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/8] [NETFILTER]: Use bool type in struct nf_conntrack_tuple.h
Date: Tue, 08 Apr 2008 17:12:40 +0200
Message-ID: <47FB8B68.405@trash.net>
References: <1207664257-1927-1-git-send-email-jengelh@computergmbh.de> <aca885cca98c41ba79ef7226494bf1e785ede0c8.1207664141.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42009 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbYDHPMr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:12:47 -0400
In-Reply-To: <aca885cca98c41ba79ef7226494bf1e785ede0c8.1207664141.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> ---
>  include/net/netfilter/nf_conntrack.h       |   11 +++---
>  include/net/netfilter/nf_conntrack_core.h  |    4 +-
>  include/net/netfilter/nf_conntrack_tuple.h |   39 +++++++++++---------
>  net/netfilter/nf_conntrack_core.c          |   22 +++++------
>  4 files changed, 38 insertions(+), 38 deletions(-)

Applied.
