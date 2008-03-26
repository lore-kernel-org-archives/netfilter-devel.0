From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 07/29] [NETFILTER]: remove arpt_table indirection macro
Date: Wed, 26 Mar 2008 21:35:40 +0100
Message-ID: <47EAB39C.3050004@trash.net>
References: <alpine.LNX.1.10.0803251914060.2240@fbirervta.pbzchgretzou.qr> <d77e5bacf4b9bb4fcc89fd261529a31c7c5002b2.1206469820.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40696 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbYCZUfm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2008 16:35:42 -0400
In-Reply-To: <d77e5bacf4b9bb4fcc89fd261529a31c7c5002b2.1206469820.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

Applied, but this triggered some warnings caused by the
constification patches I missed earlier:

net/ipv4/netfilter/arp_tables.c: In function 'compat_copy_entries_to_user':
net/ipv4/netfilter/arp_tables.c:1569: warning: passing argument 1 of 
'alloc_counters' discards qualifiers from pointer target type
net/ipv4/netfilter/arp_tables.c: In function 'compat_get_entries':
net/ipv4/netfilter/arp_tables.c:1628: warning: passing argument 1 of 
'xt_table_unlock' discards qualifiers from pointer target type
net/ipv4/netfilter/arp_tables.c: In function 'compat_copy_entries_to_user':
net/ipv4/netfilter/arp_tables.c:1569: warning: passing argument 1 of 
'alloc_counters' discards

Again, please test with CONFIG_COMPAT if you touch this code.
I'm leaving for tonight, please send me a patch on top of the
faulty one to fold in for fixing this.
