From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: DNAT/SNAT and logging
Date: Wed, 21 Jan 2004 13:05:43 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401211303450.6443-100000@filer.marasystems.com>
References: <1074677621.14990.11.camel@ankarloo.got.volvo.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Johan Ankarloo <johan.ankarloo@volvo.com>
In-Reply-To: <1074677621.14990.11.camel@ankarloo.got.volvo.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 21 Jan 2004, Johan Ankarloo wrote:

> I'm not shure i agree. The problem here is that the logging is done
> seperate from the modules that mangle the packets.

Yes, and so is the NAT rules.

> The right way ( for me ) would be to have the mangle modules send the
> logging information to the logging module. In this way the mangle
> modules could say what has been altered in the packet.

If you log the addressing information from conntrack then this is exacly
what is done.

Regards
Henrik
