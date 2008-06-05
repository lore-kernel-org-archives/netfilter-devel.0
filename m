From: Patrick McHardy <kaber@trash.net>
Subject: Re: [netfilter-core] [ANNOUNCE] Release of iptables 1.4.1-rc2
Date: Thu, 05 Jun 2008 19:19:06 +0200
Message-ID: <4848200A.3060600@trash.net>
References: <483AB493.6010503@trash.net> <x6skw443x5@gzp>	<483BB9DE.6050003@trash.net> <x6y75w3q2j@gzp>	<483C088E.4020405@trash.net> <x67idfq6d8@gzp>	<483CFF21.40608@trash.net> <4847F64C.2040902@trash.net> <x663snremo@gzp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Jan Engelhardt <jengelh@computergmbh.de>
To: "Gabor Z. Papp" <gzp@papp.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48831 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbYFERTK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2008 13:19:10 -0400
In-Reply-To: <x663snremo@gzp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Gabor Z. Papp wrote:
> * Patrick McHardy <kaber@trash.net>:
> 
> | Took me a bit longer. I've resynced all headers and added
> | a recent linux/types.h. Does this patch (on top of 1.4.1-rc2)
> | fix compilation?
> 
> patching file include/linux/netfilter.h
> Reversed (or previously applied) patch detected!  Assume -R? [n]
> Apply anyway? [n]
> Skipping patch.
> 1 out of 1 hunk ignored -- saving rejects to file include/linux/netfilter.h.rej
> 
> make  all-recursive
> make[1]: Entering directory `/home/gzp/src/iptables-1.4.1-rc2'
> Making all in extensions
> make[2]: Entering directory `/home/gzp/src/iptables-1.4.1-rc2/extensions'
> 
> [...]
> 
>   CC       libxt_dccp.oo
> libxt_dccp.c:16:24: warning: linux/dccp.h: No such file or directory


Mhh .. I don't really want to add that file to iptables.
Jan, I'm not familiar with auto*, could you send a patch
to make compilation of libxt_dccp dependand on the presence
of linux/dccp.h? Thanks.
