From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [netfilter-core] strange iptables statistics =(
Date: Wed, 16 Jun 2004 00:19:53 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406160012010.15456-100000@filer.marasystems.com>
References: <40CF5CE5.8080601@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Renat Araslanow <tr0nd@bitel.ru>
In-Reply-To: <40CF5CE5.8080601@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Renat Araslanow wrote:

> as u can see in "ufanets_out" chain there is 328 packets, but in chain
> "by_protocol_out" we see only 1 udp packet. i have one more ip range - and
> its reported ok. can u explain me this please? thanks in advance.

the ufanets_out chain counts all kinds of packets, not only UDP..

by_protocol_out does not count all kinds of packets, only a small set of 
selected packets.

there is a large number of situations where these two will not add up as 
there is very many kinds of packets which will not be counted by your 
by_protocol_out chain.

Regards
Henrik
