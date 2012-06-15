From: "Hans Schillstrom" <hans@schillstrom.com>
Subject: Re[2]:  [RFC] netfilter: xt_TEE: IPv4 Don't Fragmet options
Date: Fri, 15 Jun 2012 08:37:07 +0200 (CEST)
Message-ID: <8oegugq.fb5f47534daac35954f4ab92cf50648f@obelix.schillstrom.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: "Pablo Neira Ayuso" <pablo@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	fw@strlen.de
To: "Jan Engelhardt" <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:37050 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab2FOGhV convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jun 2012 02:37:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>
>On Thursday 2012-06-14 08:17, Hans Schillstrom wrote:
>
>>Hello,
>>
>>I  think it is wrong to always force the DF bit in IPv4, it's better to have an option
>
>Do you experience an actual problem?

Yes, with almost every UDP protos.

>
>>If an application don't set the DF bit, usually it doesn't expect to 
>>get an icmp back either.
>
>Applications often don't have the means to set DF, think SOCK_STREAM.

Yeah I do, and TCP usually set the DF bit and if you inherit that it should not be a problem.
BTW, I don't see any real use case for TCP except for a "remote" tcpdump

>
>>The result is that the packet will be dropped...
>
>And exactly because of that, an ICMP message should be generated, to 
>notify the sender about a reduced MTU, so that the TEE destination does 
>in fact get the messages.

Inherit - don't force, it's a better idea
if you don't set it you don't expect an ICMP either.

>
>>
>>To retain backwards compatibility I suggest adding a new option like
>>
>>--ipv4-df-copy  Do not force "Don't Fragment" on the copied packet just copy the bit.
>>
>>In IPv6 we don't have that option, so nothing has to be done there.
>>
>>
>>diff --git a/include/linux/netfilter/xt_TEE.h b/include/linux/netfilter/xt_TEE.h
>>index 5c21d5c..e5fca8a 100644
>>--- a/include/linux/netfilter/xt_TEE.h
>>+++ b/include/linux/netfilter/xt_TEE.h
>>@@ -4,6 +4,7 @@
>> struct xt_tee_tginfo {
>>        union nf_inet_addr gw;
>>        char oif[16];
>>+       int df_copy;
>>
>>        /* used internally by the kernel */
>>        struct xt_tee_priv *priv __attribute__((aligned(8)));
>
>As Pablo mentioned, you cannot touch this structure.

I know this was just a RFC,  I  should have made a note about that :-)

>"int" is also a bad idea. - See my very own "Writing Netfilter Modules" 
>pdf for details.

Thanks

/Hans

