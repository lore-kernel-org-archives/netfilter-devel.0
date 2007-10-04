From: Patrick McHardy <kaber@trash.net>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Thu, 04 Oct 2007 09:59:23 +0200
Message-ID: <47049D5B.8050001@trash.net>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl> <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl> <Pine.LNX.4.64.0710031545320.31528@blackhole.kfki.hu> <4704812C.8080001@trash.net> <Pine.LNX.4.64.0710040926320.1587@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Oledzki <ole@ans.pl>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43551 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbXJDIAJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 04:00:09 -0400
In-Reply-To: <Pine.LNX.4.64.0710040926320.1587@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jozsef Kadlecsik wrote:
> Hi Patrick,
> 
> On Thu, 4 Oct 2007, Patrick McHardy wrote:
> 
>>Jozsef Kadlecsik wrote:
>>
>>>I think the code segment is correct. However, the end of the segment 
>>>is miscalculated by segment_seq_plus_len because the offset added to 
>>>'dataoff' by the get_l4proto function of IPv4/IPv6 is not taken into 
>>>account. Please check whether the patch below fixes it:
>>
>>Actually that offset should always be zero for anything but packets
>>encapsulated within ICMP, which don't pass though TCP conntrack.
> 
> 
> Here we calculate the sequence number of the last octet in the packet from 
> the actual data length of the skbuff, so by the 'dataoff' argument of 
> segment_seq_plus_len we must pass the length of the IP(v4|6) header. But 
> the 'dataoff' parameter supplied by the nf_conntrack core is larger by 
> skb_network_offset(skb) therefore 'dataoff' must be decremented by it 
> before passing to segment_seq_plus_len.


Right, I didn't express myself correctly. What I meant to say is that
skb_network_offset is always 0 while we're inside the IP(v6) layer.

