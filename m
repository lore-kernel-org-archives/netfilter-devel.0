From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] [NETFILTER]: xt_owner: allow matching UID/GID ranges
Date: Sun, 20 Jan 2008 14:50:29 +0100
Message-ID: <479351A5.9000501@trash.net>
References: <Pine.LNX.4.64.0801201318040.14598@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801201318500.14598@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58317 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbYATNv3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:51:29 -0500
In-Reply-To: <Pine.LNX.4.64.0801201318500.14598@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 1ab123486c698860966193d254db54f8a4d428b4
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Sun Jan 20 13:15:08 2008 +0100
> 
>     [NETFILTER]: xt_owner: allow matching UID/GID ranges


Is that actually useful? The GID already allows to match
on entire groups, this seems like a "let do it just because
we can" patch to me.

