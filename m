From: Patrick McHardy <kaber@trash.net>
Subject: Re: Implementation of Ebtables target similar to QUEUE
Date: Fri, 19 Oct 2007 10:24:36 +0200
Message-ID: <471869C4.1010606@trash.net>
References: <2688.41803.qm@web7913.mail.in.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Abhinav Srivastava <abhinavs_iitkgp@yahoo.co.in>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60869 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127AbXJSIZP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Oct 2007 04:25:15 -0400
In-Reply-To: <2688.41803.qm@web7913.mail.in.yahoo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Abhinav Srivastava wrote:
> Hi Patrick,
> 
> I tried to do what you said but some how could not
> achieve it and since project deadlines are so pressing
> I would like to achieve the same thing but from the
> user space.
> 
> Inside the ebtables code, I intercept packets and send
> it to userspace application, which decides whether to
> accept the packet or drop it and re-inject it to the
> network. I heard it can be done for iptables but can
> it be done for ebtables?
> 
> I saw libipq which provides you functionality of
> reinjecting the packets into ipfilters ip queue.
> 
> I would like to reinject the packet to ebtable
> filtering code or if not then directly out to the
> interface if I decide packet is to be accepted. Please
> let me know if this deisgn is possible. I also ok with
> passing the packet using libipq to ipfilters as long
> as they can send the packet out to network. I just
> want to achieve the complete design with minimum
> hassle because of deadline.
> 
> I would really appreciate your help.


Well, the iptables queuing depends on exactly the QUEUE
functionality I described, you'll need to add this to
the briding code, otherwise it won't work.
