From: "Ricky Foo" <blue_pion@hotmail.com>
Subject: (no subject)
Date: Mon, 16 Jun 2003 06:58:30 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Sea2-F8kVfbuhhhETAp00011d9c@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
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

Hi,

It's me again.







static int help_ns(const struct iphdr *iph, size_t len,
                	 struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
{
  struct udphdr *udph = (void *)iph + iph->ihl * 4;
  u_int32_t udplen = len - iph->ihl * 4;
  struct nbnshdr *nbnsh = (void *)udph + 8;

  int dir = CTINFO2DIR(ctinfo);
  struct ip_ct_netbios_udp *info = (struct ip_ct_netbios_udp 
*)&ct->help.ct_ftp_info;
struct ip_conntrack_expect expect;
	struct ip_ct_netbios_ns_expect
     *exp_netbios_ns_info = &expect.help.exp_netbios_ns_info;
  u_int16_t sPort=NETBIOS_NS_PORT, dPort = NETBIOS_NS_PORT;

  /* Can't track pre-connected streams */
	if (!info)
		return NF_ACCEPT;

  if (dir != IP_CT_DIR_ORIGINAL)
    return NF_ACCEPT;

	/* Not whole UDP header? */
	if (udplen < sizeof(struct udphdr))
  {
	  printk("netbios_ns: udplen = %u\n", (unsigned)udplen);
		return NF_ACCEPT;
	}

	/* Checksum invalid?  Ignore. */
	if (csum_tcpudp_magic(iph->saddr, iph->daddr, udplen, IPPROTO_UDP, 
csum_partial((char *)udph, udplen, 0)))
  {
	  printk("netbios_ns: bad csum: %p %u %u.%u.%u.%u - %u.%u.%u.%u\n",
		       udph, udplen, NIPQUAD(iph->saddr), NIPQUAD(iph->daddr));
		return NF_ACCEPT;
	}

	LOCK_BH(&ip_netbios_ns_lock);
  memset(&expect, 0, sizeof(expect));
  /* Update netbios ns info */
  exp_netbios_ns_info->trn_ID = ntohs(nbnsh->name_trn_ID);

  /* Update expected stream info */
  expect.tuple = ((struct ip_conntrack_tuple)
		  	{{ ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip, { htons(sPort) }},
	    	 { ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip, { htons(dPort) }, 
IPPROTO_UDP}});
  expect.mask = ((struct ip_conntrack_tuple)
					   {{ 0, { 0 } }, { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});
	expect.expectfn = NULL;

	printk ("netbios_ns: expect_related: %u.%u.%u.%u:%u - %u.%u.%u.%u:%u, ",
            NIPQUAD(expect.tuple.src.ip),
        		ntohs(expect.tuple.src.u.udp.port),
   					NIPQUAD(expect.tuple.dst.ip),
        		ntohs(expect.tuple.dst.u.udp.port));
  printk("trn_ID = 0x%x\n", ntohs(nbnsh->name_trn_ID));
  ip_conntrack_expect_related(ct, &expect);
	UNLOCK_BH(&ip_netbios_ns_lock);

  return NF_ACCEPT;
}


    Ricky

_________________________________________________________________
Download Norah Jones, Eminem and more! http://www.msn.com.sg/ringtones/
