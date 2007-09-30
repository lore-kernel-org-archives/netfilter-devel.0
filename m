From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 08/13] Split Netfilter IPv4 defragmentation into a separate
 module
Date: Mon, 01 Oct 2007 00:35:24 +0200
Message-ID: <470024AC.1020408@trash.net>
References: <20070930205141.10969.27205.stgit@nessa.odu> <20070930205304.10969.44668.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49310 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbXI3WjF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:39:05 -0400
In-Reply-To: <20070930205304.10969.44668.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

KOVACS Krisztian wrote:
> Netfilter connection tracking requires all IPv4 packets to be defragmented.
> Both the socket match and the TPROXY target depend on this functionality, so
> this patch separates the Netfilter IPv4 defrag hooks into a separate module.
>
> Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
>   

Mhh .. I don't like this too much, but I don't see a much
better way myself, especially for the socket match since
it can't do defragmentation itself.


