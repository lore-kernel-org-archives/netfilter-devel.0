From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Outgoing interface selection by source address
Date: Thu, 27 Nov 2003 16:20:35 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311271618450.26423-100000@filer.marasystems.com>
References: <Pine.GSO.4.33.0311271440290.5552-100000@horus.imag.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pawel Hadam <Pawel.Hadam@imag.fr>
In-Reply-To: <Pine.GSO.4.33.0311271440290.5552-100000@horus.imag.fr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 27 Nov 2003, Pawel Hadam wrote:

> connection (src0, dst) are routed via eth1. And I would like them to be
> routed via interface eth0, as src0 is the address of eth0 not eth1.

For this you need to use policy routing. I assume this exists in IPv6 as 
well as it does in IPv4. This question is not really iptables related.

For IPv4 see the Linux advanced routing howto for details.

Regards
Henrik
