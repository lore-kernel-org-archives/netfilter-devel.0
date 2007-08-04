From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Removal of ROUTE target - what now?
Date: Sat, 4 Aug 2007 16:22:20 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708041618010.20937@fbirervta.pbzchgretzou.qr>
References: <BAY137-F26BDAB7CC7FE589BFB7F4DA3EB0@phx.gbl>
	<46B3D859.8090906@davidcoulson.net>
	<Pine.LNX.4.64.0708041040030.11760@fbirervta.pbzchgretzou.qr>
	<46B48365.6060502@davidcoulson.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, John Lumby <johnlumby@hotmail.com>
To: David Coulson <david@davidcoulson.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46B48365.6060502@davidcoulson.net>
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


On Aug 4 2007 09:47, David Coulson wrote:
>
> It has been a while since I was running a configuration like that, however I
> believe that the kernel does not walk every routing table on the system in
> order to establish RPF state.
>
> Might be wrong though - Been a few years.

According to net/ipv4/fib_frontend.c:fib_validate_source(), it builds a flow
where src/dst and iif/oif are swapped and then does a fib_lookup(), and if
the devices match, everything is wonderful.

However, now that I look at it - the flow's TOS is set, but not its fwmark.
Well, routing code is filled with macros and not instantly 'graspable'.
Maybe one of the maintainers know better.


	Jan
-- 
