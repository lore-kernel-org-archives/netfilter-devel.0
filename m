From: Patrick McHardy <kaber@trash.net>
Subject: Re: default value of nf_conntrack_tcp_timeout_close_wait
Date: Wed, 04 Apr 2007 17:42:19 +0200
Message-ID: <4613C75B.5020707@trash.net>
References: <20070404122314.GP657@kriss.csbnet.se>
	<1175691579.4008.52.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1175691579.4008.52.camel@henriknordstrom.net>
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
> ons 2007-04-04 klockan 14:23 +0200 skrev Joakim Axelsson:
> 
> 
>>I've notices that the default value of
>>/proc/sys/net/netfilter/nf_conntrack_tcp_timeout_close_wait (atleast in
>>kernel 2.6.20.4) is only set to 60 seconds. CLOSE_WAIT is the state where
>>one side has sent a FIN but not the other. Meaning we can still send data in
>>one direction. This is a state which can live a long time. Much longer than
>>just 60 seconds.
> 
> 
> I remember this.. was small due to being afraid that connections where
> one of the endpoints have gone away may otherwise accumulate.
>
> The best solution I can think of is to not look for FIN to detect such
> connections but assymetric traffic where sent data (SYN, data or FIN) is
> sent in one direction but no ACKs flowing in the other direction within
> a reasonable timeframe (several minutes). Not perfect, but it's hard to
> get perfect on this one..


The idea is not bad IMO, but I think it would require an additional
timer, which pretty much kills it since that would grow struct
ip_conntrack by quite a lot.


> Another idea to close the gaps further would be to drop the "assured"
> bit on the connection when a FIN gets ACKed.


That sounds better, but I have to think about how this affects
the TCP conntrack internal use of the ASSURED bit.
