From: Patrick McHardy <kaber@trash.net>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Thu, 04 Oct 2007 07:59:08 +0200
Message-ID: <4704812C.8080001@trash.net>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl> <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl> <Pine.LNX.4.64.0710031545320.31528@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Oledzki <ole@ans.pl>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40792 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759423AbXJDF7v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 01:59:51 -0400
In-Reply-To: <Pine.LNX.4.64.0710031545320.31528@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jozsef Kadlecsik wrote:
> I think the code segment is correct. However, the end of the segment 
> is miscalculated by segment_seq_plus_len because the offset added to 
> 'dataoff' by the get_l4proto function of IPv4/IPv6 is not taken into 
> account. Please check whether the patch below fixes it:


Actually that offset should always be zero for anything but packets
encapsulated within ICMP, which don't pass though TCP conntrack.
