From: "Varga Endre" <drew@mailbox.hu>
Subject: (no subject)
Date: Tue, 15 Feb 2005 22:09:47 +0100
Message-ID: <20050215210947.32682.qmail@ad.mailbox.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
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

Hello!

First of all, I am new to Linux and iptables, but I am currently
developing (or trying to develop) a match module for iptables. 
To be short, my problem is the following:
I must track outgoing SYN+ACK packets (confirmation of connection
request) and incoming ACK packets acknowledging the SYN+ACKs. With this,
the module would be able to calculate the ratio of half open
connections. 
It is easy to track outgoing SYN+ACKs, but to decide if an incoming ACK
is a response to a former SYN+ACK I have to track the state of the TCP
connection. Of course I dont want to do this, because the TCP conntrack
module makes this - It would be a nonsense and a source of inconsistency
to track the state in both modules.
Please tell me, how could my module interact with the TCP conntrack
module to get the connection state information.

Thank you!

(a student from Hungary)
