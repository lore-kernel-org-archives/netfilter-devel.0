From: Craig Shelley <craig@microtron.org.uk>
Subject: TCPFLAG <New>
Date: 29 Jun 2003 12:51:35 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1056887495.5490.844.camel@teratron>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-nHQ5zsfYeFgNel2Ma+GZ"
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


--=-nHQ5zsfYeFgNel2Ma+GZ
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi All,
	About a year ago, I made an iptables module/library to manipulate the
flags on TCP packets. Well... I have tested it on my server, and it has
been running without any errors for nearly a year. I have enclosed the
source code (sorry no docs). There is a little script in there to patch
the kernel source, and make TCPFLAG appear in menuconfig.

I use this module to open connections through a packet filter firewall
that is unfortunately between two of my boxes. The firewall drops all
inbound packets with the SYN flag set, so I use TCPFLAG masquerade SYN
packets as RST packets. (A bit crude, but it does the job!)
At the receiving end, I convert the RST packets that I sent from my host
back to SYN packets.

The target manipulates the flags using two parameters. The first
parameter being the mask (the flags that will be modified), and the
second parameter is the flags in the mask that will be turned on. 
This method provides flexibility, 
and is similar to the syntax of --tcp-flags

Here is an example of what I run on the machine outside the firewall...

iptables -t mangle -A POSTROUTING -d 123.123.123.123 -p tcp --tcp-flags
FIN,SYN,RST,ACK SYN -j TCPFLAG --mask SYN,RST --comp RST

And here's what I run on the machine behind the firewall...

iptables -t mangle -A PREROUTING -s 195.137.47.43 -p tcp --tcp-flags
FIN,SYN,RST,ACK RST -j TCPFLAG --mask SYN,RST --comp SYN

This module probably has some other uses, but I haven't thought of any.
The only bug I know of is that it doesn't handle connection tracking at
all :( so one of the machines (I can't remember which) does not see the
connection being made.  (nor does the firewall for that matter)
Since I am only using this code to do a temporary job, I don't
anticipate maintaining it. This is the reason I have not submitted it
before.

Well.... Enjoy, Let me know what you think 
I am not on this list, so please CC me

-- 
Craig Shelley <craig@microtron.org.uk>

--=-nHQ5zsfYeFgNel2Ma+GZ
Content-Disposition: attachment; filename=ipt_TCPFLAG-Patch.tar.gz
Content-Type: application/x-compressed-tar; name=ipt_TCPFLAG-Patch.tar.gz
Content-Transfer-Encoding: base64

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
27RN27S/U/svI9FWPABQAAA=

--=-nHQ5zsfYeFgNel2Ma+GZ--
