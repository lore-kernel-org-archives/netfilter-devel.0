From: xiao shao <shao@tt.cs.titech.ac.jp>
Subject: iptables extension help
Date: Sun, 16 Nov 2003 13:35:05 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031116043510.936426D9B5@barrel.tokuda.cs-private>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter_devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I write a new iptables target for a test and compiled the
kernel without error messages. But when I tried to use this
target, I got the following error message.

*********************************************

ptables v1.2.6a: Couldn't load target `ORG':/lib/iptables/libipt_ORG.so: cannot open
shared object file: No such file or directory

Try `iptables -h' or 'iptables --help' for more information.

 *********************************************

I searched the entire machine for this file and couldn't find it.  I 
 am currently using Redhat 8.0 with version 2.4.20 of the linux kernel 
 and iptables v.1.2.6a.



Xiao Shao
