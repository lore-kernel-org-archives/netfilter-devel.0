From: "Jethro Tull" <heavytull@hotmail.com>
Subject: iptable compiled but errors returned
Date: Fri, 23 Jun 2006 23:15:23 +0000
Message-ID: <BAY117-F214B69F9F76C14D595429FAD7A0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
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

I just compiled iptables by doing so:
make KERNEL_DIR=/kernel/source

but the returned message for all files compiled is as follows:


cc -O2 -Wall -Wunused -I/usr/src/kernel/linux-2.6.17//include -Iinclude/ 
-DIPTABLES_VERSION=\"1.3.5-20060622\"  -D_UNKNOWN_KERNEL_POINTER_SIZE 
-DIP6T_LIB_DIR=\"/usr/local/lib/iptables\" -c -o ip6tables.o ip6tables.c


the "-D_UNKNOWN_KERNEL_POINTER_SIZE..." is it normal??

_________________________________________________________________
Be the first to hear what's new at MSN - sign up to our free newsletters! 
http://www.msn.co.uk/newsletters
