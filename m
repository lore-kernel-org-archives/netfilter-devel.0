From: Pawel Hadam <Pawel.Hadam@imag.fr>
Subject: Re: Outgoing interface selection by source address
Date: Thu, 27 Nov 2003 16:30:47 +0100 (MET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.GSO.4.33.0311271630380.21059-100000@horus.imag.fr>
References: <Pine.LNX.4.44.0311271618450.26423-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0311271618450.26423-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 27 Nov 2003, Henrik Nordstrom wrote:

> > connection (src0, dst) are routed via eth1. And I would like them to
be
> > routed via interface eth0, as src0 is the address of eth0 not eth1.
>
> For this you need to use policy routing. I assume this exists in IPv6 as
> well as it does in IPv4. This question is not really iptables related.
> For IPv4 see the Linux advanced routing howto for details.

Thanks, I am affraid it works only with IPv4 (and not with IPv6), so I
asked here for some other solution.

Regards
Pawel
