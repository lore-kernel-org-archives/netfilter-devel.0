From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: NAT for IPv6
Date: Fri, 21 Nov 2003 14:22:06 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031121132206.GA3421@balabit.hu>
References: <20031120174847.GA2254@balabit.hu> <Pine.LNX.4.44.0311210110290.23998-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311210110290.23998-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

[Removed direct Cc's and left netfilter-devel as this topic might not be too
interesting to them]

On Fri, Nov 21, 2003 at 01:24:15AM +0100, Henrik Nordstrom wrote:
> > - transparency
> >   - because there are protocols which do not have a proxy mode 
> >   - because they do not want to reconfigure their clients when a firewall
> >     is installed.
> 
> And these points I say should not be taken for granted when moving to a 
> IPv6 environment.
> 
> There is very few protocols which can not be proxied using the proper 
> tools. And given some thought clients should not be needed to be manually 
> reconfigured when installing a firewall.

I can't how this would be implemented when a legacy protocol is ported. 

> 
> > I can see cases when end-to-end IP connections are a must, but there are
> > other cases when proxying is the only viable solution, and I can't see why
> > we can't have a solution for both worlds.
> 
> I am not against proxying (quite naturally given who I am). What I am
> against is violation of the fundamental end-to-end property of IP. Per
> definition proxying is not a violation of end-to-end, transparent
> interception is.

In my sense firewalls have nothing but a DROP rule in their FORWARD chain,
and I can't see how end-to-end IP communication can be established through a
DROP rule :)

> In the state of IPv4 it is unfortunately a neccesary bad due to the large
> installed base of dumb applications not capable of using proxies. The
> situation in IPv6 is better and in my opinion in a position allowing this
> kind of problems to be solved at the application level without having to 
> resort to "dirty hacks".

I think there are too many legacy application protocols being ported
to IPv6 without any application layer change.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
