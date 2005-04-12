From: mani kandan <vititmani@yahoo.com>
Subject: address translation
Date: Tue, 12 Apr 2005 03:47:53 -0700 (PDT)
Message-ID: <20050412104753.30017.qmail@web51401.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

hello,

i am doing a project on  TCP connection passing.
where the socket is migrated from one server to
another.
the work was actually done by MR. Werner Almesberger.
http://tcpcp.sourceforge.net
here tcp connection details of a socket at server 1 is
dumped into file and, 
the socket created at second server is set with these
connection details.
now the packets destined to the first server has to be
redirected to second server. so i thought of using 
NAT and studied LVS and found that it is not helping 
me.
so i went for iptables.
i need to change the source and destination address of
a packet. so that the packets from the client are
re-routed to second server from  first server. at the
first server i want to change src address as first
server and dest address as second server of the packet
from client.

with iptables i was able to change the address from
the 
start of the connection. ie only for the connection as
whole. but i want to change address of the packet
sometime after the connection is established.is it
possible to do it and how to do it.
  
In documentation i found that address translation 
can only done for the first packet of the connection
and the following packets of that connection   

my question is whether it is possible to do address
translation in the intermediate state of connection.
i added the rule at the middle of the connection but
the address translation did not take place.

please can anyone help me in this


		
__________________________________ 
Do you Yahoo!? 
Read only the mail you want - Yahoo! Mail SpamGuard. 
http://promotions.yahoo.com/new_mail 
