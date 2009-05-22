From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: conntrack and RSTs received during CLOSE_WAIT
Date: Fri, 22 May 2009 10:54:47 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0905221047190.14889@blackhole.kfki.hu>
References: <4A0DE859.7000209@tigertech.com> <4A0F7FEE.3010405@tigertech.com>  <4A139222.2020505@tigertech.com>  <alpine.DEB.2.00.0905200904310.10018@blackhole.kfki.hu>  <4A1466F6.8070304@tigertech.com>  <alpine.DEB.2.00.0905202327240.11796@blackhole.kfki.hu>
  <alpine.DEB.2.00.0905211729090.13699@blackhole.kfki.hu>  <4A15A156.6030400@tigertech.com>  <38db14850905212132x3d4f4d83y6808ad89d2d79324@mail.gmail.com>  <alpine.DEB.2.00.0905220917190.14889@blackhole.kfki.hu>
 <38db14850905220126t55f0e754y6c65cbfaed533bc0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Anatoly Muliarski <x86ever@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:43143 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbZEVIyq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 May 2009 04:54:46 -0400
In-Reply-To: <38db14850905220126t55f0e754y6c65cbfaed533bc0@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 22 May 2009, Anatoly Muliarski wrote:

> > This is the main problem: we can never be sure the packets which are seen
> > by firewall do really reach the destination or they order is preserved.

> We could save the LAST sequence number as a current one.
> So we keep the connection and mark the current RST as invalid and
> correctly react on the following ones. Unfortunately this does not
> solve the main problem - unable to know whether the received sequence
> number is valid or not. As an vague idea - we could track the ack
> number from other direction and so keep the last delivered sequence
> number. What can say about it?

Relying on the last ACK received from the other direction looks promising. 
We record the last (highest) ACK sent by both endpoints, which makes sure 
the packet they ack they did indeed received. And we accept a RST segment 
only if it's in the window we calculate (wider than the destination's) AND 
equal or higher than the saved last ACK from the other direction.

The only downside is that new fields must be added to struct ip_ct_tcp.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
