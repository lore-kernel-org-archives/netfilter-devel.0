From: Lenard-Alexander Wiedenroth <lwiede@et-inf.fho-emden.de>
Subject: problem with udp nat/conntrack module programming
Date: Tue, 21 Jan 2003 05:34:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1043123692.3e2ccdecbc5a2@secure.et-inf.fho-emden.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
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

hi list,
i'm trying to write a iptables-module to capture special udp-packets and open TCP-ports according to the udp-packets data. yet i'm not much more than a newbie, but i'm working on it ;-)
Right now, i'm plainly stuck; i got as far as compiling a conntrack and nat module and registering the helpers accordingly. but when i send a this-should-match-udp-packet, the callbackfunctions don't get called.
what i did looks like this:
--------------------------------
/* ip_nat_test.c */
...
static unsigned int expectme(...) {
  printk("something happened\n");
  return 1;
}

static unsigned int help(...) {
  printk("packet caught\n");
  return NF_ACCEPT;
}

static struct ip_nat_helper hlpr;

static int __init init(void) {
  int ret;
  memset(&hlpr, 0, sizeof(struct ip_nat_helper));
  hlpr.tuple.dst.protonum = IPPROTO_UDP;
  hlpr.tuple.dst.u.udp.port = htons(12345);
  hlpr.mask.dst.protonum = 0xFFFF;
  hlpr.mask.dst.u.udp.port = 0xFFFF;
  hlpr.help = help;
  hlpr.me = THIS_MODULE;
  hlpr.expect = expectme;
  printk("trying to register helper\n");
  if(ret=ip_nat_helper_register(&hlpr))
    printk("error, exiting\n");
  return ret;
}
static void __exit fini(void){
  ip_nat_helper_unregister(&hlpr);
}
module_init(init);
module_exit(fini);

-------------------------------
/* ip_conntrack_test.c */
...
static int help(...) {
  printk("conntrack: found packet\n");
  return NF_ACCEPT;
}
static struct ip_conntrack_helper hlpr;
static int __init init(void){
  int ret;
  memset(&hlpr, 0, sizeof(struct ip_conntrack_helper));
  hlpr.tuple.dst.protonum = IPPROTO_UDP;
  hlpr.tuple.dst.u.udp.port = htons(12345);
  hlpr.mask.dst.protonum = 0xFFFF;
  hlpr.mask.dst.u.udp.port = 0xFFFF;
  hlpr.max_expected = 2;
  hlpr.timeout = 300;
  hlpr.flags = IP_CT_HELPER_F_REUSE_EXPECT;
  hlpr.me = THIS_MODULE;
  hlpr.help = help;
  printk("conntrack: tryin to register helper\n");
  if(ret=ip_conntrack_helper_register(&hlpr))
    printk("conntrack: error, exiting\n");
  return ret;
}
static void fini(void) {
  ip_conntrack_helper_unregister(&hlpr);
}
module_init(init);
module_exit(fini);

-------------------------------
so, then i do "gcc -c -O2 -DMODULE -D__KERNEL__ -DLINUX -I{kerneldir}/include ip_{nat/conntrack}_test.c"
and "insmod ip_conntrack_test.o && insmod ip_nat_test.o".
both modules are loaded correctly, but as soon as i send an udp-packet ("nmap -sU -vvp 12345 123.234.45.6"), i cant find any messages in my kern.log.
what am i getting wrong ?? this should at least print "conntrack: packet found" in my logs (or segfault :]), but it doesnt ?!? i am using iptables 1.2.7a together with a 2.4.20 kernel and no p-o-m. any help is apprechiated !
thanx in advance,
lenard

-------------------------------------------------
This mail sent through IMP: http://horde.org/imp/
