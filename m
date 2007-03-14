From: Patrick McHardy <kaber@trash.net>
Subject: Re: dangerous? Setting mark in nat table
Date: Wed, 14 Mar 2007 12:02:47 +0100
Message-ID: <45F7D657.8070907@trash.net>
References: <et6fp4$l04$1@sea.gmane.org>	<Pine.LNX.4.61.0703131632190.18488@yvahk01.tjqt.qr>	<45F6CD7C.40708@ufomechanic.net>	<Pine.LNX.4.61.0703131717440.18488@yvahk01.tjqt.qr>
	<1173868532.26913.39.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Jan Engelhardt <jengelh@linux01.gwdg.de>, Amin Azez <azez@ufomechanic.net>
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1173868532.26913.39.camel@henriknordstrom.net>
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

Henrik Nordstrom wrote:
> It's due to the relation of the per-packet nfmark being as a channel to
> return routing information from netfilter to the kernel.

Thats true, routing by nfmark in the OUTPUT chain needs the rerouting
done by the mangle table, but nowadays there are other uses for nfmark,
so if someone feels motivated to send a patch to get rid of this pretty
arbitary restriction I think I would take it.
