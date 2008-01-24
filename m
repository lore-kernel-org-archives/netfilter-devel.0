From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] [NETFILTER]: xt_socket: rename from xt_owner
Date: Thu, 24 Jan 2008 08:54:56 +0100
Message-ID: <47984450.7070309@trash.net>
References: <Pine.LNX.4.64.0801220022580.25080@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35061 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbYAXHzq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 02:55:46 -0500
In-Reply-To: <Pine.LNX.4.64.0801220022580.25080@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 7ed2d25d54b696074c8e787a03a1513d245e8caa
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Mon Jan 21 13:34:48 2008 +0100
> 
>     [NETFILTER]: xt_socket: rename from xt_owner
>     
>     xt_owner matches against the ownership of a socket. Currently this
>     only work in the output path when skb->sk is set. I recalled tproxy's
>     xt_socket, which does an explicit socket for the input path and
>     thought that this could be useful for xt_owner. Both modules would
>     then do a lookup, so let's just combine the code into one module.
>     
>     This patch renames xt_owner to xt_socket; the tproxy bits and input
>     path socket lookup will be added when tproxy gets merged.


This seems unnecessary. We can consider the rename once tproxy
gets merged, but things are progressing very slowly.
