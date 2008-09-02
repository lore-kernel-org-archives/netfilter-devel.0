From: David P Olshefski <olshef@us.ibm.com>
Subject: Re: crash in ebtables 2.0.8-2
Date: Tue, 2 Sep 2008 16:01:48 -0400
Message-ID: <OFDA147441.03CF7CC2-ON852574B8.006DD446-852574B8.006E0312@us.ibm.com>
References: <OFFFED554A.21EFA010-ON852574AA.004C56D5-852574AA.004C7C94@us.ibm.com> <48BBE8DD.6000909@trash.net> <OF3C594B6C.8BB42C38-ON852574B8.005B1042-852574B8.005B2AB3@us.ibm.com> <48BD7B39.3070700@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55240 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbYIBUCV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2008 16:02:21 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m82K4lle012877
	for <netfilter-devel@vger.kernel.org>; Tue, 2 Sep 2008 16:04:47 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m82K22oH224738
	for <netfilter-devel@vger.kernel.org>; Tue, 2 Sep 2008 16:02:02 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m82K22AO004692
	for <netfilter-devel@vger.kernel.org>; Tue, 2 Sep 2008 16:02:02 -0400
In-Reply-To: <48BD7B39.3070700@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Good question, but I am sorry to say I don't  know....I noticed in the 
latest version it was fixed...the fix was very simple so I just did it by 
hand, without applying a patch.


David O.



Patrick McHardy <kaber@trash.net> 
09/02/2008 01:43 PM

To
David P Olshefski/Watson/IBM@IBMUS
cc
netfilter-devel@vger.kernel.org
Subject
Re: crash in ebtables 2.0.8-2






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



