From: "Javier Martin" <martin@trymedia.com>
Subject: RE: Wrong count on bytes
Date: Mon, 21 Oct 2002 12:34:25 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <002101c27938$dded96a0$8432a8c0@mcpollo>
References: <20021019063938.GA19783@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'Patrick Schaaf'" <bof@bof.de>
In-Reply-To: <20021019063938.GA19783@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> >   Chain OUTPUT (policy ACCEPT 410429507 packets, 581914465274 bytes)
> >   Chain OUTPUT (policy ACCEPT 410555345 packets, 582099636248 bytes)
> > 
> > I'm using the following rules:
> > 
> >   iptables -I INPUT -i eth0 --destination x.x.x.x
> >   iptables -I OUTPUT -o eth0 --source x.x.x.x
> 
> Maybe you are using these rules, but you certainly are not 
> showing their counters in the two lines above. You are 
> showing the chain defaults of the OUTPUT chain, counting 
> anything _not_ covered by terminating earlier rules.

Hmmm.. If I display the bytes conters per IP, they show similar numbers
(ie. Exceeding 100 mbit/sec).

> I'd guess that your chain defaults cover localhost 
> communication and other stuff besides that which you thing 
> you want to measure.

I think localhost has nothing to do with this. There is no traffic
through the lo interface at all.

On the other hand, if the server is not peaking at the ethernet maximum
100 Mbit/sec, the numbers more or less match. For example, if I get 60
Mbit/sec from the driver, I will also get 60 Mb/sec from iptables. BUT
things change when the server saturates. So my guess is the following:

The server is trying to throw more than 100 Mbit/sec. Iptables accounts
each packet that passes through the OUTPUT chain, but as the network
card has reached is limit, it starts dropping frames. Those frames are
not actually transmited, but in fact they account from the iptables
point of view.

So what iptables measures when the server saturates is the minimum
amount of bytes that 'could have been' transmitted if the interface was
faster.

I don't know if this theory is correct, but at least satisfies me :-)

Javier
