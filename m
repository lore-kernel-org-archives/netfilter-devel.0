From: dmorris <dmorris@neogenen.com>
Subject: Transparent proxy non-local bind conflict.
Date: 07 Apr 2003 12:09:49 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1049742595.401.41.camel@timmy>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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

Hello all,

I'm writing a transparent proxy app, which uses the non-local binding
patch and friends here:
http://www.neogenen.com/patches/netcap.kernel-2.5.66.040303.patch

Here's the typical setup:
[box A] <----------> [box T] <--------> [box B]

Here's a step by step play.
A makes a connection to B, which T uses redirect to direct to the
transparent proxy app.
T then gets the original (dest,port) and origal (src,port) binds the
socket to the original (src,port) and makes a connection to the original
(dst,port).

And here's the problem I'm having:
The second connection (t->b) fails. T sends a syn to B,
B replies with a syn/ack (to who it thinks is A, but is actually T)
but T rejects with a RST.

The reason for this, I suspect, is that there are two connections (a->t
and b->t) with the exact same 5-tuple (protocol, src, dst, src-port,
dst-port), and so ip_conntrack kills the second connection. 
(I must have ip_conntrack to do the redirection)
So does anyone have any ideas how I can break ip_conntrack to handle 
both connections, or perhaps ignore the second one?

thanks,
-dirk 
 

-- 
//* */   dmorris   (* www.neogenen.com *)
main(){int _=0;for(;_!=1687193639&&putchar(" \
dn\nc@oge.m"[abs(_%11)]);_=(_*42913)+115127);}
