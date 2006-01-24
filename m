From: Eric Leblond <eric@inl.fr>
Subject: Re: [feature request] Fixed timeout for conntrack entry
Date: Tue, 24 Jan 2006 22:04:49 +0100
Message-ID: <43D69671.9030908@inl.fr>
References: <1138008265.11978.29.camel@localhost.localdomain>
	<43D57525.7080907@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: nufw-core-team@nufw.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
In-Reply-To: <43D57525.7080907@eurodev.net>
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

Pablo Neira Ayuso wrote:
> Hi Eric,
> 
> Eric Leblond wrote:
> 
>>When working on NuFW (http://www.nufw.org), we had to use libconntrack
>>to kill some entry at a given time. In fact, we use it to be able to
> 
> That's very unlikely to happen. If a new connection is opened with the
> same IP information, the ID will be different than the old connection.
> So such problem is unlikely to happen. Unless the daemon is so slow that
> a wraparound happened to the global ID, eg. 2^32 connections were opened
> at the time that the daemon was restarting. That would be really slow :)

Yes ;-) but that's mean you need to know the conntrack ID. Thus
userspace programs needs to fetch the ID.
Let's assume this, in the scope of NuFW, this will cost some more
kernel<->userspace exchanges but it could be done because at we only
interfere with kernel when we accept the packet with nfnetlink_queue.

But I don't think this is the main point.

>>From a developpement point of view it seems that this is a "small"
>>modification of code. It could be done by adding a test when refreshing
>>standard connection entry timeout (when receiving a packet) and testing
>>if the connection must be destroy and destroy it if needed ?
> 
> 
> I think that we could add support for permanent conntracks, eg.
> conntracks that never expire. So the userspace program could have their
> own timers and kill it whenever it wants to. The problem is that the
> userspace program must behave correctly, otherwise we could get tons of
> zombie conntracks that never expire.

Personnally, I don't think that trust userspace for something like that
is not a good idea. A userspace daemon could be stopped, and this will
be the night of the living dead.

Furthermore, this does not introduce the capability to do this from
kernel space which could be really interesting. From an iptables point
of view we could have something like :
iptables -A FORWARD -m state --state NEW -m time --time 08h-18h \\
	-m expiration -j ACCEPT --expire-at 18h
I mean, accept connection creation between 08h and 18h and destroy
connection from conntrack at 18h. This is a policy that we have been
asked quiet frequently.

Is there some theoritical limit in current Netfilter code to implement
such a thing ?

BR,
--
Eric Leblond
