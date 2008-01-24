From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] [NETFILTER]: xt_socket: allow matching UID/GID ranges
Date: Thu, 24 Jan 2008 08:55:16 +0100
Message-ID: <47984464.4030909@trash.net>
References: <Pine.LNX.4.64.0801220022580.25080@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801220023270.25080@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35069 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbYAXH4I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 02:56:08 -0500
In-Reply-To: <Pine.LNX.4.64.0801220023270.25080@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 2dee4f29f447ed446610b9a8e6e8385ce721e457
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Sun Jan 20 13:15:08 2008 +0100
> 
>     [NETFILTER]: xt_socket: allow matching UID/GID ranges
>     
>     Range matching makes it possible to reduce the number of rules
>     required for some setups.

I'm going to apply the first patch you sent.


