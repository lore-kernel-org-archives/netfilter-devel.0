From: "Shaun Hedges" <sh@realsecure.net>
Subject: (no subject)
Date: Sat, 30 Aug 2003 22:51:12 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <IAEOKBNDAKLABMLEEMMKIEBBFNAA.sh@realsecure.net>
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

Hello,

We have high speed applications that open up hundreads of threads per
computer very fast then close then open again.  At one time, we can have
about 15000 tcp connections going through the firewall at once.  We've
recently been adding more application servers but we're noticing that the
bandwidth usage isn't going up intune with the number of computers, it's
actually stay the same.  We know this shouldn't be the case so am wondering
if 15000+ connections is too much for a RH Linux+netfilter configuration,
using no stateful inspection just basic FORWARD'ing rules to block all
traffic from those machines except one port coming in.

Our router is a P1.7ghz Celeron w/ 512mb ram and IDE disks..  Is this
insufficient?  Our b/w usage is a mere 2mbits, but we have 10mbits
available, and when it goes up, we seem to add more incoming bandwidth as
outgoing, it looks as though the errors or timeouts are increasing.

Any ideas?

Thx
