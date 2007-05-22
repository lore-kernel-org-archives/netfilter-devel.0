From: "YU\, Haitao" <yuhaitao@tsinghua.org.cn>
Subject: bugs in ftp conntrack
Date: Tue, 22 May 2007 14:24:37 +0800
Message-ID: <379815077.04066@tsinghua.org.cn>
Reply-To: "YU, Haitao" <yuhaitao@tsinghua.org.cn>
Content-Type: text/plain
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi,


If the order of ftp packets are wrong, function find_nl_seq() in
net/ipv4/netfilter/ip_conntrack_ftp.c will make mistake.

i.e., consider three ftp packets: "port", "list" and "noop", 
if the "list" and "noop" packets reach firewall before "port" packet,
then info->seq_aft_nl will record  the sequence of "noop". Kenerl will
not parse "port" packet because the seq does not match the recored one .

If kernel can't trace expect connection, then the attack described in
[phrack-63, 0x13] will happen.


Another problem is if the packet length is changed bye NAT, then the
next packet will not be parsed. So kernel can not parse the 2nd "port"
packet of two continual "port" packets. Though it's impossible in legal
ftp connection, and I also don't know how to use this to hack firewall.


Third, the value of "oldest" in function udpate_bl_seq() seem unchanged
after four packets.


Regards,

YU, haitao
