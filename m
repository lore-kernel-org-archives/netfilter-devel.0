From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [NETFILTER][PATCH] Re: Question about the hashlimit network mask
 patch
Date: Tue, 1 Apr 2008 17:32:07 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804011653460.13835@fbirervta.pbzchgretzou.qr>
References: <47E39230.90400@icdsoft.com> <alpine.LNX.1.00.0803211404530.10642@fbirervta.pbzchgretzou.qr> <47E3E861.9090707@icdsoft.com> <alpine.LNX.1.00.0803211805340.10642@fbirervta.pbzchgretzou.qr> <47E90678.7090405@icdsoft.com>
 <alpine.LNX.1.10.0803260836030.22661@fbirervta.pbzchgretzou.qr> <47F22F63.8020102@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: Iavor Stoev <iavor@icdsoft.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56052 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760617AbYDAPcI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:32:08 -0400
In-Reply-To: <47F22F63.8020102@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2008-04-01 14:49, Patrick McHardy wrote:

> Jan Engelhardt wrote:
>>  [NETFILTER]: xt_hashlimit: add workaround for >>32 case
>>
>>  Hardware surprisingly does nothing when a 32-bit right-shift is
>>  to be done. Worse yet, compilers do not even work around it.
>
> Thats because the C standard states that the result is undefined.
> Anyways, I think this patch is slightly nicer because it
> gets rid of the double negation and the %32 == 0 special-casing
> for IPv6.
>
> Do you want to add an ACKed-by?


The special casing for %32==0 in the IPv6 block was not a workaround for 
'>>32', but speed. Assuming the C code is already perfect and gets 
transformed 1:1 into assembly without any further optimization, the cost 
of the operation is 4 simple 'mov' instructions for %32==0, whereas 
calling maskl() will involve a fair number of operations (at least 27 by 
the count). [With your patch, maskl() is now 28 + a branch.]

Not that it really matters to me, I submitted patch (no replies yet)
that replaces it with the pfxlen static map anyway :->

> #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
> static void hashlimit_ipv6_mask(__be32 *i, unsigned int p)
> {
> 	switch (p) {
>-	case 0:
>-		i[0] = i[1] = 0;
>-		i[2] = i[3] = 0;
>-		break;
>-	case 1 ... 31:
>+	case 0 ... 31:
> 		i[0] = maskl(i[0], p);
> 		i[1] = i[2] = i[3] = 0;
> 		break;
>-	case 32:
>-		i[1] = i[2] = i[3] = 0;
>-		break;
>-	case 33 ... 63:
>+	case 32 ... 63:
> 		i[1] = maskl(i[1], p - 32);
> 		i[2] = i[3] = 0;
> 		break;
>-	case 64:
>-		i[2] = i[3] = 0;
>-		break;
>-	case 65 ... 95:
>+	case 64 ... 95:
> 		i[2] = maskl(i[2], p - 64);
> 		i[3] = 0;
>-	case 96:
>-		i[3] = 0;
>-		break;
>-	case 97 ... 127:
>+	case 96 ... 127:
> 		i[3] = maskl(i[3], p - 96);
> 		break;
> 	case 128:
