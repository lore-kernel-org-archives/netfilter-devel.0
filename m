From: "Jing Min Zhao" <zhaojingmin@hotmail.com>
Subject: Re: New H.323 conntrack & NAT helper module
Date: Sat, 25 Feb 2006 01:00:00 -0500
Message-ID: <BAY109-DAV1E3EEAC01132FB3EE2E2EB3F00@phx.gbl>
References: <925A849792280C4E80C5461017A4B8A2032119@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Greg Scott" <GregScott@InfraSupportEtc.com>,
	<netfilter-devel@lists.netfilter.org>
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

On Friday February 24, 2006 11:00 PM,  Greg Scott wrote:
>
> Holey moley - this is GREAT news!!

Thanks!

> A couple questions.  Will this module work with 2.6.16 and upcoming
> newer kernels?

Yes. I'll keep tracking the kernel development. Once a big version comes 
out,
I'll update this patch. I think maybe Patrick McHardy is inspecting my code, 
if
I'm lucky, it may go into the kernel tree, and you won't need a separate 
patch
any more. I really hope so.

>  And - this is a biggie - the documentation says all I
> need to do is SNAT TCP 1720 for outbound calls and DNAT TCP 1720 for
> inbound calls.  No more tinkering by hand with zillions of TCP/UDP ports
> - no more trying to figure out if Polycom or Tandberg or whatever is on
> which end.  Is this really true???

Yes, and it's more than that. Actually, you don't need to specify the port 
1720 -
the module knows it, unless you want NAT only H.323 traffic. For inbound 
calls,
if you use a gatekeeper, you don't need the DNAT rule.

>  Will this patch really figure out
> and track the dynamic ports these devices use by default?

Yes.

> If so, then
> HOT DOGGIES!!!!

:)

> Also - will it work with proxy ARP?

This does nothing to do with the module. Sorry I'm not sure.

> Let's say I proxy ARP an H.323
> device behind the firewall.  Will this patch still handle connection
> tracking, even though there is no NAT?

Yes, it support this mode. Just don't load ip_nat_h323, load only
ip_conntrack_h323.

> The idea is, I would put a rule
> in the FORWARD table for TCP 1720 and the patch would "know" it's an
> H.323 device and also track and forward the appropriate TCP and UDP
> ports.  But it would be to a public IP Address proxy ARP'd behind the
> firewall instead of a NAT'd device.
>
> thanks
>
> - Greg Scott

Thanks

Jing Min Zhao
