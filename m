From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] MASQUERADE handling of device events
Date: Wed, 24 Nov 2004 10:24:34 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411241018270.15946@filer.marasystems.com>
References: <20041107181825.GA3522@linuxace.com>
	<1101005908.18919.11.camel@localhost.localdomain>
	<20041123211623.GA20289@linuxace.com>
	<1101267454.6186.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1101267454.6186.13.camel@localhost.localdomain>
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

On Wed, 24 Nov 2004, Rusty Russell wrote:

> Drawing a link between point-to-point and addresses being static is
> wrong, IMHO.

Agreed.

This discussion is equally important on Ethernet with dynamic IP 
assignment. Here the interface name is defenitely static.

As already discussed very many times MASQUERADE is a best effort to handle 
the common "dial up like" with dynamic Internet IP assignment scenarios in 
an easy manner.  A multiple PPP situation is more of an exception than 
rule to this, and in addition userspace has the option of using statically 
reserved PPP devices for the connections in question to make the proposed 
MASQUERADE fully predictable in such situations.

Regards
Henrik
