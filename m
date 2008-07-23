From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: Conntrack Events Performance - Multipart Messages?
Date: Wed, 23 Jul 2008 18:30:18 +0100
Message-ID: <48876AAA.9020609@gmx.ch>
References: <487E24FC.60700@gmx.ch> <487F18DA.7030208@netfilter.org> <487FFBEE.90409@trash.net> <4884B068.4050306@gmx.ch> <4884B270.5010104@trash.net> <4884CC17.3020905@gmx.ch> <488740E7.3040005@gmx.ch> <48874272.1020503@trash.net> <48875887.8040209@gmx.ch> <488763F3.5020506@trash.net> <4887656B.1090504@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37978 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751104AbYGWRaU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 13:30:20 -0400
In-Reply-To: <4887656B.1090504@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Patrick McHardy wrote:
>> Fabian Hugelshofer wrote:
>>> Is the zeroing of the inverted tuple in nf_ct_invert_tuple really 
>>> required? As far as I can see all fields are set by the subsequent code.
>>
>> It dependfs on the protocol family. For IPv6 its completely
>> unnecessary, for IPv4 the last 12 bytes of each address need
>> to be zeroes. We could push this down to the protocols to
>> behave more optimally (actually something I started and didn't
>> finish some time ago).
> 
> Actually that really is necessary because we have padding in the
> tuple on at least ARM.

As you write the remaining 12 bytes for IPv4 can easily be handled in 
the l3protocol. The original tuple is already initialised properly and 
one would just have to replace things like
tuple->src.u3.ip = orig->dst.u3.ip;
with
tuple->src.u3.all = orig->dst.u3.all;
in nf_conntrack_l3proto_ipv4.c.

Why do you think the padding causes problems? For hashing e.g. src/dst 
.u3 and .u are referenced independently of potential padding. Where does 
access to the padding data occur?
