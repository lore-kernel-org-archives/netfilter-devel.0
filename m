From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: policy routing on locally generated packets
Date: Tue, 26 Aug 2003 21:37:04 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0308262127040.16076-100000@filer.marasystems.com>
References: <1061887675.1273.37.camel@drs0.manchotnetworks.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "lartc@manchotnetworks.net" <lartc@manchotnetworks.net>
In-Reply-To: <1061887675.1273.37.camel@drs0.manchotnetworks.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On 26 Aug 2003, lartc@manchotnetworks.net wrote:

> So I am searching for a hopefully simple way to implement this without
> having to recompile a bunch of stuff.

NAT of local connections can be of help here I think.

Also, there was some discussion regarding marking and rerouting of local 
packets some year ago. It was supposed to be fixed somehow (by NAT I 
think..)

Regards
Henrik
