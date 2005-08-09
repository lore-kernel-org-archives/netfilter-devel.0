From: Derrick Sawyer <derrick@ip3.com>
Subject: Error compile kernel 2.6.11.7 w/ pptp_conntrack_nat
Date: Tue, 09 Aug 2005 01:34:10 -0700
Message-ID: <42F86A82.6060500@ip3.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

Hi all,

I am getting this error when compiling kernel 2.6.11.7 with pptp 
patch-o-matic patch:

LD      .tmp_vmlinux1
net/built-in.o(.text+0x68bce): In function `timeout_ct_or_exp':
: undefined reference to `__ip_conntrack_expect_find'
make: *** [.tmp_vmlinux1] Error 1

I have the latest subversion of patch-o-matic-ng.

Any suggestions will be greatly appreciated.

 Thanks,
~Derrick
