From: Georg Chini <georg.chini@triaton-webhosting.com>
Subject: iptables+2.6-test8-bk4 : Still problems
Date: Sun, 26 Oct 2003 09:48:29 +0100
Sender: sparclinux-owner@vger.kernel.org
Message-ID: <3F9B8A5D.9010803@triaton-webhosting.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
To: sparclinux@vger.kernel.org, netfilter-devel@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

on my sparc64 (ultra1) I am using ppp and ipsec
to get a tunnel to my office. Before 2.6.0-test8-bk4
my computer would freeze when using any iptables command.
With 2.6.0-test8-bk4 "iptables -F" responds with
"invalid argument" when my ppp interface is up and
the tables will not be flushed.
/usr/local/sbin/iptables -A INPUT -i ppp0 -j ACCEPT
works, but the corresponding
/usr/local/sbin/iptables -D INPUT -i ppp0 -j ACCEPT
does not, again I get "invalid argument".
When I additionally start ipsec (using freeswan 2.03)
things will get worse. Every iptables command referring
to the ppp interface or the IP-address of the ppp interface
is rejected with "invalid argument".
Any suggestions how to fix this are welcome.
If you need more debugging output, I can supply it.
As I am not sure wether this is a sparc-only problem,
I post this to netfilter-devel too.

Thanks in advance
                   Georg Chini

