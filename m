From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH 4/5] Remove do_extra_mangle
Date: Thu, 18 Nov 2004 11:22:52 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411181120210.29563@filer.marasystems.com>
References: <1100756722.5865.55.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1100756722.5865.55.camel@localhost.localdomain>
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

On Thu, 18 Nov 2004, Rusty Russell wrote:

> On NF_IP_LOCAL_OUT, when destination NAT changes the destination
> interface, we also change the source address, so the packet is the
> same as if it were generated to go that way in the first place.  This
> is not strictly necessary, I believe.

I agree. If one needs this one can SNAT in POSTROUTING.

There is however a slight complication in policy routing setups which may 
not be as easy to get arount, but most people should manage to figure out 
how to adjust their routing policies I think.

Regards
Henrik
