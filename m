From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Compilation error: nf_debug in nfnetlink.c
Date: Fri, 05 Dec 2003 18:58:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FD0B925.6020205@netlab.hut.fi>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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

Hi!

While compiling nfnetlink.c I got the following error:

nfnetlink.c: In function `nfnetlink_rcv_msg':
nfnetlink.c:231: parse error before `)'
nfnetlink.c:238: parse error before `)'
nfnetlink.c:244: parse error before `)'
make[2]: *** [nfnetlink.o] Error 1
make[2]: Leaving directory `/usr/src/linux-2.4.23/net/ipv4/netfilter'
make[1]: *** [_modsubdir_ipv4/netfilter] Error 2
make[1]: Leaving directory `/usr/src/linux-2.4.23/net'
make: *** [_mod_net] Error 2

The error occurs in only three occurences of nf_debug(level, format, 
arg...) which do not have any arguments.

Example:
231        nf_debug(0, "received non-request message\n");
This line does not work while the following works:
256        nf_debug(0, "permission denied for type %d\n", type);


Did someone already se this problem? Any idea about wat causes it?

            Emmanuel
