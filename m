From: Jonathan G - Mailing Lists <email-lists@surestorm.com>
Subject: Re: [nf-failover] [RFC] ct_sync 0.15
Date: Fri, 13 Aug 2004 16:01:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <411CC99C.7020205@surestorm.com>
References: <1092404121.2402.67.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
 netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <1092404121.2402.67.camel@nienna.balabit>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi Krisztian,

    my partner and me are preparing for the next week a firewall/High 
Availability/Load Balancer cluster made of the following software:

- Security: IPTables 1.2.8
- HA: KeepAlived (only the VRRPv2 part)
- LB: Pen (siag.nu/pen) for tcp connections


We would be so pleased and interested in test you package and discuss a 
real wold implementation (the installation of this cluster (2 nodes) is 
for an ISP).

Drop me an email to tell how start and we will help all of us get more 
real results with our system.

;-)

BR,

jonathan


KOVACS Krisztian wrote:

>   Hi,
> 
>   I think finally I managed to get ct_sync in a state where some more
> public review/testing would certainly do good for the project. This week
> I've been successfully running overnight stress tests on our two-node
> cluster, and both of the nodes survived all of the tests without locking
> up, panicking, etc. OK, I know this is not too much, but somehow I felt
> this would be a bare minimum we should reach before asking anyone to try
> out ct_sync. Of course, there is still a lot to do. Just to mention two
> things which certainly need a lot of work: protocol implementation is
> really the bare minimum which is capable of doing anything, and
> expectation support is missing completely. The current implementation
> supports replicating conntrack entries, and supports NAT. So basically
> all the simple things (not using expectations) should work reasonably
> well. This is why I've bumped the version number to 0.15.
> 
>   The aim of this e-mail is twofold:
> 
>       * First, I just thought that ct_sync is now ready for some
>         testing. Unfortunately our development and testing environment
>         is very limited, so anyone being able to help us out and do some
>         testing would be of a big help.
>       * After doing some work to stabilize the current code, there is
>         now need to discuss a few things before going on with
>         implementation. So, I'd be happy if there was some discussion on
>         these things before starting to implement anything.
> 
>   I'll try to summarize the most important open problems I've come
> through. This list does not contain things I consider trivial, for
> example exporting important internal constants as tunable parameters
> through sysctl.
> 
>      1. There should some facility by which one can select which
>         connections have to be replicated. This way it would be possible
>         to limit replication traffic to the bare minimum. For example,
>         there is no point in replicating conntrack entries for
>         connections whose endpoint is one of the nodes (administrative
>         SSH traffic, for example). A per-conntrack flag would be needed,
>         just like CONNMARK, which could be set for conntracks needing
>         replication with a simple iptables rule. Actually, CONNMARK is
>         enough, if we choose a given bit of the mark as the SYNC bit.
>         Besides this, we should decide if we needed a SYNC or a NOSYNC
>         bit, that is, if the default mode of operation should be "sync
>         or not to sync".
>      2. The error recovery functions in the protocol layer should be
>         revamped. The protocol is a plain sequence numbered, NACK-based
>         one using multicast UDP. Lost packets are detected by the
>         receiver when receiving the next packet with the inappropriate
>         sequence number (not 'seq of the last packet + 1') is received.
>         When this occurs, the node sends a recovery request containing
>         the last successfully received sequence number. When the 
> 

-- 
   :::: Jonathan Gonzalez Fernandez ::::

    (o>  mail  : jonathan@surestorm.com
    //\  jabber: surestorm@jabber.org
    V_/  site  : www.surestorm.com

   ::: Registered Linux User #333386 :::
