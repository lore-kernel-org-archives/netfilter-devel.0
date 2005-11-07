From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: [PATCH] owner-socketlookup update for 2.6.10
Date: Mon, 07 Nov 2005 12:03:37 +0200
Message-ID: <436F2679.40008@outerspace.dyndns.org>
References: <4211F586.7020106@niksula.hut.fi>	
	<20050216133807.GW3829@sunbeam.de.gnumonks.org>	
	<5b698f5a0510201037k3a246f09g4cb92eb83b1910ca@mail.gmail.com>	
	<43581A61.4020103@outerspace.dyndns.org>
	<5b698f5a0510221522s51c9d579q45c7afa3a92f8a31@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <5b698f5a0510221522s51c9d579q45c7afa3a92f8a31@mail.gmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Norman Rasmussen wrote:
> I tried changing (in udp.h):
>
> extern struct sock *udp_v4_lookup
>
> to
>
> extern static struct sock *udp_v4_lookup
>
> but now gcc tells me:
>
> include/net/udp.h:77: error: multiple storage classes in declaration
specifiers
>
> :-(
>
> any tips on getting an __inline__ function to be recognised
> externally, or are they mutually exclusive?

In udp.c you should change

static __inline__ struct ...

to

extern __inline__ struct ...

And in udp.h you should have

extern struct ...

I hope it works out. Sorry for the late reply :(

- xkr47
