From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Bug in rpc conntrack modules
Date: 28 Apr 2003 00:47:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051483678.5944.223.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Marcelo Barbosa Lima <marcelo.lima@dcc.unicamp.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Marcelo.

I've just found a small bug in how you handle the name member of
struct ip_conntrack_helper rpc_helpers

You use one piece of memory which you overwrite for each port.
The struct only holds a pointer to the string, not a copy of it.
Please look at how other helpers do.

If you send me a patch against patch-o-matic I'll commit it.

-- 
/Martin
