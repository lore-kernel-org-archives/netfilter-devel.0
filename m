From: efd@duke.edu
Subject: How to Send Raw IP datagrams?
Date: Sat, 29 Mar 2003 17:08:46 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.GSO.4.53.0303291701390.9064@teer20.acpub.duke.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This should be an easy question for anyone who has used raw sockets in the
past.  I have the payload field of an ipq_packet_msg which is a byte[]
containing the raw ip datagram.  I am trying to send it over a raw socket
using JNI C code from Java.  Here is what I'm doing, but send() keeps
returning -1 as an error occurs somewhere.


send_ip_pkt(int packet_len, unsigned char * pkt_data)
{
	char on = 1;
	int fd = socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
	setsocketopt(fd, IPROTO_IP, IP_HDRINCL, &on, sizeof(on));
	int ret = send(fd, pkt_data, packet_len, 0);
}

this is the jist of what I'm doing, but I don't know what is happening
with the send() command b/c the socket() call returns a proper fd (fd >
0).  Any help or code tidbits would be greatly appreciated.

-Ethan
