From: lmn@mail.xprtsol.com
Subject: Re: change ip address in the hook
Date: Tue, 30 Mar 2004 19:08:00 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040331000800.GB24425@mail.xprtsol.com>
References: <20040328215738.GA19392@mail.xprtsol.com> <40690211.4030606@netlab.hut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Content-Disposition: inline
In-Reply-To: <40690211.4030606@netlab.hut.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

Thanks so much. I just found out the reason may be that I didn't do IP checksum after I changed the source IP in the LOCAL_OUT hook. Is the ip_fast_csum() good to use here? Also I want to change the destination IP of an incoming packet in PRE_ROUTING hook, do I need to calculate the checksum at this point again?

I read the ipt_MIRROR.c and didn't see IP checksum there. Maybe it just exchanges source IP with destination IP, and the checksum algorithm will get the same result.

Regards,

LMN

On Tue, Mar 30, 2004 at 08:13:53AM +0300, Emmanuel Guiton wrote:
> 
> Hi!
> 
> Can you be a bit more precise in what you do when you "change the ip 
> address of a packet in the LOCAL_OUT hook and let it send out"? What are 
> all the operations you do? Which address (source / destination) do you 
> change? Do you calculate a new IP checksum after having changed the IP 
> address?
> 
>       Emmanuel
> 
> 
> lmn@mail.xprtsol.com wrote:
> 
> >Hi,
> >
> >For example, I want to change the ip address of a packet in the LOCAL_OUT 
> >hook and let it send out, but I didn't see the packet on the wire. (Route 
> >for the modified ip addresses existed.) Similar things happen for the 
> >PRE_ROUTING hook. This is like doing the NAT manually.
> >
> >If I use iptables command to add a rule doing the similar function, I can 
> >see the packet was sent out. So what is the difference inside these two 
> >approaches?
> >
> >Thanks,
> >
> >LMN
> >
> > 
> >
> 
> 
