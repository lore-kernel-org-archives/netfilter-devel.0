From: Markus Mikkolainen <itm@itmo.dyndns.org>
Subject: Re: netfilter-devel digest, Vol 1 #689 - 4 msgs
Date: Fri, 10 Oct 2003 00:03:37 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031010000337.44c23ae2.itm@itmo.dyndns.org>
References: <20031008042841.17580.88884.Mailman@netfilter-sponsored-by.noris.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20031008042841.17580.88884.Mailman@netfilter-sponsored-by.noris.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

As a small note while reading the digest:

I wrote a small filter module as an experiment , but I havent had time to update it from 1.2.5 to later versions. It is a very simple module to match seq%n==c or !=c , where seq is the tcp sequence number and n is for example the number of machines serving a single ip. If you now define rules to drop everything else to the ip to be served except ones where connection is established and ones which are SYN and have seq%<number of servers>==<my number> , you get nice loadbalancing which 
guarantees that if one server goes down, the numbers have to be reallocated but existing connections are not broken. and yes, it should scale 100% since the operations are totally independent, up to the point that the SYN flood is too much for the packet filter ;) The only problem here is that the machines have to either be behind a hub (bad , unless your traffic is very CPU intensive and not very network intensive) or a switch has to be tricked somehow to send the packets for the service IP
to all of the servers. 

Broadcasting some traffic is  not a bad option if you really need fault tolerance and you can afford a pair of switches in a spanking tree or something... 

nice things are also that since (usually) the sequence number is random enough (even for shit OS's) , the division is fairly even. Improvements
could include something like seq*p%n or a real hash function to make the
distribution even and still deterministic. 

The code is very small/simple and mostly copied from the other examples. anyone want it?
