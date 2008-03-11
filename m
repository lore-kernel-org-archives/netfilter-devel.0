From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_conntrack r1; deploy a prefix length to network mask mapping
 table
Date: Tue, 11 Mar 2008 20:58:28 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803112053230.18745@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0802211633500.26109@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0802291946560.24056@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, pablo@netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34444 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYCKT63 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Mar 2008 15:58:29 -0400
In-Reply-To: <Pine.LNX.4.64.0802291946560.24056@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Feb 29 2008 19:47, Jan Engelhardt wrote:
>>===
>>commit 84622a5c5190ea1bf0a37695961714a04a99a9c0
>>Author: Jan Engelhardt <jengelh@computergmbh.de>
>>Date:   Thu Feb 21 16:33:32 2008 +0100
>>
>>    [NETFILTER]: Deploy a prefix length to network mask mapping table
>>    
>>    Userspace utilities commonly transform a prefix length (CIDR notation
>>    like 192.168.222.1/32) into a full netmask before submitting it to
>>    the kernel.
>>    
>>    The size of struct xt_conntrack_mtinfo1 is currently 152 bytes, of
>>    which 64 bytes are for masks. By submitting prefix lengths to the
>>    kernel, we can save 60 bytes (almost 40%) as prefix lengths can fit
>>    into one uint8_t. Since we do not want to recompute the mask for each
>>    invocation of the match function, a static translation table will be
>>    used (net/core/pfxlen.c).
>>    
>>    The patch also removes xt_hashlimit's obsolete mask computation.
>
>Can we merge this while r1 is not yet used by userspace?
>If not, that's fine too, will queue it for 2.6.26.
>

I have not yet heard back. If this fails to make it into 2.6.25, then I 
suggest disabling revision 1 support before the next iptables release 
(replacing .family=AF_INET/AF_INET6 with AF_UNSPEC for simplicity) so 
that iptables continues to use rev 0 on 2.6.25.

Following this, .revision=1 can just be exchanged by .revision=2 in both 
2.6.26 and iptables without problems. This way, no new extra code is 
introduced while keeping all the backwards niceties.



thanks,
Jan
