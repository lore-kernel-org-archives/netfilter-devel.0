From: Emmanuel Fleury <fleury@cs.auc.dk>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Sun, 09 Jun 2002 09:03:27 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3D02FDBF.6070005@cs.auc.dk>
References: <3D007D73.9030609@cs.auc.dk> <3D016699.9010301@cs.auc.dk> <20020608102140.C23410@oknodo.bof.de> <200206081402.17562@henrik.marasystems.com>
Reply-To: netfilter-devel@lists.samba.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Excellent.

Thanks a lot for pointing ip_conntrack_core.c and explain all this !


Henrik Nordstrom wrote:
> 

....

> The above states are "ctinfo" and is derived from the conntrack state 
> flags and the packet currently being processed. The actual conntrack 
> state flags are:
> 
> ASSURED
> The protocol (TCP/UDP/IMCP...) has seen the initiation and 
> establishment of this connection. For TCP this requires seeing the 
> whole SYN -> SYN+ACK -> ACK transition, for UDP and ICMP it simply is 
> seeing traffic in both directions..
> 
> SEEN_REPLY
> There has been traffic seen in both directions on this connection. 
> This is what makes conntrack packet state ESTABLISHED.
> 
> EXPECTED
> This connection is identified as belonging to another connection. This 
> is what makes conntrack packet state RELATED.
> 
> If neither of SEEN_REPLY or EXPECTED is true for the connection then 
> the packet state is NEW.

Ok.

I think I can see now why you didn't went to much in depth in the
packet-filtering HOWTO. The stateful module could require a full HOWTO
for itself if you want to fully understand it... :-/

The problem is that the definition of the HOWTO states that NEW match:

     A packet which creates a new connection.

That's not true if you consider this from the protocol point of view
(and the confusion is happening very often). I could suggest something
like:

     A packet which creates a new entry in the connection table
     (Warning: NEW is matching all the packets which are creating a
      connection in the considered protocol plus some others. For
      example, considering the TCP protocol, an ACK packet which is not
      part of an existing connection will also match the state NEW).

If you are agree on this modification, I'll do the patch against the
CVS archive.

(By the way, I can add also my proposition in the FAQ if everybody is
  agree).


All suggestions or modifications are welcome.

> Of these, only ASSURED is directly dependent on the TCP connection 
> tracking state, the others are only dependent on the ability of 
> identifying which connection the packet may belong to.

Actually, ASSURED seems to be related to all the protocols which
expect a confirmation from the receiver before establishing the
connection (but in your case only TCP need a confirmation. UDP and
ICMP does not need this). Right ?

Regards
-- 
Emmanuel

Go not to Usenet for counsel, for it will say both
no, and yes, and no, and yes, and no, ....
   -- Unknown
