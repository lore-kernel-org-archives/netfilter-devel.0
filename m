From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: iptables and SPI...
Date: Fri, 31 Oct 2003 23:01:42 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310312251150.22626-100000@filer.marasystems.com>
References: <Law10-F5700goZolmRB000000bb@hotmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: dimitri borjac <dimitri_borjac@hotmail.com>
In-Reply-To: <Law10-F5700goZolmRB000000bb@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 31 Oct 2003, dimitri borjac wrote:

> So the problem is still there... is it possible to extend the NAT functions 
> of iptables in order to make the local gateway read and use the SPI for 
> NATting packets ?

You will need to write a ESP protocol conntrack module, similar to the UDP
or ICMP conntrack modules. Note however that this will only work assuming
it is the NAT:ed endpoint which sends the initial packet ESP per SPI. For 
situations where it is the other endpoint who sends the initial ESP packet 
for this SPI then you need to somehow decode IKE to know that the SPI has 
been negotiated. Unless my memory is wrong this may be a little hard due 
to encryption of the IKE protocol..

Regards
Henrik
