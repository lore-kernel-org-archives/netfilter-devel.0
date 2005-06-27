From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH] update raw patch in POM
Date: Mon, 27 Jun 2005 10:50:32 +0200
Message-ID: <42BFBDD8.6040704@tac.ch>
References: <42A6AB19.2040106@tac.ch>	<42A6E685.3060408@eurodev.net>	<42AEF774.8060300@tac.ch>	<42B67BEC.1090105@tac.ch>	<20050621003441.GI8335@postel.suug.ch>	<42B76474.8080209@eurodev.net>	<20050621111328.GK8335@postel.suug.ch>	<42B81D75.8090205@trash.net>	<20050621215027.GP8335@postel.suug.ch>	<42B8B181.4020607@trash.net>	<20050622005243.GQ8335@postel.suug.ch>	<42B8DA09.9080406@eurodev.net>	<42B8E141.1080902@trash.net>
	<42B94DFE.2070205@tac.ch> <42B9B00F.90601@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42B9B00F.90601@trash.net>
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

Hi Patrick,

> This actually looks good, no leak, no crash. Not sure where the 30
> second delay comes from, my guess is that packets are queued while
> the neighbour is resolved, although its pretty long. To confirm that
> theory you could play with the values in
> /proc/sys/net/ipv4/neigh/default and see if it changes anything.

I've got a new trace with more sessions, however it looks the same. The delay is
not acceptable and I'd like to find out what the problem is. I've added the
output of readprofile and slabtop on top of the other statistics. Let me know if
you need more granularity. I'll go play with the neighbour settings now. You can
fetch the data from (I don't want to clutter the list with this anymore):

    http://www.drugphish.ch/~ratz/netfilter/

Best regards,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
