From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf-next: TEE only
Date: Wed, 14 Apr 2010 12:57:23 +0200
Message-ID: <4BC59F93.8090209@trash.net>
References: <1271200907-5262-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37087 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab0DNK5Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Apr 2010 06:57:24 -0400
In-Reply-To: <1271200907-5262-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> in this round:
> - use IP6SKB_REROUTED in v6 code
> - pick_net function: use skb->dev or skb->dst->dev when available
>   (or completely fall back to init_net in case there's something
>   going on)

So what about oif routing which I asked for two times?

