From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnetfilter_queue and libnetfilter_conntrack API questions
Date: Wed, 09 Apr 2008 16:46:02 +0200
Message-ID: <47FCD6AA.8030205@netfilter.org>
References: <47FCCD6C.6050409@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Thomas Mader <thezema@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32917 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753132AbYDIOqM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 10:46:12 -0400
In-Reply-To: <47FCCD6C.6050409@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas Mader wrote:
> Hello,
> 
> why is it that I cannot get the conntrack ID when I set up a callback
> function for DESTROY events with libnetfilter_conntrack?
> When I do
> 
> int id = nfct_get_attr_u32(ct, ATTR_ID);
> printf("delete ID: %d\n", id);
> 
> in my callback function. The id I get is always 0.
> It works for conntrack dumps but not for events it seems.

The events do not include the ID, this is how it goes as for now.
Actually I'm not a big fun of the ID.

@Patrick: I don't remember exactly the reason why we decided to keep the
ID there, and if we have decided to do so, it seems inconsistent to me
not to include it in the events.

> The other question I have is the following.
> I need to port a kernelspace netfilter module to userspace. It deals
> with udp and icmp packets, and in kernelspace I have the match function
> as a callback and in that match function I grab the corresponding
> conntrack tuple for the incoming packet to get the conntrack id. With
> this id I can search a list, if this connection is already in that list,
> and can update information in that list or add the connection to the
> list if it is not yet in that list.
> I also have a notifier callback function where I get notified when a
> connection was deleted. I need this to get the id of the deleted
> connection and delete it as well in my list with connections.
> Now the question is, how I can do this in userspace. I managed to get
> the match function from kernelspace ported to userspace by using
> libnetfilter_queue API. But to implement the delete notifier and to get
> the conntrack id I need to use libnetfilter_conntrack API where the
> problems arise.
> I need
> 
> while ((rv = recv(fd, buf, sizeof(buf), 0)) && rv >= 0) {
>         nfq_handle_packet(h, buf, rv);
> }
> 
> to handle packets with my libnetfilter_queue callback function. But if I
> want to get notified by conntrack for delete events I need nfct_catch,
> which also blocks my program.
> So my question is, if I need to spawn multiple threads to get it done or
> if there is another solution?

I'd prefer polling from both sockets instead of using threads, you can
access the socket descriptors via nfct_fd() and nfq_fd().

Anyway, the main problem that I see is that you'll have to delay the
packet verdict until you receive the conntrack event, otherwise you risk
to have a race condition. However, I think that the solution would not
be that performant.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
