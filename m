From: luoqiang <luoqiang@ict.ac.cn>
Subject: conntrack/NAT module
Date: Wed, 5 Jun 2002 10:36:48 +0800
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <02060510364800.10075@luoqiang>
Reply-To: luoqiang@ict.ac.cn
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: laforge@gnumonks.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,Harald

   Thanks for your answers.
   I am afraid that the conntrack module for DNAT is not correct now.my 
purpose of the two module is to achieve the rule  which is "iptables -A 
PREROUTING -t nat -p udp -d 159.226.1.1 --dport 5001 -j DNAT --to 
192.168.1.2:8888".
   The code of conntrack module is as follows:

static int foo_help(const struct iphdr *iph, size_t len,
                       struct ip_conntrack *ct,
		       enum ip_conntrack_info ctinfo)
{
        struct ip_conntrack_tuple t,mask;
        t = ((struct ip_conntrack_tuple)
		{ { 0, { 0 } },
		  { 0x0101e29f, { htons(5001) }, IPPROTO_UDP }});  // 
proto=17,dst=159.226.1.1,dport=5001
	mask = ((struct ip_conntrack_tuple)
		{ { 0, { 0 } },
		  { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});
	ip_conntrack_expect_related(ct, &t, &mask, NULL);
	return NF_ACCEPT;
}
static struct ip_conntrack_helper foo = { { NULL, NULL },
					  { { 0, { 0 } },
					    { 0x0101e29f, { 0 }, IPPROTO_UDP } },
					  { { 0, { 0 } },
					    { 0xFFFFFFFF, { 0 }, 0xFFFF } },
					  foo_help };                          // proto=17,dst=159.226.1.1
int init_module(void)
	
	{
               return ip_conntrack_helper_register(&foo);
       	 }
void cleanup_module(void)
       {
               ip_conntrack_helper_unregister(&foo);
       }
   After insmod the conntrack module and receiving udp packges sended to 
159.226.1.1,I can see "EXPECTING: proto=17 src=0.0.0.0 dst=159.226.1.1 
sport=0 dport=5001"in /proc/net/ip_conntrack.I don't know if my conntrack for 
DNAT is correct?
   The code of my nat module is as follows:

  static int foo_nat_expected(struct sk_buff **pksb,
                          unsigned int hooknum,
                          struct ip_conntrack *ct,
                          struct ip_nat_info *info,
                          struct ip_conntrack *master,
                          struct ip_nat_info *masterinfo,
                          unsigned int *verdict)
   {
     struct ip_nat_multi_range mr;
     u_int32_t newdstip;
     if (HOOK2MANIP(hooknum)==IP_NAT_MANIP_DST){
     newdstip = 0x0201a8c0;                   //192.168.1.2
     mr.rangesize=1;                                                 
     mr.range[0].flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
     mr.range[0].min = mr.range[0].max = ((union ip_conntrack_manip_proto)
                                 { htons(8888) });             // forward 
159.226.1.1:5001 to 192.168.1.2:8888,correct?
     *verdict = ip_nat_setup_info(ct, &mr, hooknum);
     printk("###########  foo_nat_expected  finished #############\n");
     return 1;
     }
  }
 
  static unsigned int foo_help(struct ip_conntrack *ct,
                  struct ip_nat_info *info,
                  enum ip_conntrack_info ctinfo,
                  unsigned int hooknum,
                  struct sk_buff  **pksb)
  {

      return NF_ACCEPT; // I don't know what I can do here
  }
 
  static struct ip_nat_expect foo_expect = { { NULL, NULL }, foo_nat_expected 
};
 
  static struct ip_nat_helper hlpr = { { NULL, NULL },
					  { { 0, { 0 } },
					    { 0x09050a0a, { 0 }, IPPROTO_UDP } },
					  { { 0, { 0xFFFF } },
					    { 0xFFFFFFFF, { 0 }, 0xFFFF } },
					  foo_help , "test" };

int init_module(void)
{
       int ret;
       if ((ret=ip_nat_expect_register(&foo_expect))==0){
       ret=ip_nat_helper_register(&hlpr);
       if (ret!=0)
	       ip_nat_expect_unregister(&foo_expect);
       }
       return ret;
}
 
void cleanup_module(void)
{
       ip_nat_helper_unregister(&hlpr);
       ip_nat_expect_unregister(&foo_expect);
}
 
   After the 159.226.1.1 received udp package to 5001 port, I can see the 
"###########  foo_nat_expected  finished #############"imformation for each 
package.But there is no DNAT happened.I copy the code from ip_conntrack_ftp.c 
and ip_nat_ftp.c. where I made the mistake?

Thanks 

luoqiang

____________________________________________________________________________


> Hi,all
> 
> Sorry to resend this mail,last mail is not can be seen.
> I am writing a DNAT module to achieve the purpose which is  identical to
>  "iptables -A PREROUTING -t nat -p udp -d 159.226.1.1 --dport 5000 -j DNAT 
> --to 192.168.1.2:5000".
> host A----------------------------->host  B-------------------->host C
 159.226.1.2--------------->159.226.1.1/192.168.1.1--------------->192.168.1.2
> I have read the hacking howto and have finished the conntrack module,which 
> can be seen in "proc/net/ip_conntrack" 
> file of host B as"EXPECTING : proto=17 src=0 dst=159.226.1.1 sport=0 
> dport=5000"
> But something wrong in my nat module.
> After loaded the module, no DNAT happened. :-(
> there are some questions I don't understand.
> 1.what's the function of foo_help in struct ip_nat_helper?I do nothing here.

to mangle (nat) the payload of the master connection (i.e. if it contains
an internal IP address sent by the client behind SNAT to the server).

> 2. what's the function of struct ip_nat_multi_range here?what's the 
function  
>    of struct ip_nat_range range[0] and  struct ip_nat_range range[1]?(I 
don't 
>    know what's the meaning of " hangs off end. ")

hangs off end == after the end of the structure

> 3.how to configure the struct ip_nat_multi_range when do DNAT?

look  at line 81... of ip_nat_ftp.c

> 4.if I want to close the port after open it in a module,how I can do?

how do you open a port in a module?  everything you do is creating conntrack
entries and NAT bindings.

> my code is here:
> ......
>   static int foo_nat_expected(struct sk_buff **pksb,

>      if (HOOK2MANIP(hooknum)==IP_NAT_MANIP_DST){        
>   
>      mr.rangesize=1;
>      mr.range[0].flags = IP_NAT_RANGE_PROTO_SPECIFIED;   //  I don't know 
> what's the meaning here

PROTO_SPECIFIED == NAT of port
IP == NAT of IP address

please look more detailed at the other available examples.

> luoqiang
