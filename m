From: Rich Wellner <netfilter@objenv.com>
Subject: trouble with expect_related
Date: Fri, 03 Jan 2003 18:13:03 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <t2mk7hlwz5c.fsf@rw2-laptop.wellner.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

I'm writing a module for ipfilters to deal with a protocol we use at work.
You'll pardon me for being long winded, but I'm not positive what's going
wrong.

The init works:

static int __init init(void)
{
  int retVal;
  memset(&dccp, 0, sizeof(struct ip_conntrack_helper));

  printk("ip_conntrack_dccp: registered\nbuild: %s, %s\n", __DATE__, __TIME__);
       
  dccp.tuple.src.u.tcp.port = htons(DCCP_PORT);
  dccp.tuple.dst.protonum = IPPROTO_TCP;
  dccp.mask.src.u.tcp.port = 0xFFFF;
  dccp.mask.dst.protonum = 0xFFFF;
  dccp.help = dccp_help;

  retVal = ip_conntrack_helper_register(&dccp);
	printk("retVal: %d\n", retVal);
	return retVal;
}

I claim it works because i see log messages and the helper is called as
expected.

My problem is with the helper.  I parse the packet out and run
ip_conntrack_expect_related but the incoming connection doesn't get passed
through.  I have verified using tcpdump that the connection request does come
from the remote machine, but my module doesn't seem to have registered the
return right.  Anyway, here's the helper (more commentary follows code):

static int dccp_help(const struct iphdr *iph, size_t len, 
                struct ip_conntrack *ct, 
                enum ip_conntrack_info ctinfo)
{
  struct tcphdr *tcph = (void *)iph + iph->ihl * 4;
  const char *data = (const char *)tcph + tcph->doff * 4;
  const char *_data = data;
  char *data_limit;
  u_int32_t tcplen = len - iph->ihl * 4;
  u_int32_t datalen = tcplen - tcph->doff * 4;
  int dir = CTINFO2DIR(ctinfo);
  struct ip_conntrack_tuple t, mask;
  u_int32_t dccp_ip;
  u_int16_t dccp_port;

  struct ip_ct_irc *info = &ct->help.ct_irc_info;

  /* Can't track connections formed before we registered */
  if (!info)
    return NF_ACCEPT;

  /* If packet is coming from IRC server */
  if (dir == IP_CT_DIR_REPLY)
    return NF_ACCEPT;

  /* Until there's been traffic both ways, don't look in packets. */
  if (ctinfo != IP_CT_ESTABLISHED
      && ctinfo != IP_CT_ESTABLISHED + IP_CT_IS_REPLY) {
    printk("Conntrackinfo = %u\n", ctinfo);
    return NF_ACCEPT;
  }

  /* Not whole TCP header? */
  if (tcplen < sizeof(struct tcphdr) || tcplen < tcph->doff * 4) {
    printk("tcplen = %u\n", (unsigned) tcplen);
    return NF_ACCEPT;
  }

  /* Checksum invalid?  Ignore. */
  /* FIXME: Source route IP option packets --RR */
  if (tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
                   csum_partial((char *) tcph, tcplen, 0))) {
    printk("bad csum: %p %u %u.%u.%u.%u %u.%u.%u.%u\n",
		     tcph, tcplen, NIPQUAD(iph->saddr),
		     NIPQUAD(iph->daddr));
    return NF_ACCEPT;
  }

  if( strstr(data, "open") ) {
    printk("open packet: %s", data);

  mask = ((struct ip_conntrack_tuple)
		{ { 0xFFFFFFFF, { 0 } },
		  { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});

  parse_command(data, &dccp_ip, &dccp_port );

  printk("recieving socket is %d:%d\n", dccp_ip, dccp_port);

  LOCK_BH(&ip_dccp_lock);

  memset(&t, 0, sizeof(t));
  t.src.ip = ct->tuplehash[!dir].tuple.src.ip;
  t.src.u.tcp.port = 0;
  t.dst.ip = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
  t.dst.u.tcp.port = htons(dccp_port);
  t.dst.protonum = IPPROTO_TCP;

  printk("expect_related %u.%u.%u.%u:%u-%u.%u.%u.%u:%u\n",
         NIPQUAD(t.src.ip),
         ntohs(t.src.u.tcp.port),
         NIPQUAD(t.dst.ip),
         ntohs(t.dst.u.tcp.port));

  ip_conntrack_expect_related(ct, &t, &mask, NULL);
  UNLOCK_BH(&ip_dccp_lock);
  }

  return NF_ACCEPT;
}

Anyone capable of helping me will probably recognize the general structure of
the above code as being that from the existing ftp/irc modules.  I tried to
use the doc on netfilter.org, but it seems to be pretty outdated, making, for
example, references to structure elements that don't exist anymore.

Significantly the last printk above shows what I expect to see: 
Jan  3 17:45:54 oxygen kernel: expect_related 131.225.80.34:0-207.252.250.2:38344

but the incoming connection, as i say above, never makes it through.

I've tried several different variations, but would be willing to try more if
people have only suggestions but no answers.  I'm just a bit out of my wits
right now because the doc seems old and the many changes I've tried don't
provoke any different behavior so I've not much to go on.  Frustrating.

Thanks in advance.

rw2
