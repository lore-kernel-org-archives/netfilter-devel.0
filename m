From: David Poole <davep@portsmith.com>
Subject: Re: Raw Sockets and Netfiter
Date: 25 Mar 2003 07:30:58 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1048602658.14036.4.camel@athlon>
References: <001701c2f29d$20afe1e0$6b01a8c0@COURVOISIER>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <001701c2f29d$20afe1e0$6b01a8c0@COURVOISIER>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2003-03-25 at 00:06, Ethan Dameron wrote:
> If I have a an IP datagram in userspace and I send it via a raw socket
> created with socket(PF_INET, SOCK_RAW, IPPROTO_RAW) using the send()
> system call, will this packet traverse the netfilter chains?  If it
> does not traverse the firewall, how can I make it do so?
> Version: 6.0.463 / Virus Database: 262 - Release Date: 03/17/2003

What are you trying to do?  Not that I have a solution, but I'm running
into the same problem.  

The DHCP client uses PF_PACKET which bypasses the firewall. 
Consequently, I can't firewall off certain machines.  I've been fiddling
with -j QUEUE and running a user-space DHCP client but the reinjected
packets are going I know not where.

Also, with PF_PACKET, the DHCP client will receive all unicast and
broadcast packets.  On a busy network and a slow system (our embedded
Linux product), the client gets flooded.


-- 
David Poole <davep@portsmith.com>
Portsmith   http://www.portsmith.com
960 Broadway Avenue, Suite 300
Boise, ID  83706
208-395-1300 x241
