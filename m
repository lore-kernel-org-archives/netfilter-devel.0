From: zhengchuanbo <zhengcb@netpower.com.cn>
Subject: how to filter tagged frames of different vlanid in one bridge?
Date: Wed, 8 Jan 2003 9:41:32 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200301080937906.SM01092@zhengcb>
Mime-Version: 1.0
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

we use linux as our firewall. the firewall worked at bridge mode. it is connected to the trunk port of the switch. what we want to do is to filter the vlan tagged frames(802.1Q) by ip address.i tried two methods:
	
1.by ebtables
	ebtables can filter 802.1Q protocol. but it can not filter by ip address. it can only filter the ip address when the protocol is IPV4. i wish i could do the job by ebtables.
2.by bridge-nf patch and vconfig
	i can filter by ip address to certain tagged frames. i did it like this,
		/sbin/vconfig add eth0 2
		/sbin/vconfig add eth1 2
       	ifconfig eth0.2 up
		ifconfig eth1.2 up
		brctl addbr br0
		brctl addif eth0.2
		brctl addif eth1.2
	after i applied the patch bridge-nf,netfilter works for the vlan frames. the problem is we have many vlans(more than ten). so i have to build a bridge for all the vlans. 

	so what i want to do is to filter the tagged frames of differen vlans in the same bridge. i can't find a way to do that. is there some solution to that?	
	
thanks in advance. please cc.

regards,
chuanbo zheng
zhengcb@netpower.com.cn
