From: "Morgon J. Kanter" <morgon.j.kanter@dartmouth.edu>
Subject: Re: Packet Injection within netfilter module
Date: Tue, 13 Apr 2010 15:36:21 -0400
Message-ID: <201004131536.21680.morgon.j.kanter@dartmouth.edu>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub24.dartmouth.edu ([129.170.5.24]:40407 "EHLO
	mailhub24.dartmouth.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab0DMUo4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:44:56 -0400
Received: from mewtwo.localnet ([129.170.71.61])
	(authenticated bits=0)
	by mailhub24.dartmouth.edu (8.13.5/DND2.0/8.13.5) with ESMTP id o3DKb7gN005226
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Apr 2010 16:37:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Is there any way to inject a newly created packet based on the
> captured packet inside a netfilter hook call back function?
> My Goal is to capture a packet change compress its tcp payload and
> send it. i read ipcomp.c and i used its source. when i change skb size
> (like len) and tail pointer kernel hangs. maybe the way to do, is to
> create a new packet based on captured packet and ask kernel to send
> it. I just don't know how to ask kernel to send a newly created
> packet?

I've been looking to do something similar, and running into my own questions.

First, does your newly created packet completely replace the old, uncompressed 
packet? Because then you should be able to just issue an ACCEPT verdict to the 
packet, but pass along new payload data for said packet as part of issuing the 
verdict.

As I said, I've been looking to do something similar (and in fact just joined 
this list with the hope of getting some answers) -- would you then have to go 
and change, say, the TCP windows? At the very least it seems you'll need to 
mangle the returning ACK numbers to the uncompressed value, so the original 
packet's sender gets the correct acknowledgment. Is there a way to handle this 
automatically in the Linux kernel? It seems like this would be a valuable 
thing to implement as part of queue/conntrack if it's not implemented already 
-- is it?

I ask because I will need to implement exactly this functionality if it's not 
already around. I'm also trying to figure out the best place to put it.

Thanks,
-- Morgon
