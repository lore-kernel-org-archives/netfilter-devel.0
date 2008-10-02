From: Patrick McHardy <kaber@trash.net>
Subject: Re: [net-next PATCH 00/16] Transparent proxying patches, take six
Date: Thu, 02 Oct 2008 17:38:10 +0200
Message-ID: <48E4EAE2.7040506@trash.net>
References: <20081001142431.4893.48078.stgit@este> <48E4CAAA.3030000@treenet.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60854 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbYJBPjM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Oct 2008 11:39:12 -0400
In-Reply-To: <48E4CAAA.3030000@treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Amos Jeffries wrote:
>
> Now that these patches got accepted. Can anyone update me on what 
> release of iptables and/or kernel are expected to have native TPROXY 
> target support? 
Kernel 2.6.28 and the corresponding iptables release (which should be 
1.4.3) will
contain all of this.


