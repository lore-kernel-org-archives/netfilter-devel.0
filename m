From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: default value of nf_conntrack_tcp_timeout_close_wait
Date: Thu, 5 Apr 2007 09:11:50 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0704050835030.22531@blackhole.kfki.hu>
References: <20070404122314.GP657@kriss.csbnet.se>
	<1175691579.4008.52.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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

Hi,

On Wed, 4 Apr 2007, Henrik Nordstrom wrote:

> ons 2007-04-04 klockan 14:23 +0200 skrev Joakim Axelsson:
>
>> I've notices that the default value of
>> /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_close_wait (atleast in
>> kernel 2.6.20.4) is only set to 60 seconds. CLOSE_WAIT is the state where
>> one side has sent a FIN but not the other. Meaning we can still send data in
>> one direction. This is a state which can live a long time. Much longer than
>> just 60 seconds.
>
> I remember this.. was small due to being afraid that connections where
> one of the endpoints have gone away may otherwise accumulate.

Yes, this is a potential source to fill up the conntrack table by stale 
connections (or which looks like that).

> The best solution I can think of is to not look for FIN to detect such
> connections but assymetric traffic where sent data (SYN, data or FIN) is
> sent in one direction but no ACKs flowing in the other direction within
> a reasonable timeframe (several minutes). Not perfect, but it's hard to
> get perfect on this one..

As the timeout parameter controls how much time may pass without detecting 
any valid traffic in either directions, I'd say that raising the limit 
from 60s to 3d were too much - but that's a feeling only, not backed by 
real data.

> Another idea to close the gaps further would be to drop the "assured"
> bit on the connection when a FIN gets ACKed.

That could really help if we'd have a better (i.e. not much slower) 
algorithm to find potential connections to evict when the table is full. 
Currently we haven't got much chance to find a non-assured connection as 
it must be in the same hash chain as in which we want to insert a new 
connection.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
