From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: policy routing on locally generated packets
Date: Tue, 26 Aug 2003 21:45:09 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0308262141080.16076-100000@filer.marasystems.com>
References: <3F4B5CDA.8090801@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick Schaaf <bof@bof.de>,
   "lartc@manchotnetworks.net" <lartc@manchotnetworks.net>,
   netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3F4B5CDA.8090801@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 26 Aug 2003, Patrick McHardy wrote:

> No locally generated packets don't pass the PRE_ROUTING hook. There
> is no way to mangle these packets before routing.

Indeed, but mangle OUTPUT reroutes the packets where needed 
(change in source/destination/mark/tos)

Regards
Henrik
