From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: xt_quota: fix incomplete initialization
Date: Fri, 19 Jun 2009 13:59:37 +0200
Message-ID: <4A3B7DA9.8030302@trash.net>
References: <alpine.LSU.2.00.0906180652290.12643@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64584 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbZFSL7g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2009 07:59:36 -0400
In-Reply-To: <alpine.LSU.2.00.0906180652290.12643@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Affects mainline and 2.6.30.
> 
> parent 167b2cd72bca6ca1cb3cf6a05d212cf11d65e08d (v2.6.30-rc6-1344-g167b2cd)
> commit 93739b7ba1bbfdb010417a89fd72e08ae29890cc
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Thu Jun 18 06:47:44 2009 +0200
> 
> netfilter: xt_quota: fix incomplete initialization
> 
> Commit v2.6.29-rc5-872-gacc738f ("xtables: avoid pointer to self")
> forgot to copy the initial quota value supplied by iptables into the
> private structure, thus counting from whatever was in the memory
> kmalloc returned.

Applied, thanks Jan,
