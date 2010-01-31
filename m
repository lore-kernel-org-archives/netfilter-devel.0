From: "Helight.Xu" <helight.xu@gmail.com>
Subject: [REPORT] may be wrong place #endif in include/linux/netfilter_ipv4.h
Date: Sun, 31 Jan 2010 10:13:06 +0800
Message-ID: <4B64E732.3090507@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>, coreteam@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f172.google.com ([209.85.222.172]:57337 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab0AaCIz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Jan 2010 21:08:55 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hi all gys:

    when I make LKM with netfilter on "NF_IP_PRE_ROUTING" point, but it 
was reported that "NF_IP_PRE_ROUTING" is not defined.

    but I am surely including <linux/netfilter_ipv4.h>, when I opened 
include/linux/netfilter_ipv4.h I found that
"NF_IP_PRE_ROUTING" is in this lable :
#ifndef __KERNEL__
.....
/* IP Hooks */
/* After promisc drops, checksum checks. */
#define NF_IP_PRE_ROUTING       0
/* If the packet is destined for this box. */
#define NF_IP_LOCAL_IN          1
/* If the packet is destined for another interface. */
#define NF_IP_FORWARD           2
/* Packets coming from a local process. */
#define NF_IP_LOCAL_OUT         3
/* Packets about to hit the wire. */
#define NF_IP_POST_ROUTING      4
#define NF_IP_NUMHOOKS          5
#endif /* ! __KERNEL__ */

So I think the "endif" is ended a little early!

-- 
Zhenwen Xu - Seven Helight
Home Page: http://zhwen.org

