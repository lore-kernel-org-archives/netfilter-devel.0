From: "Song Wang" <wsong@ece.uci.edu>
Subject: netfilter connection tracking TIMEOUT issue
Date: Thu, 13 Nov 2003 17:20:46 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <MEEKIEPDOBGHADOEHGGOMEKHCCAA.wsong@ece.uci.edu>
Reply-To: <wsong@ece.uci.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

I have run into the timeout issue related to the connection
tracking entry several times. The fact that those connection tracking
entries
just stay in the connection tracking table and take effect due to
the default  timeout values (for example, TCP_CONNTRACK_ESTABLISHED
is 5 DAYS) could compromise the security or put network connection
into the wrong state.

For instance, I can implement "Virtual Servers" using DNAT such as

iptables -t nat -A PREROUTING -i ppp0 -p tcp --dport 22 -j DNAT --to
192.168.1.5

to create a virtual ssh server behind my Linux gateway.

However, when a ssh connection is established from the remove to the ssh
server,
the TCP connection tracking entry will be created in ESTABLISHED status with
timeout set to 5 DAYS. So even I realized I made a mistake to allow this
kind
of SSH virtual server and deleted the iptables rule, due to the 5 DAYS
timeout, the remote can still connect to the ssh server within 5 DAYS unless
I
rebooted the gateway or reloaded ip_conntrack module!!!

I don't know how netfilter designers come up with these TIMEOUT values. I
searched
the mailing list before and there were arguments about it.

I don't want to argue about these values. But I think we should come up with
a method that when we delete an iptables rule, at least we can easily elect
to
delete related connection tracking entries in the connection tracking table.

Do we have an easy way to delete specified entries in the connection
tracking table
without writing a kernel module? The only way I know to access connection
tracking table
from the user space is "cat /proc/net/ip_conntrack".

Thanks in advance.

-Song
