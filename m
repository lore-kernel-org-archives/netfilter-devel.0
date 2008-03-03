From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [NETFILTER]: Deploy a prefix length to network mask mapping table
Date: Mon, 03 Mar 2008 03:52:11 +0100
Message-ID: <47CB67DB.1060800@netfilter.org>
References: <Pine.LNX.4.64.0802211633500.26109@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0802291946560.24056@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49823 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756371AbYCCCwU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Mar 2008 21:52:20 -0500
In-Reply-To: <Pine.LNX.4.64.0802291946560.24056@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Feb 21 2008 16:38, Jan Engelhardt wrote:
>> this is now the proposed memory reduction of xt_conntrack as previously 
>> mentioned in http://marc.info/?l=netfilter-devel&m=120334779109237&w=2 .
>>
>> Since xt_conntrack r1 is new, we can still modify it.
>>
>> ===
>> commit 84622a5c5190ea1bf0a37695961714a04a99a9c0
>> Author: Jan Engelhardt <jengelh@computergmbh.de>
>> Date:   Thu Feb 21 16:33:32 2008 +0100
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
> 
> Can we merge this while r1 is not yet used by userspace?
> If not, that's fine too, will queue it for 2.6.26.

Attention, I'm about to release iptables-1.4.1 which includes the
userspace part for this. I can still delay it a couple of days and
rework the release tarball if you pass me the userspace part asap.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
