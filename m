From: "HakRz1" <HakRz1@punkass.com>
Subject: ip_conntrack_ftp.c kernel source more ports
Date: Mon, 19 Jan 2004 23:38:08 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <001101c3df28$5a342ac0$0100a8c0@hak>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,
    im trying to make a big security flaw in my network but i want to try
anyways ...what im trying to do is make ip_conntrack_ftp monitor all non
standard ports instead of defualt 21
 i know ip_conntrack_ftp.h is where it gets port 21 defined
is there anyway to make it monitor all FTP ports without typing in all ports
manually

i know alot of you dont like this idea but the way i figure it is to get
Active FTP to work on non standard ports ( or even using pasv) you cant
close the firewall can only close ports 1-1080 for pasv to work
if i can get this module to work with all ports then i can enable
established and related  connections only...sounds secure to me more so than
before with ports 1-1080 :)

Hope somone can help me with this

also i already know about modprobe ip_conntrack_ftp ports=...etc but this is
a hassle to do

im running kernel 2.6.0 / iptables v1.2.8 / slackware 9.1

Thanks
