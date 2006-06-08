From: Patrick McHardy <kaber@trash.net>
Subject: Re: [LARTC] iptables CLASSIFY and MARK not working?
Date: Thu, 08 Jun 2006 09:41:59 +0200
Message-ID: <4487D4C7.9060604@trash.net>
References: <0633E0EDB4F25F43A2D7179CA11FAFAB255436@xavier.staff.greatlakes.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: lartc@mailman.ds9a.nl,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Eliot, Wireless and Server Administrator,
	Great Lakes Internet" <support8@greatlakes.net>
In-Reply-To: <0633E0EDB4F25F43A2D7179CA11FAFAB255436@xavier.staff.greatlakes.net>
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

Eliot, Wireless and Server Administrator, Great Lakes Internet wrote:
> Eh. What a pain. If I disable this, then ebtables will not call iptables
> after the ebtables are finished running. I figured out that I could use
> ebtables to match the destination MAC address like I needed for the
> other problem I posted (See "Bi-directional packet classification with
> ACK prioritization" thread for details). However, in order for that to
> work, I have to have bridge-nf-call-iptables enabled. Essentially, I can
> use the ebtables to flag the packets going to a destination MAC address
> and then inside the iptables POSTROUTING mangle chain, I can pick up
> that flag and reflag packets based on their Layer 3 and 4 information.
> But, then I run right back into the problem of this thread in that the
> packets are going through the TC qdiscs and classes before they hit the
> POSTROUTING mangle chain. 
> 
> Now, what confuses me is that I have this nice big printout of the order
> that the packets traverse ebtables, iptables, and tc which was made by
> Josh over at ImageStream (see
> http://ebtables.sourceforge.net/br_fw_ia/PacketFlow.png for the image)
> which clearly shows that it should go through ebtables POSTROUTING nat,
> then iptables POSTROUTING mangle, then iptables POSTROUTING nat, then TC
> qdisc classification, then TC qdisc deque. Also, after reading
> http://benix.tamu.edu/unix/linux-bridge-ebtables.htm, it seems pretty
> clear that the image depiction should be correct. But, since this is not
> happening, either the code has changed or both those sources are just
> wrong. 

I guess both are wrong.

> Do you happen to have any idea how I can get this straightened out? Do
> we need to rewrite part of the code to make this work correctly? If that
> is what it takes, I would be more than happy to look into doing that. 

Fixing this is one of my short-term TODO items, most likely before
2.6.18.

> Maybe we can write a --destination-mac option for the iptables MAC
> matching module? Is that information available to iptables in the
> POSTROUTING mangle or nat chains? If not, would it be at all possible to
> make it available? That would solve this problem very nicely.

No, iptables can't reliably get at this information (it might need
to be resolved first).
