From: Patrick McHardy <kaber@trash.net>
Subject: Re: crash in ebtables 2.0.8-2
Date: Tue, 02 Sep 2008 19:43:21 +0200
Message-ID: <48BD7B39.3070700@trash.net>
References: <OFFFED554A.21EFA010-ON852574AA.004C56D5-852574AA.004C7C94@us.ibm.com> <48BBE8DD.6000909@trash.net> <OF3C594B6C.8BB42C38-ON852574B8.005B1042-852574B8.005B2AB3@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: David P Olshefski <olshef@us.ibm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38067 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbYIBRnY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2008 13:43:24 -0400
In-Reply-To: <OF3C594B6C.8BB42C38-ON852574B8.005B1042-852574B8.005B2AB3@us.ibm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David P Olshefski wrote:
> Yep, I found the bug, and discovered it was fixed in a newer release.

Just in case someone runs into this again, which patch fixed it
exactly? Thanks.

> 
>> [<ffffffff88288d2a>] :ebtables:translate_table+0x62a/0x1060 
> 
> 
> This appears to be an ancient kernel. Could you retry with 2.6.26
> please?
> 
> 

