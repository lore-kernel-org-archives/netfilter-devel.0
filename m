From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [RFC] ct_sync 0.15 (corrected)
Date: Fri, 13 Aug 2004 16:26:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1092407190.2402.120.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	jamal <hadi@cyberus.ca>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-failover list <netfilter-failover@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

  [warning: this mail got quite long]

  I think finally I managed to get ct_sync in a state where some more
public review/testing would certainly do good for the project. This week
I've been successfully running overnight stress tests on our two-node
cluster, and both of the nodes survived all of the tests without locking
up, panicking, etc. OK, I know this is not too much, but is certainly
better than anything we had up to now, and somehow I felt this would be
the bare minimum I should reach before asking anyone to try out ct_sync.
Of course, there is still a lot to do. Just to mention two things which
certainly need a lot of work: protocol implementation is really the bare
minimum which is capable of doing anything, and expectation support is
missing completely. The current implementation supports replicating
conntrack entries, and supports NAT. So basically all the simple things
(not using expectations) should work reasonably well. This is why I've
bumped the version number to 0.15, it is available in the Netfilter CVS.

  The aim of this e-mail is twofold:

      * First, I just thought that ct_sync is now ready for some
        testing. Unfortunately our development and testing environment
        is very limited, so anyone being able to help us out and do some
        testing would be of a big help.

      * After doing some work to stabilize the current code, there is
        now need to discuss a few things before going on with
        implementation. So, I'd be happy if there was some discussion on
        these things before starting to implement anything.

  I'll try to summarize the most important open problems I've come
through. This list does not contain things I consider trivial, for
example exporting important internal constants as tunable parameters
through sysctl.

     1. There should some facility by which one can select which
        connections have to be replicated. This way it would be possible
        to limit replication traffic to the bare minimum. For example,
        there is no point in replicating conntrack entries for
        connections whose endpoint is one of the nodes (administrative
        SSH traffic, for example). A per-conntrack flag would be needed,
        just like CONNMARK, which could be set for conntracks needing
        replication with a simple iptables rule. Actually, CONNMARK is
        enough, if we choose a given bit of the mark as the SYNC bit.
        Besides this, we should decide if we needed a SYNC or a NOSYNC
        bit, that is, if the default mode of operation should be "sync
        or not to sync".

     2. The error recovery functions in the protocol layer should be
        revamped. The protocol is a plain sequence numbered, NACK-based
        one using multicast UDP. Lost packets are detected by the
        receiver when receiving the next packet with the inappropriate
        sequence number (not 'seq of the last packet + 1') is received.
        When this occurs, the node sends a recovery request containing
        the last successfully received sequence number. When the current
        master receives such a request, it should re-send all matching
        packets from the backlog of its send ring. However, to iterate
        over the entries of the ring, it should hold the spinlock of the
        ring, which is not possible, since the send() operation may
        sleep... (This is done from the receiver thread, and the ring is
        accessed from the sender thread and from softirq context as well.)
        What would be the most elegant solution?

        On the other hand, it may be possible that the master is not
        able to re-send the packet, for example this may be the case if
        it is "too old", and is not present in the backlog anymore. In
        this case, the slave should be notified that recovery is not
        possible this way, and it needs to do a full re-sync. This is
        why I thought that we should include some extra information in
        every packet: the minimal sequence number of the oldest packet
        in the master's backlog. Using this approach upon receiving a
        packet with a 'wrong' sequence number the slave can immediately
        decide if there is still hope of recovering the missing packets
        or not. If not, it requests full-resynchronization instead. I
        think this feature could handle the problem of a broken link
        between the nodes causing a lots of lost packets. Am I missing
        something?

        The protocol layer is really very dumb in other respects as well.
        For example it simply drops all packets considered too fresh
        instead of queuing them. (Although I would like to add that
        typically there should be no errors on the replication network
        at all, except because of administrative reasons.) However, I
        really don't think we should develop a full-blown protocol,
        there is simply no point in creating one more reliable protocol...
        So, do anyone know of anything which could be used by ct_sync?
        (It has to be a semi-reliable, connectionless multicast protocol
        with a _very_ low overhead.)

     3. There are a few things in the connection tracking code which
        are incompatible with replication "by design". For example,
        the expectfn() function in the expectation structure is such:
        simply, there is no way to replicate a stand-alone function
        pointer which could point to any arbitrary function. One more
        example could be TCP window tracking, I don't think we have
        the necessary bandwidth and CPU time to send an update message
        after each and every received TCP packet... Any idea how we
        could solve these problems?

     4. The current version is 2.4-only, it is for the good old
        ip_conntrack, and supports IPv4 only. I don't really think
        this is the way to go, but there is commercial interest in
        having this kind of failover functionality as fast as possible.
        However, I think that after reaching some state which is
        acceptable for the users needing the basic features fast, this
        whole thing should be re-designed and ported to 2.6 and
        nf_conntrack. This would depend on a few other things, such as
        porting ctnetlink for nf_conntrack, but I thing those would
        be important to have as well. Again, this would be quite a
        lot work to do, thus deferring the 'stable' (production ready)
        release of the code.


  Wow, this got quite long, thanks for reading all this. :)
And happy testing and reporting back! :)

-- 
 Regards,
   Krisztian KOVACS
