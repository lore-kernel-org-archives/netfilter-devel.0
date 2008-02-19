From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 3/3] xt_iprange: fix subtraction-based comparison
Date: Tue, 19 Feb 2008 13:52:13 +0100
Message-ID: <47BAD0FD.9000901@trash.net>
References: <Pine.LNX.4.64.0802061453480.23855@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0802061457240.23855@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:56548 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752574AbYBSMw2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 07:52:28 -0500
In-Reply-To: <Pine.LNX.4.64.0802061457240.23855@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit d995f13b64092a8f3fd375a8815841e6fb635cd7
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Thu Jan 31 23:12:07 2008 +0100
> 
>     [NETFILTER]: xt_iprange: fix subtraction-based comparison
>     
>     The host address parts need to be converted to host-endian first
>     before arithmetic makes any sense on them.

Applied, thanks Jan.
