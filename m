From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: QUEUE target and IPT_CONTINUE verdict ?
Date: Mon, 16 May 2005 12:02:31 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0505161156560.17404@filer.marasystems.com>
References: <200505131729.39430.laurent.guyon@adelux.fr>
	<876ef97a05051510053c6827c2@mail.gmail.com>
	<Pine.LNX.4.61.0505152244290.28907@filer.marasystems.com>
	<200505161201.02379.laurent.guyon@adelux.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: nf-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Laurent Guyon <laurent.guyon@adelux.fr>
In-Reply-To: <200505161201.02379.laurent.guyon@adelux.fr>
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

On Mon, 16 May 2005, Laurent Guyon wrote:

> Then, if I understand well, what I want to do isn't really possible this way.

Not easily anyway.

> If I can't reinject my packets in Netfilter from the QUEUE target, maybe I
> could systemacally return NF_DROP as verdict, and forge (from my userspace
> tool) new packets, identical but marked, with libnet to re-emit them, so they
> will pass again in Netfilter ?

Does not sound very good, but it depends on what kind of modifications you 
need to do to the packets and why you want them to be seen again by the 
same hook. There is complications from connection tracking etc if this is 
not done carefully.

So the key question is why do you need the packets to pass thru the same 
hook again?

Perhaps if you described what it is you are trying to accomplish at a 
higher level we could give you an advice how to best do this. The Linux 
kernel is quite multi-faceted in its networking capabilities and 
interfaces and almost always there is more than one way to approach any 
given problem.

Regards
Henrik
