From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [nf-failover] NAT support for peer-to-peer games
Date: Sat, 25 Sep 2004 13:08:51 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409251219380.20126@filer.marasystems.com>
References: <00d901c49fb3$2dea51f0$e310f43e@manowar>
	<20040925075421.GR3236@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: "Serguei I. Ivantsov" <manowar@gsc-game.kiev.ua>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, baford@mit.edu, dank@kegel.com
In-Reply-To: <20040925075421.GR3236@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, 25 Sep 2004, Harald Welte wrote:

>> How to implement the scheme described below using netfilter?
>
> netfilter implements draft-ford-natp2p-00, which should address your
> problem.
>
>> http://www.hasenstein.com/HyperNews/get/linux-ip-nat/97.html
>
> yes, this is the draft that iptable_nat aims to implement.

On reading this I see some obvious limitations of this approach. The main 
limitation is the port NAT capability of Netfilter.. you are not 
guaranteed you will get assigned the same port on all connections.

And if the change to randomize the netfilter port assignments is done then 
this scheme will break down completely and never succeed in making the 
p2p connections.

A more up to date devision of this draft seems to be 
draft-ford-midcom-p2p-03.txt

To sort this out it should be added to this draft that each client 
punching holes in NAT gateways MUST use a random source port and if 
connection fails retry using a new random port, and that the document is 
extended to mention that the common server is not only used as a directory 
but also active participant in mediating the connections to allow the 
endpoints to syncronize their state correctly when there is need to retry 
on a new port etc. In addition the P2P applications must be prepared to 
see "unexpected" traffic from uninvited clients and should therefore not 
only rely on the port numbers for identifying the client but also include 
their own unique identifiacation of the P2P participiant they want to 
connect to to allow proper detection of crossed connections.

Regards
Henrik
