From: Wang Jian <lark@linux.net.cn>
Subject: new REBOOT target
Date: Sat, 26 Feb 2005 22:30:47 +0800
Message-ID: <20050226215628.C7D1.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------_4220800BC7CC049378A8_MULTIPART_MIXED_"
Content-Transfer-Encoding: 7bit
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

--------_4220800BC7CC049378A8_MULTIPART_MIXED_
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit

Hi,

For my own purpose, I write a REBOOT target to remotely reboot a linux
box using specially crafted ICMP packet.

One of my servers has symptom that httpd locks machine:

1. console is locked, not usable;
2. network seems to be good, ICMP echo/reply is ok; tcp connection can
   be established on open ports, but userspace server programs seem to
   be out of luck;
3. if keep it as it for quite a long time, network dies but console
   works again;

The server is hosted in a remote small data center, and it is not
possible to get there everytime it is locked.

That is the scenario this REBOOT target fits. I am interested in other
usage if someone else can find. I post it here in case it is also useful
for others.

Usage: 

# iptables -I INPUT -p icmp -j REBOOT --passphrase pass [--offset offset]
[--hard (0|1)]

A perl script is used to send special ICMP packet.


All files are in attached tarball.

Some notes on the source code:

1. There are hardcode paths in Makefile, so some modification is needed
   to compile;
2. The code is for iptables 1.2.9;
3. --passphrase is mandatory. There is string matching functionality in
   ipt_string, however ipt_string is not standard module, and missing in
   many distributions' kernel. So I write my own matching code. If
   ipt_string becomes standard, then this parameter can be eliminated along
   with --offset.
4. reboot code is ugly. I want it to support a more safe reboot, such as
   sync() then sys_reboot(), but sys_reboot() need a userspace pointer,
   cannot be called directly from kernel.
5. There is a reserved 'count' which can be used to do
   trigger-n-times-then-do-it control.

Any feedback and suggestion is welcome :)



-- 
  lark

--------_4220800BC7CC049378A8_MULTIPART_MIXED_
Content-Type: application/octet-stream;
 name="nfreboot-0.1.tar.gz"
Content-Disposition: attachment;
 filename="nfreboot-0.1.tar.gz"
Content-Transfer-Encoding: base64

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
--------_4220800BC7CC049378A8_MULTIPART_MIXED_--
