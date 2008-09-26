From: Philip Craig <philipc@snapgear.com>
Subject: Re: been a while...what happened to NFC_ALTERED?
Date: Fri, 26 Sep 2008 11:04:06 +1000
Message-ID: <48DC3506.6090201@snapgear.com>
References: <F6673A17-B622-4F71-AD50-E7E020B3A1C9@pactolus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Dave Horton <dhorton@pactolus.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:50343 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752796AbYIZBEI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2008 21:04:08 -0400
In-Reply-To: <F6673A17-B622-4F71-AD50-E7E020B3A1C9@pactolus.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dave Horton wrote:
> Can someone help me out?  What is the new improved way of indicating  
> that I've changed a packet's header or body so that netfilter re- 
> examines it?

In net/ipv4/netfilter/iptable_mangle.c, ipt_local_hook() saves the
the values which affect routing, then compares them after processing
the rules.  What are you changing that isn't covered by that already?
