From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: ip_conntrack table full problem
Date: Mon, 21 Mar 2005 23:58:17 +0100
Message-ID: <200503212358.17729.thomas.jarosch@intra2net.com>
References: <200503141647.42299.thomas.jarosch@intra2net.com>
	<200503211923.48964.thomas.jarosch@intra2net.com>
	<20050321211441.GA15155@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20050321211441.GA15155@linuxace.com>
Content-Disposition: inline
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

> > IIRC the box makes heavy use of SNAT/DNAT for port forwarding.
> > I'll try to get a copy of the firewall rules tomorrow and
> > test it locally here.
> >
> > Is there an easy way to see if it leaked conntracks?
> > Should the information in /proc/slabinfo be somewhat proportional
> > to the number of connections/lines in /proc/net/ip_conntrack?
>
> Yes, the numbers should be in the same ballpark.  Conntracks are being
> cleaned from the lists (i.e. /proc/net/ip_conntrack), but never being
> destroyed.  In my testing this is caused by a process not freeing
> the skb.  What kinds of processes are running on this box?

There are the usual suspects like apache, mailserver etc.,
but I can't think of anything that manipulates skbs directly.
FreeS/WAN is also installed on the box, but I use the same
configuration at home with no trouble ever.

The best thing would be to find a way of reproducing the problem,
which I start tomorrow. Just checked another box with the same installation
and 32 days uptime, /proc/slabinfo looks good. IMHO the problem
is related somehow to the heavy use of SNAT/DNAT as it's the main
difference between the freezing box and mine.

Thomas
