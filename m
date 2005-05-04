From: Amin Azez <azez@ufomechanic.net>
Subject: [RFC] alternative to conntrack ID
Date: Wed, 04 May 2005 10:18:30 +0100
Message-ID: <42789366.20702@ufomechanic.net>
References: <424747E3.7000300@eurodev.net>
	<42502F8D.5030504@trash.net>	<4254258E.5000204@eurodev.net>
	<42627BC4.8070103@trash.net>	<Pine.LNX.4.58.0504290904450.8609@blackhole.kfki.hu>
	<20050429080242.GJ9735@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050429080242.GJ9735@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> On Fri, Apr 29, 2005 at 09:14:16AM +0200, Jozsef Kadlecsik wrote:
> 
>>I don't like id either. Conntrack can uniquely identified by
>>
>>- src/dst tuples, globally, even in a cluster
>>- the pointer of the conntrack entry, locally
> 
> Yes, but not over time, i.e. if your cycle of reading the table and
> issuing a 'delete' is long enough, then you could remove a connection
> that was using the same tuple but was established meanwhile (after the
> old died).  However looking at current timeouts, that would be more than
> one or two minutes delat between read and delete.
> 
> My point of view is that we don't need the ID.  If there is too much
> delay, well then the user has a certain risk.   If we would call it
> 'deleting a flow' then we'd be safe, since a flow has no start and
> beginning, and multiple successive connections can comprise one flow ;)

I hope I am bringing a new angle to this and not the same old stuff.

With Pablo's new conntrack(-tool) there is an increased risk of this 
race condition. No longer will a userspace application read the table 
and "issue a delete" but it receives events via the netlink socket.

Any userspace tool tracking connections based on contrack events will 
receive an event some time after a conntrack is destroyed, but possibly 
after taking action on a new conntrack with the same tuples.

Here is an ascii art timeline with one of the failure cases

time+----+----+----+----+----+----+----+----+----+----+
                   destRoyed     created again????
contrack              *==*????????????????????????????????
netlink create event   *
user prog create event    *
netlink destroy event      *
user prog create action      * action may happen on new conntrack
user prog destroy event        *
user prog destroy action        * now we know we may have raced and lost

It is entirely possible that a new conntrack with the same tuples is 
created before the user program can be aware the old one has been destroyed.

Defining multiple successive connections as "one flow" is convenient, 
but as user space clients are notified of "interuptions and 
restorations" to this "one flow", it would be also convenient if they 
could safely take advantage of such notifications.

If an ID is not desirable as part of the tuple (and I can see that it is 
not) perhaps a "created time-stamp" per conntrack would suffice as an 
extra "guard" which MAY be provided to conntrack manipulation routines, 
and if so provided MUST also be satisified for the operation to take place.

That is my suggestion. It does not introduce an alternative ID, it does 
avoid the problem of race conditions.

Comments?

Amin
