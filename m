From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: NAT for IPv6
Date: Sat, 22 Nov 2003 13:23:16 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311221301120.20371-100000@filer.marasystems.com>
References: <16319.2729.387658.806467@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-nfil@isis.cs3-inc.com>
In-Reply-To: <16319.2729.387658.806467@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 21 Nov 2003, Don Cohen wrote:

> I also don't see that IPV6 reduces my need for NAT.
> For instance, my ISP will probably still give me only one IP address
> that I'll want to share with my home network.

Not if they follow the recommendations on IPv6 address assignment.

[RFC3177]
3. Address Delegation Recommendations


   The IESG and the IAB recommend the allocations for the boundary
   between the public and the private topology to follow those general
   rules:
   
      -  /48 in the general case, except for very large subscribers.
      -  /64 when it is known that one and only one subnet is needed by
         design.
      -  /128 when it is absolutely known that one and only one device
         is connecting.

   In particular, we recommend:

      -  Home network subscribers, connecting through on-demand or
         always-on connections should receive a /48.
      -  Small and large enterprises should receive a /48.
      -  Very large subscribers could receive a /47 or slightly shorter
         prefix, or multiple /48's.
      -  Mobile networks, such as vehicles or mobile phones with an
         additional network interface (such as bluetooth or 802.11b)
         should receive a static /64 prefix to allow the connection of
         multiple devices through one subnet.
      -  A single PC, with no additional need to subnet, dialing-up from
         a hotel room may receive its /128 IPv6 address for a PPP style
         connection as part of a /64 prefix.
[END QUOTE]

The RFC contains some quite interesting discussions which defenitely is 
worth reading when consitering IPv6 addressing.

But sure, there will probably initially be some ISPs who assigns /128
prefixes to their users for marketing reasons so they can charge more for
a connection where you can connect more than one equipment. If you happens
to get such ISP or other similar situation then I would recommend the use
of SOCKS to share access to the public IP (including incoming sessions)
among your stations without violating the end-to-end property of IP.

Regards
Henrik
