From: "Jan Holmberg" <jan@artech.se>
Subject: Message for local interface lo for "icmp error responses" is
	invalid ?
Date: Mon, 21 Feb 2005 01:04:12 +0100
Message-ID: <01b401c517a8$dfa5d960$6401a8c0@stopen1>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: <netfilter-devel@lists.netfilter.org>
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

New invalid messages for lo interface in ipv4,icmp.c code in kernel =
2.6.11-rc4 and higher version....
And I have netfilter 1.3.0, Sorry if this is wrong forum.

Feb 21 00:19:06 rb3 last message repeated 7 times
Feb 21 00:19:48 rb3 last message repeated 8 times
Feb 21 00:20:43 rb3 last message repeated 6 times
Feb 21 00:23:45 rb3 kernel: 213.115.224.241 sent an invalid ICMP type 3, =
code 1 error to a broadcast: 0.0.0.0 on lo
Feb 21 00:24:48 rb3 last message repeated 14 times
Feb 21 00:25:37 rb3 last message repeated 3 times
Feb 21 00:27:05 rb3 kernel: 213.115.224.241 sent an invalid ICMP type 3, =
code 1 error to a broadcast: 0.0.0.0 on lo
Feb 21 00:27:13 rb3 last message repeated 2 times
Feb 21 00:29:06 rb3 last message repeated 7 times
Feb 21 00:29:48 rb3 last message repeated 8 times


ip addr sh give follow:

1: lo: <LOOPBACK,UP> mtu 16436 qdisc noqueue
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 brd 127.255.255.255 scope host lo

Can't see any problem with this configuration on local interface, but =
can someone explain what code 1 error means.
No other interface give me this message, and I have lot of interface in =
this computer.

With  icmp_ignore_bogus_error_responses enabled no error messages are =
displayed, but it should not trigger on
local device in any way I think.=20


//Jan
