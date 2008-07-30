From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: Change IFNAMSIZ to 16
Date: Wed, 30 Jul 2008 14:44:08 +0200
Message-ID: <48906218.9000808@trash.net>
References: <alpine.LNX.1.10.0807300834080.5659@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47275 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbYG3MoL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2008 08:44:11 -0400
In-Reply-To: <alpine.LNX.1.10.0807300834080.5659@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 280d718a7686c0b709cebd18328f9a85d447eb9a
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Tue Jul 29 17:01:51 2008 -0400
> 
> [NETFILTER]: Change IFNAMSIZ to 16
> 
> The protocol for communication with userspace is fixed; using
> IFNAMSIZ would indicate this was changable, which it is not.


Its used in countless ABIs, so this change doesn't make much
sense. Its also changable, you just have to recompile userspace
as well.
