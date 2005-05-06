From: =?iso-8859-1?b?Svhybg==?= Andre Nese Berntzen <jornandr@stud.ntnu.no>
Subject: Re: libipq, open sockets stalling the app
Date: Fri,  6 May 2005 21:44:21 +0200
Message-ID: <1115408660.427bc91502625@webmail.ntnu.no>
References: <1115389749.427b7f3511965@webmail.ntnu.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
In-Reply-To: <1115389749.427b7f3511965@webmail.ntnu.no>
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

Hi!

 Just wanted to apologize for this. It was my own bug
 since I hadnt closed a socket when I used ioctl and
 SIOCGIFNETMASK to get information from the ethernet card.
 libipq works just splendid!

 I'm now using libipq to semi-tunnel tcp connections
 using a host and a 'fake' gw which then routes the packets
 independent of the 'route' gw (except for icmp and
 udp traffic which goes by the gw in the route). The whole
 thing is for the Olsr protocol since it changes gateway
 after 'topology and its whereabouts' rather than using
 static gw. This way a host can be told of (via broadcast)
 any possible gateways and choose which one to use for its
 tcp-connections, independently of the default gw. The nice
 thing with this is the load balancing effect possible
 between multiple gateways if this is wanted.

 BTW, Netfilter is a beautiful piece of software!

 J=F8rn Andre


Quoting J=F8rn Andre Nese Berntzen <jornandr@stud.ntnu.no>:

> Hi!
>
> I'm using libipq and ip_queue with the QUEUE target to
> redirect packages. Basically I intercept the packages,
> rewrite the destination IP and ACCEPT the package.
>
> My question is, during the running of the app
> 'lsof | grep root' show theres building up open sockets
> to the resource limit and then the app stops working.
> I havent been able to pinpoint the problem but it seems
> like its in libipq.
>
> Does anyone know what this is? Am I missing out on the code
> somewhere and have a loose end maybe?
>
> J=F8rn Andre
>


--
