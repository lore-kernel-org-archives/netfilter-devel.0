From: luoqiang <luoqiang@ict.ac.cn>
Subject: conntrack/NAT module
Date: Mon, 3 Jun 2002 12:06:38 +0800
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <02060312063802.01904@luoqiang>
Reply-To: luoqiang@ict.ac.cn
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: luoqiang@ict.ac.cn
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,all

Sorry to resend this mail,last mail is not can be seen.
I am writing a DNAT module to achieve the purpose which is  identical to
 "iptables -A PREROUTING -t nat -p udp -d 159.226.1.1 --dport 5000 -j DNAT 
--to 192.168.1.2:5000".

host A-------------------------------->host 
B------------------------------------->host C
159.226.1.2--------------->159.226.1.1/192.168.1.1--------------->192.168.1.2

I have read the hacking howto and have finished the conntrack module,which 
can be seen in "proc/net/ip_conntrack" 
file of host B as"EXPECTING : proto=17 src=0 dst=159.226.1.1 sport=0 
dport=5000"
But something wrong in my nat module.
After loaded the module, no DNAT happened. :-(
there are some questions I don't understand.
1.what's the function of foo_help in struct ip_nat_helper?I do nothing here.
2. what's the function of struct ip_nat_multi_range here?what's the function  
   of struct ip_nat_range range[0] and  struct ip_nat_range range[1]?(I don't 
   know what's the meaning of " hangs off end. ")
3.how to configure the struct ip_nat_multi_range when do DNAT?
4.if I want to close the port after open it in a module,how I can do?


my code is here:
......
  static int foo_nat_expected(struct sk_buff **pksb,
                          unsigned int hooknum,
                          struct ip_conntrack *ct,
                          struct ip_nat_info *info,
                          struct ip_conntrack *master,
                          struct ip_nat_info *masterinfo,
                          unsigned int *verdict)
 
  {
     struct ip_nat_multi_range mr;
     u_int32_t newdstip = 0x0201a8c0;
     if (HOOK2MANIP(hooknum)==IP_NAT_MANIP_DST){        
  
     mr.rangesize=1;
     mr.range[0].flags = IP_NAT_RANGE_PROTO_SPECIFIED;   //  I don't know 
what's the meaning here
     mr.range[0].min = mr.range[0].max = ((union 
ip_conntrack_manip_proto){htons(5000)});
     mr.range[0].min_ip=mr.range[0].max_ip=newdstip;

     *verdict = ip_nat_setup_info(ct,&mr,hooknum);

     return 1;
     }
  }

Thanks in advance,
luoqiang

luoqiang@ict.ac.cn
