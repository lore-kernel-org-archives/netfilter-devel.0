From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's brain broke!)
Date: Mon, 12 Jan 2004 15:30:14 +1100
Sender: linux-net-owner@vger.kernel.org
Message-ID: <20040112234710.1B13C2C0C4@lists.samba.org>
References: <4001F33A.9000802@trash.net>
Cc: Harald Welte <laforge@netfilter.org>, kuznet@ms2.inr.ac.ru,
	Rusty Russell <rusty@rustcorp.com.au>, fenio@o2.pl,
	davem@redhat.com, linux-net@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>, boris@boris.ca,
	email@cs-ware.de, Jan.Schubert@GMX.li
Return-path: <linux-net-owner@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
In-reply-to: Your message of "Mon, 12 Jan 2004 02:07:06 BST."
             <4001F33A.9000802@trash.net>
List-Id: netfilter-devel.vger.kernel.org

In message <4001F33A.9000802@trash.net> you write:
> Julian Anastasov wrote:
> 
> >- provide oif learned from the input route (as before the discussed
> >change). May be in 99% of the setups it selects the right route.
> >I think, we should use this, at least for 2.4.
> >
> >  
> >
> Why should we do a route lookup at all ? MASQUERADE doesn't need the
> dst_entry but only the interface address. Using ifa_list->ifa_local
> of the outgoing in_device seems like the simplest solution to me.

You take all the fun out.

Yes, this is the best.  It always does *something*, and is
predictable.  People with really complex routing shouldn't really use
MASQUERADE, since it's designed for a specific, simple case.

Patch?

Cheers,
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
