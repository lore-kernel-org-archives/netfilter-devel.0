From: Brad Fisher <brad@info-link.net>
Subject: Re: Time match in mangle/POSTROUTING?
Date: Tue, 02 Dec 2003 18:55:17 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FCD3475.D4D0A063@info-link.net>
References: <3FCD2AA1.6F5E0225@info-link.net> <3FCD305F.4040406@trash.net> <3FCD3306.50603@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
        fabrice@netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Thanks for the input :)  I'll take a look at this and will send a patch if I
can get it working.  BTW:  is there an easy way in the kernel to determine
whether DST is in effect or not?  I've noticed that the time match always seems
to be based off standard time.  I'm not very familiar with the internals of the
kernel...

-Brad

Patrick McHardy wrote:

> Patrick McHardy wrote:
>
> > POSTROUTING packets don't neccessarily have a timestamp since packets are
> > stamped when they are received which doesn't happen for locally generated
> > traffic. In the source I can see an option "kerneltime" which uses
> > gettimeofday, this should work fine in any chain. The patch does work in
> > OUTPUT, it uses kerneltime automatically then (and also unneccesarrily
> > in FORWARD). A correct fix would require using kerneltime in OUTPUT
> > and POSTROUTING and the skb stamp otherwise.
>
> Even better, in POSTROUTING only use the kerneltime when the skb stamp
> is unset, that way you save expensive gettimeofday calls for forwarded
> packets.
> To make it clean, just remove the kerneltime option completely and only
> look if the stamp is set or unset.
>
> >
> > Best regards,
> > Patrick
> >
> >
> >
> > Brad Fisher wrote:
> >
> >> I'm curious why the time match doesn't work in POSTROUTING?  I have an
> >> application where it would be helpful to use it as such and was
> >> wondering if there was a good technical reason why it shouldn't work.
> >> If I modified the source to allow it to be added to the POSTROUTING
> >> chain, would it work as expected?  I'm assuming it won't be as simple as
> >> that...
> >>
> >> -Brad
> >>
> >>
> >
