From: =?iso-8859-1?Q?Herv=E9?= Eychenne <rv@wallfire.org>
Subject: Re: Static NAT Ranges?
Date: Fri, 31 Jan 2003 17:04:02 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030131160402.GG956@comet.rv-int>
References: <200301250439.XAA31445@delanet.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Larry Stephan <jlarry@delanet.com>
Content-Disposition: inline
In-Reply-To: <200301250439.XAA31445@delanet.COM>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jan 24, 2003 at 11:39:58PM -0500, Larry Stephan wrote:

 Hi,

> I have worked both with netfilter (from ipfwadm through iptables) and with
> some commercial firewall packages.  I must say that netfilter is a remarkably
> capable system.  However, one feature which appears to be lacking is a
> convenient way to NAT address ranges statically: that is, for a given range
> of addresses, the NATted address would always differ from the original
> address by the same fixed amount. This is handy for fixing certain routing
> problems, as well as for changing ranges of address that may cause a
> conflict to more acceptable ranges, a not infrequent problem when different
> organizations establish dedicated network links.  I have attempted to find
> something like this on the netfilter web site, but (perhaps I missed
> something) I found nothing.
> 
> I was thinking that a --static option to SNAT and DNAT might do the trick.
> For example, (line broken because it doesn't fit well):
> 
> iptables -s 5.6.7.0/25 -t nat -A POSTROUTING 
> -o eth0 -j SNAT --static --to 1.2.3.64
> 
> would map 5.6.7.1 to 1.2.3.65, 5.6.7.2 to 1.2.3.66,...,5.6.7.126 to 1.2.3.190

I suppose you are looking for the NETMAP target, available in p-o-m.

Now I have a question for the coreteam... why not consider the
inclusion of NETMAP in upstream kernel?
It seems to me that this functionnality is quite standard, and I think
it has proved to be stable now, don't you think?
I have been using it in production systems for quite a long time now
without any problem.  Why keep it experimental?

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
