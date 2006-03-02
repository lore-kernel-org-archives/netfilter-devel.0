From: Gervasio Bernal <gervasiobernal@speedy.com.ar>
Subject: Table NAT and MANGLE
Date: Thu, 02 Mar 2006 17:29:08 -0300
Message-ID: <44075594.3000608@speedy.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
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

Hi all!!

Suppose I have this 2 rules, one in mangle and the other one in NAT table:

#iptables -t mangle -A POSTROUTING -o eth0 -j TTL --ttl-set 64
#iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

So, every time a packet goes out through eth0 first it sets the TTL to
64 and then do the masquerade. Is there any way to do this but in
opposite order? First masquerade and the TTL.
Maybe this example is not very clear, but I'm developing a module that
needs to match a packet after masquerade.

Thanks.
