From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: BUG: sleeping function called from invalid context
Date: Sat, 13 Jun 2009 11:42:04 +0200
Message-ID: <4A33746C.6030103@trash.net>
References: <20090610161935.0f8b1949@osiris.boeblingen.de.ibm.com> <4A2FC2C2.7090803@trash.net> <OFEF049E33.787CFA3F-ON652575D3.00227835-652575D3.00288292@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@inl.fr>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Andreas Krebbel <krebbel1@de.ibm.com>,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Maran Pakkirisamy <maranpsamy@in.ibm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33609 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbZFMJmE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Jun 2009 05:42:04 -0400
In-Reply-To: <OFEF049E33.787CFA3F-ON652575D3.00227835-652575D3.00288292@in.ibm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Maran Pakkirisamy wrote:
> I have tested the patch against Vanilla Linux 2.6.30 RC8. The issue with 
> netfilter is fixed with the given patch . Thanks a lot!

Thanks, I'll send it upstream today.


