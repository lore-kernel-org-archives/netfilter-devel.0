From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Mangle on a Connection, not on a Packet
Date: Thu, 16 Oct 2003 16:30:44 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310161629230.8635-100000@filer.marasystems.com>
References: <200310161109.h9GB9lm16121@singularity.tronunltd.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ian Latter <Ian.Latter@mq.edu.au>
In-Reply-To: <200310161109.h9GB9lm16121@singularity.tronunltd.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 16 Oct 2003, Ian Latter wrote:

> I want to extend the functionality of the XOR module.  I am cool with
> the connection tracking helper concepts, and I am cool with the way XOR
> is doing its mangling as a target .. but what I'm not so cool with is
> how I register my intent to mangle a "connection" with conntrack, rather
> than the currently registerd mangle .. per a packet .. as with the
> target.

For this purpose I think you should be able to use the CONNMARK patch to 
mark the connection. The CONNMARK patch provides you with a 32bit piece of 
memory per conntrack, and can be used very much like the MARK target.

Regards
Henrik
