From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: conntrack performance/DoS formula
Date: Sun, 30 Jun 2002 12:40:09 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15647.24217.324807.354846@isis.cs3-inc.com>
References: <20020628082339.I2890@oknodo.bof.de>
	<15644.41633.528107.723418@isis.cs3-inc.com>
	<20020628203624.A4136@oknodo.bof.de>
	<15644.45834.373409.220647@isis.cs3-inc.com>
	<20020628213520.C4136@oknodo.bof.de>
	<15644.53466.193145.914415@isis.cs3-inc.com>
	<20020628232819.H4136@oknodo.bof.de>
	<15644.58258.483223.56527@isis.cs3-inc.com>
	<20020629140729.N4136@oknodo.bof.de>
	<20020629143406.O4136@oknodo.bof.de>
	<20020630103131.X4136@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20020630103131.X4136@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick Schaaf writes:
 > Use the new '-P' flag (no arguments) to automatically choose a prime
 > number of hash buckets, just a bit larger than the number you selected
 > with '-s NUMBER'. When I do that, the large difference between the
 > original and crc32 hashes almost vanishes - sometimes our original
 > hash even looks _better_ (by chance)! This is a strong indication
 > that we want the "prime select" in the kernel!

Actually, I believe that this is overkill.  All we really need is for
the components that go into the data to have sizes relatively prime to
the modulus, and since all the data has sizes of form 2^n it should be
sufficient to make the modulus odd.  That's why I suggested the
modulus be "if table size odd then table size otherwise one less".
You might try that to convince yourself that it works.

 > You can now use '-c NUMBER' to set a seed for the CRC32 hash. You can now
 > use '-C' (without parameter) to set a random seed for the CRC32 hash.
 > These options are for testing the idea of "attack compensation by
 > inserting local variance". I'd like to hear opinions on this.

I'm sorry I don't know enough about CRC to know whether this will
help.  How does the -c argument affect the answer?  My first test
is to try specifying -c and not, and I'm encouraged that I get
different distributions.

At a higher level, though, I don't see much value in preventing an
attacker from filling a single bucket when he can almost as easily do
much more harm by filling the entire conntrack database!  The reason
for limiting the size of each bucket is to prevent any such attack
from killing performance by consuming time, and it does that, but it
doesn't prevent a resource consumption attack on space.

Clearly one easy defense against one easy attack (as was mentioned in 
private communication) is that whenever you want to add to a bucket
that is full, you should feel free to throw out the oldest UNREPLIED
connection in that bucket.  

If you're interested in preventing attacks that consume connection
table space devoted to "real" connections I have some ideas, but
that's another large discussion.  If lots of people out there want to
hear it I'll send to the list, otherwise perhaps it's better off the
list.

On a related subject, I'm worried that UNREPLIED might not mean
what I think it does.  Your data contains things like:
 tcp 6 387070 ESTABLISHED src=9.163.211.64 dst=165.130.71.38 sport=3228
 dport=1301 [UNREPLIED] src=165.130.71.38 dst=9.163.211.64 sport=1301
 dport=3228 use=1
How can one half of the connection be established while the other half
is unreplied?  Is this cause in one direction a syn was sent and a
syn-ack was received, and that makes it established, while in the
other direction a syn-ack was sent and nothing more was received so
it's unreplied?  That doesn't make much sense.  They should both be
established only if the entire handshake is complete, right?

You were describing unreplied connections that hang around for 5 days.
When I send some random syn's I see stuff like
 cat /proc/net/ip_conntrack
 tcp      6 113 SYN_SENT src=10.0.3.2 dst=10.0.2.3 sport=4096 ...
I'm guessing the 113 is the timeout, and that it was originally set to
120, which still seems way too long to me, but a lot better than
5 days.
