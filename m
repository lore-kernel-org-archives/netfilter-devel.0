From: Abhinav Srivastava <abhinavs_iitkgp@yahoo.co.in>
Subject: Re: Implementation of Ebtables target similar to QUEUE
Date: Wed, 24 Oct 2007 00:12:29 +0100 (BST)
Message-ID: <24362.80553.qm@web7903.mail.in.yahoo.com>
References: <471869C4.1010606@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from web7903.mail.in.yahoo.com ([202.86.4.79]:46111 "HELO
	web7903.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752597AbXJWXMc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Oct 2007 19:12:32 -0400
In-Reply-To: <471869C4.1010606@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--- Patrick McHardy <kaber@trash.net> wrote:

> Abhinav Srivastava wrote:
> > Hi Patrick,
> > 
> > I tried to do what you said but some how could not
> > achieve it and since project deadlines are so
> pressing
> > I would like to achieve the same thing but from
> the
> > user space.
> > 
> > Inside the ebtables code, I intercept packets and
> send
> > it to userspace application, which decides whether
> to
> > accept the packet or drop it and re-inject it to
> the
> > network. I heard it can be done for iptables but
> can
> > it be done for ebtables?
> > 
> > I saw libipq which provides you functionality of
> > reinjecting the packets into ipfilters ip queue.
> > 
> > I would like to reinject the packet to ebtable
> > filtering code or if not then directly out to the
> > interface if I decide packet is to be accepted.
> Please
> > let me know if this deisgn is possible. I also ok
> with
> > passing the packet using libipq to ipfilters as
> long
> > as they can send the packet out to network. I just
> > want to achieve the complete design with minimum
> > hassle because of deadline.
> > 
> > I would really appreciate your help.
> 
> 
> Well, the iptables queuing depends on exactly the
> QUEUE
> functionality I described, you'll need to add this
> to
> the briding code, otherwise it won't work.
> 

> 


Hi Patrick,

Thanks for your reply. I have started looking into the
code of ebtables in order to implement the
functionality. However I got curious by reading
somewhere that iptables can be used to filter packets
at bridge level. Is this correct?

Since I am not doing any MAC level filtering, I am
getting hold of sk_buff reference from ebtables code
and then doing my own thing. Can I use iptables for
this purpose? If yes, then is it possible to use
iptables QUEUE and re-injection facilities here? OR
again it is the same problem that packets are passing
through bridge and iptables QUEUE and re-injection
code  will drop the packet when it sees bridge
protocol and other problems that you mentioned before.

Regards,
Abhinav





      Forgot the famous last words? Access your message archive online at http://in.messenger.yahoo.com/webmessengerpromo.php
