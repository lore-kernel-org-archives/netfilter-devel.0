From: Patrick McHardy <kaber@trash.net>
Subject: Re: Troubeleshooting  a  PPTP conversation
Date: Mon, 04 Sep 2006 18:12:05 +0200
Message-ID: <44FC5055.10802@trash.net>
References: <925A849792280C4E80C5461017A4B8A206FA78@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Mike McRae <Mike_McRae@schneidermans.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Greg Scott <GregScott@InfraSupportEtc.com>
In-Reply-To: <925A849792280C4E80C5461017A4B8A206FA78@mail733.InfraSupportEtc.com>
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

Greg Scott wrote:
>>I didn't notice any error .. are there still gre connection tracking
> 
> entries when this error occurs?
> 
> Yes.  Searching for "1723" in the output I posted from
> /proc/net/ip_conntrack, I see three entries.  The first two are from my
> end user.  The third ons is from somewhere else - not sure where.
> Curiously, all the IP Addresses on that third entry are internal.  I
> wonder why anyone would do a PPTP connection when they are already part
> of the network?  Here they are:
>
> [...]
> 
> It looks like everything in here shows TCP traffic.  I don't see
> anything that mentions GRE specifically or protocol 47.  But that may be
> normal.  

Depending on the state of the connection, yes. I'm currently cleaning
the helper up and noticed a few bugs. Not sure how they could lead
to something like this but I'll prepare a patch for 2.6.17 when I'm
done if you want to test it.
