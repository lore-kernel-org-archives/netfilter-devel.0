From: don-netfil@isis.cs3-inc.com (Don Cohen)
Subject: Re: conntrack and ICMP errors
Date: Tue, 15 Apr 2003 19:25:23 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <16028.48915.41506.50883@isis.cs3-inc.com>
References: <20030411101702.14701.14873.Mailman@kashyyyk>
	<16028.15188.332538.355740@isis.cs3-inc.com>
	<20030415172359.GA26101@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Balazs Scheidler <bazsi@balabit.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20030415172359.GA26101@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick Schaaf writes:
 ...
 > There are basically two questions to worry about:
 > 
 > 1) for any such probing method, what could go wrong in the real world?

That question can only be answered by trying it.  Or hearing from
someone else who has already tried it, or something similar.
Which is why I want to hear from anyone who has tried it or knows
why it won't work, or failing that, try it.

The best we can do otherwise is read the specs.

 >    As I work for a dialup service provider, the extreme case that I have
 >    to consider is both sides of a tracked connection having been reassigned
 >    to different customers. Now your probe comes. What will happen? How many
 >    calls will support get about attack attemts? (not many, but also not
 >    none)

If I understand the question, you imagine that one or both sides close
the connection without any explicit agreement to do so (as in RST or
FIN packets that the firewall would see).  Now the firewall sends a
packet to the old connection.  The design of tcp is that this should,
with extremely high probability, be detected as a packet to a
nonexistent connection, which should cause a RST, which is just what
we want.

If such packets result in calls to support about attacks then so would
the legitimate packets that we simulate.  As an example of that, I
telnet (I mean, ssh) to a server, interact for a while, then go off to
eat supper.  Now my machine goes down, and in your case my IP is
reassigned, say to your machine.  Later on the server decides to tell
me that mail has arrived and sends a packet to me which is very
similar to the one I propose the firewall send.  You get it and say
"what's this?" and send a RST.  
If that happens at a high rate then you're justified in calling it an
attack.  If it happens about as frequently as connections are lost
because machines crash then this is just TCP working as intended.
I guess if you were really unlucky you'd be assigned the IP of a
machine that had recently crashed with a huge number of open
connections.  (I think that's a good reason not to reassign an IP
immediately after it becomes unused.)

 > 2) there's the question of when to probe. My crystall ball displays
 >    "halting problem", but it is occasionally flakey. Any kind of
 >    probing violates the unwritten "never send more than you receive"
 >    rule of intermediate protocol stacks, so one has to be careful.
I'm not quite sure what either of these is supposed to mean.
Halting means that this is not a real decision procedure?
That's true, but (1) it may still be useful, (2) if we can send a
packet that ought to cause a response, then the lack of response
can reasonably be interpreted as evidence.
"Never send more than you receive" seems a good rule in some ways,
but is certainly not normally followed.  For instance, a packet of
size 40 bytes can easily result in an ICMP packet that contains the
entire original packet inside it.  In this case I'm proposing to send
extra packets at a very low rate.  And this is, after all, meant as
a way to prevent or at least mitigate another problem - the connection
table filling up.

 > It may well be that all this has been researched to death, before.
 > I wouldn't know. I'm a lazy ignorant.

If it has been then whoever knows about it should please speak up!
