From: =?gb2312?q?Dig=20Harry?= <digharry@yahoo.com.cn>
Subject: How to do SNAT and DNAT when FW is the Mixed(Bridge and Route) mode?
Date: Thu, 27 Feb 2003 10:58:30 +0800 (CST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030227025830.48732.qmail@web15204.mail.bjs.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: 8bit
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

My network is the following:

              External(0.0.0.0)
                 ^
             ____|eth0____
            |    FW      
|eth1-->DMZ(192.168.200.0/24)
             -------------
             eth2|
                 V
              Internal(10.1.1.0/24)

Linux Kernel have patched
"bridge-nf-0_0_7-against-2_4_18_diff"
My config is:
brctl addbr br0
ifconfig eth0 0.0.0.0
ifconfig eth1 0.0.0.0
brctl addif br0 eth0
brctl addif br0 eth1
ifconfig br0 192.168.200.1 netmask 255.255.255.0
ifconfig eth2 10.1.1.1 netmask 255.255.255.255.0

from Internal to DMZ or External must do SNAT.

I set policy:
iptables -t nat -A POSTROUTING -o eth0 -j SNAT
--to-source 192.168.200.1
iptables -t nat -A POSTROUTING -o eth1 -j SNAT
--to-source 192.168.200.1

Accessing from Intenal to DMZ or External can not
pass!

My config is correct???
The "bridge-nf" patch can support the case???(if not,
how to do?) 
Thank you very much!



               


_________________________________________________________
Do You Yahoo!? 
"用雅虎搜索，找到关于奥斯卡的一切"
http://cn.search.yahoo.com/search/cn?p=%b0%c2%cb%b9%bf%a8
