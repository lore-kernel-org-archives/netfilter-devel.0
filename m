From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: blocking/allowing particular protocol
Date: Wed, 17 Mar 2004 12:00:35 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403171152170.6035-100000@filer.marasystems.com>
References: <0C674B14EAEBD61196D900B0D03DB49F01C1EA52@blrw502w.blr.infineon.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Kumar Shobhit (IFIN DC COM)" <Shobhit.Kumar@infineon.com>
In-Reply-To: <0C674B14EAEBD61196D900B0D03DB49F01C1EA52@blrw502w.blr.infineon.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 17 Mar 2004, Kumar Shobhit (IFIN DC COM) wrote:

> I am pretty new to all this stuff. I want to know if it is possible to
> block/allow a particular protocol. For example, HTTP can work on various
> ports, So instead of blocking/allowing a particular port can I
> allow/block HTTP itself i.e to allow HTTP traffic on any port.

It is not possible to reliably identify HTTP traffic, and further this is 
extremely hard to do correctly at packet level simply because you can not 
at all see the protocol data unless you accept the session to be set up 
and even allow forwarding of protocol payload until the protocol can be 
reliably identified by its payload.

The best way to do this reliably is by proxies. Set up a HTTP proxy and
have your clients configured to use this. Then block any direct access to
Internet not using the proxy.

> Another question which I couldn't find an answer to is, when in the
> conntrack/NAT code is the ip_nat_info structure initialized

It is set up by the NAT targets/helpers by calling ip_nat_setup_info, or
implicitly by the NAT table if there is no NAT target in the hook.

Regards
Henrik
