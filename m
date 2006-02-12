From: =?ISO-8859-1?Q?T=F6r=F6k_Edvin?= <edwintorok@gmail.com>
Subject: ip_queue, nfnetlink_queue: inode of socket receiving/sending packet
Date: Sun, 12 Feb 2006 20:18:16 +0200
Message-ID: <4354d3270602121018i3375e40dg3043aca13d183e31@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: fireflier-users@lists.sourceforge.net, Martin Maurer <martinmaurer@gmx.at>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,


I need to know the inode of a socket that has sent / is going to
receive the packet that has been passed to userspace via
ip_queue/nfnetlink_queue.


I noticed that  packet_id of ipq_packet_msg_t is filled with a pointer
(converted to unsigned long) to ipq_queue_entry, that has a field
(skb) of type struct sk_buff*, that has a field sk of type struct
sock* and I could use sock_i_ino on it to find out the inode.
So I could obtain the inode like this:

ino_t get_inode(ipq_packet_msg_t* packet)
{
   struct ipq_queue_entry* entry =3D (struct ipq_queue_entry*)packet->packe=
t_id;
   return sock_i_ino(entry->skb->sk);
}

The problem is:
- sock_i_ino is defined in the kernel
- the above would work only for net/ipv4/netfilter/ip_queue.c, in the
new net/netfilter/nfnetlink_queue.c  the packet id is no longer a
pointer.

So basically I would need another field added to struct
ipq_packet_msg_t and struct nfqnl_msg_packet_hdr that is passed to
userspace. This field should be the inode of the socket that sent the
packet/ or is going to receive the packet.

Is it acceptable to add that field?

Without adding that field is there a way for me to find out the inode
from the kernel (without parsing /proc/net/tcp,/proc/net/udp to find
the inode)?

If it is not possible to modify ipq_packet_msg_t/
nfqnl_msg_packet_hdr, could you ensure that packet_id is a userspace
accessible pointer to ipq_queue_entry, and put the inode in
ipq_queue_entry?

If you add the "inode feature", please give me a short example code on
how to access it from userspace.


P.S.: Excuse me if the structure names/field names above are not
correct, this is the first time I looked at netfilters' kernel code,
and I am not a kernel hacker.

FYI: I intend to use this for fireflier (fireflier.sourceforge.net).
Fireflier currently parses /proc/net/tcp|tcp6|udp|udp6 to find out the
inode of a packet. This is inefficient.

Thanks in advance,
Edwin
