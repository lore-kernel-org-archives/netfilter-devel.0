From: Abhinav Srivastava <abhinavs_iitkgp@yahoo.co.in>
Subject: Re: Implementation of Ebtables target similar to QUEUE
Date: Fri, 28 Sep 2007 22:26:04 +0100 (BST)
Message-ID: <132825.81500.qm@web7901.mail.in.yahoo.com>
References: <46FD6EB6.1060603@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from web7901.mail.in.yahoo.com ([202.86.4.77]:37750 "HELO
	web7901.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753235AbXI1V0G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:26:06 -0400
In-Reply-To: <46FD6EB6.1060603@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



--- Patrick McHardy <kaber@trash.net> wrote:

> Abhinav Srivastava wrote:
> > Hi there,
> >
> > I have questions regarding the extension of
> ebtables
> > code to support target similar to QUEUE target. In
> my
> > project, I have a requirement of intercepting
> packets
> > inside ebtables and pass some information related
> to
> > packet to userspace tool. Ebtables code should
> wait to
> > receive reply from userspace tool and then drop or
> > accept packet. Since, ebtables code run in the
> context
> > of interrupt's bottom half, I cannot wait inside
> that
> > code path.
> >
> > To avoid that problem, I would like to create
> queues
> > inside ebtables so that I could put that packet
> into
> > the queue and start processing the next packet. I
> can
> > have other design where I send packets to
> userspace
> > and let userspace tool handle the packets. But, I
> do
> > not want to cross the user-kernel boundary for
> each
> > packet.
> >
> > I need help in order to achieve my first design:
> >
> > 1) Is my requirement very complex? Can it be
> achieved
> > easily?
> >
> > 2) What are the parts of ebtables code i should
> > change?
> >
> > 3) In case, userspace tool says accept the packet.
> How
> > I would implement the fucntionality of getting old
> > packets from queue and send them out of the
> network or
> > for incoming packets send to higher level
> protocols?
> >
> > 4) Is there any effective way for creating queues
> > inside ebtables?
> >
> > I would really appreciate any help or suggestions
> in
> > this regard?
> 
> The ebtables part is very easy, just add a target
> that returns
> NF_QUEUE. For the actually queueing and reinjection
> use
> nfnetlink_queue. The two slightly harder parts are:
> 
> - Fix the netfilter hooks in the briding code to
> handle
> queued packets, which requires to provide proper
> okfns
> to NF_HOOK that continue packet processing path
> after
> reinjection.
> 
> - Fix __nf_queue to not fail when the afinfo lookup
> is
> unsuccessful.
> 
> That should be all thats necessary.
> 

Hi Patrick,

Thanks for your quick reply. I understood the first
part but did not get the second harder part
completely.

Could you please shed some more light on that and also
it would be great if you could give me some pointer
for  target files that I may need to look into.

Thanks,
Abhinav




      Why delete messages? Unlimited storage is just a click away. Go to http://help.yahoo.com/l/in/yahoo/mail/yahoomail/tools/tools-08.html
