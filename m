From: "Andrew Hall" <temp02@bluereef.com.au>
Subject: bug in mport module
Date: Wed, 21 Jan 2004 17:16:58 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <0c1601c3dfe6$2d179c20$2601010a@bluereef.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <af@devcon.net>
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

Not sure to where I report this, but there's a fairly nasty bug that I
assume is in the mport patch.

When adding a rule such as:
iptables -t nat -A PREROUTING -p tcp -m mport --dports 80 -j
REDIRECT --to-ports 8080
the kernel panics.

Through experimentation it only seems to be a problem when using NAT and any
of the appropriate targets: REDIRECT, DNAT, SNAT, MASQUERADE.

I'm using 2.6.1-mm3 and I'm not sure if it's come about since the change to
2.6.x. This problem doesn't seem to effect use in other tables and the
multiport patch doesn't seem to have this problem.

Pls. let me know if you need any more information.

regards,

Andrew.
