From: Brindha M P <brindha@multitech.co.in>
Subject: Compiling IPTables-1.2.9 with Linux Kernel 2.4.6
Date: Thu, 22 Jan 2004 18:46:01 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <400FCD11.2A953624@multitech.co.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hi,

    We face errors while compiling IPTables - 1.2.9 with Linux Kernel
2.4.6.

Kernel is compiled with Network packet filtering as inbuilt, IPTables
support
as inbuilt (other sub-options included as module)

Looks like the user-space iptables source code is referencing header
files which is not present in the Kernel code.

Could you please throw some light on iptables version & kernel version
compatibility ?
i.e Which iptables (user-space) version is compatible with 2.4.6 Linux
Kernel ?

Any technical help / info on this issue is welcomed.

Thanks in advance,
Regards,
Brindha
