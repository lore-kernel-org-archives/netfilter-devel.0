From: Patrick McHardy <kaber@trash.net>
Subject: Re: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's
 brain broke!)
Date: Mon, 12 Jan 2004 02:07:06 +0100
Sender: linux-net-owner@vger.kernel.org
Message-ID: <4001F33A.9000802@trash.net>
References: <20030725173900.E6E952C2AE@lists.samba.org> <200307251756.VAA12609@dub.inr.ac.ru> <20040111130114.GJ20706@sunbeam.de.gnumonks.org> <Pine.LNX.4.58.0401111517550.1161@u.domain.uli>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, kuznet@ms2.inr.ac.ru,
	Rusty Russell <rusty@rustcorp.com.au>, fenio@o2.pl,
	davem@redhat.com, linux-net@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>, boris@boris.ca,
	email@cs-ware.de, Jan.Schubert@GMX.li
Return-path: <linux-net-owner@vger.kernel.org>
To: Julian Anastasov <ja@ssi.bg>
In-Reply-To: <Pine.LNX.4.58.0401111517550.1161@u.domain.uli>
List-Id: netfilter-devel.vger.kernel.org

Julian Anastasov wrote:

>- provide oif learned from the input route (as before the discussed
>change). May be in 99% of the setups it selects the right route.
>I think, we should use this, at least for 2.4.
>
>  
>
Why should we do a route lookup at all ? MASQUERADE doesn't need the
dst_entry but only the interface address. Using ifa_list->ifa_local
of the outgoing in_device seems like the simplest solution to me.

Regards,
Patrick



