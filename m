From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: xt_conntrack: fix IPv4 address comparison
Date: Thu, 21 Feb 2008 16:12:37 +0100
Message-ID: <47BD94E5.7060708@trash.net>
References: <Pine.LNX.4.64.0802211610030.26109@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:60274 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751755AbYBUPM5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:12:57 -0500
In-Reply-To: <Pine.LNX.4.64.0802211610030.26109@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 58293ef3fa84c39093321a44ab11aa6cb7befbd8
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Thu Feb 21 15:41:05 2008 +0100
> 
>     [NETFILTER]: xt_conntrack: fix IPv4 address comparison


Applied, thanks. I'm beginning to wonder how much testing
you gave this though ...

