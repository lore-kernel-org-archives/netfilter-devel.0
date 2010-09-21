From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] ipvs: Netfilter connection tracking changes
Date: Tue, 21 Sep 2010 16:56:35 +0200
Message-ID: <4C98C7A3.7070100@trash.net>
References: <Pine.LNX.4.58.1009162342590.6976@u.domain.uli> <4C935EE3.5070207@trash.net> <Pine.LNX.4.58.1009172232520.2923@u.domain.uli>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Julian Anastasov <ja@ssi.bg>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38679 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab0IUO4s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:56:48 -0400
In-Reply-To: <Pine.LNX.4.58.1009172232520.2923@u.domain.uli>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 17.09.2010 21:38, schrieb Julian Anastasov:
> 
> 	Hello,
> 
> On Fri, 17 Sep 2010, Patrick McHardy wrote:
> 
>> This one doesn't compile cleanly with CONFIG_IP_VS_NFCT=n:
>>
>>   CC [M]  net/netfilter/ipvs/ip_vs_ftp.o
>> net/netfilter/ipvs/ip_vs_ftp.c: In function 'ip_vs_ftp_out':
>> net/netfilter/ipvs/ip_vs_ftp.c:242: error: implicit declaration of
>> function 'ip_vs_nfct_expect_related'
> 
> 	I'm able to reproduce it only by commenting
> CONFIG_IP_VS_FTP and CONFIG_IP_VS_NFCT and then this command fails:
> 
> make net/netfilter/ipvs/ip_vs_ftp.o
> 
> 	In all other cases if CONFIG_IP_VS_FTP is enabled
> the 'select IP_VS_NFCT' does its job and enables
> CONFIG_IP_VS_NFCT. Am I missing something?

No, this appears to be correct, not sure what went wrong. I'll
retry later, thanks.
