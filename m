From: James Morris <jmorris@intercode.com.au>
Subject: Re: [libipq] Accessing packet payload
Date: Thu, 4 Jul 2002 01:32:30 +1000 (EST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Mutt.LNX.4.44.0207040106140.11542-100000@blackbird.intercode.com.au>
References: <1231.131.227.136.38.1025691493.squirrel@ike.ee.surrey.ac.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Wei Koong CHAI <eem1wc@eim.surrey.ac.uk>
In-Reply-To: <1231.131.227.136.38.1025691493.squirrel@ike.ee.surrey.ac.uk>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 3 Jul 2002, Wei Koong CHAI wrote:

> My questions:
> 
> [1] In the struct ipq_packet_msg, the data_len field is referring to what? 
> Is it referring to the length of the whole IP packet (header + payload) or 
> just the header or the payload alone?

The whole IP packet, which is the packet message payload.

> And, is the payload[0] referring to 
> the first byte of the IP packet?

Yes.  Please refer to ipq_get_packet(3).

> 
> [2] I have already managed to randomly decide a bit to corrupt within a 
> packet (which is just inverting the bit) but i'm unsure on how to actually 
> access the packet (header + payload) and invert the bit.

An example of packet modification is at:
http://cvs.netfilter.org/cgi-bin/cvsweb/netfilter/OLD/tools/ipq_client.c

It won't compile anymore, but is trivial to fix.

> 
> [3] I have read somewhere that the kernel would silently / automatically 
> drop the packet if i change the packet without updating the checksum. What 
> i need to know is that, which kernel will drop the packet? My bridge or the 
> receiving workstation? I don't want my libipq program to drop it as i need 
> it to be as transparent as possible.

Generally, the receiving workstation.  I'm sure I've seen the sending 
kernel drop invalid packets, but can't see (with a brief look) where this 
would happen in the current kernel.


- James
-- 
James Morris
<jmorris@intercode.com.au>
