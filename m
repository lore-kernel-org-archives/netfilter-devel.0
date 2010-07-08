From: "Neco.F" <necofang@gmail.com>
Subject: about conntrack for oracle tns
Date: Thu, 8 Jul 2010 15:56:07 +0800
Message-ID: <AANLkTiknJ6FJvwaJrFL0q1StodFfaVrtu807JLqgz7sU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-kernel@vger.kernel.org, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35598 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab0GHH4b (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jul 2010 03:56:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hi,
  I have a conntrack module for oracle tns. the kernel version is 2.6.26.5.
 sometimes when I use this module to access the oracle server, the kernel panic.
 panic info: EIP:[xxx] get_next_timer_interrupt...........

 my source:

 #include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/netfilter.h>
#include <linux/ip.h>
#include <linux/ipv6.h>
#include <linux/ctype.h>
#include <linux/inet.h>
#include <net/checksum.h>
#include <net/tcp.h>
#include "conntrack_tns.h"
#include "debug.h"

#include <net/netfilter/nf_conntrack.h>
#include <net/netfilter/nf_conntrack_expect.h>
#include <net/netfilter/nf_conntrack_ecache.h>
#include <net/netfilter/nf_conntrack_helper.h>
#include <net/netfilter/nf_nat_helper.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Neco Fang <necofang@hotmail.com>");
MODULE_DESCRIPTION("oracle tns connection tracking helper");
MODULE_ALIAS("ip_conntrack_tns");

static char *tns_buffer = NULL;

static DEFINE_SPINLOCK(nf_tns_lock);

static u_int16_t ports[MAX_PORTS];
static unsigned int ports_c;
module_param_array(ports, ushort, &ports_c, 0400);

static int mangle_packet (struct sk_buff *skb,
			  __be32 newip,
			  u_int16_t port,
			  unsigned int matchoff,
			  unsigned int matchlen,
			  struct nf_conn *ct,
			  enum ip_conntrack_info ctinfo)
{
  char buffer[128];
  struct tnshdr_redirect * ptnshdr = (struct tnshdr_redirect * )buffer;

  sprintf (ptnshdr->datas,
"(ADDRESS=(PROTOCOL=tcp)(HOST=%u.%u.%u.%u)(PORT=%u))", NIPQUAD(newip),
port);
  ptnshdr->pkt_len = htons (sizeof (struct tnshdr_redirect) +
strlen(ptnshdr->datas) - 1);
  ptnshdr->pkt_checksum = 0x00;
  ptnshdr->tns_type = NF_CT_TNS_REDIRECT;
  ptnshdr->pkt_flags = 0;
  ptnshdr->head_checksum = 0x00;
  ptnshdr->data_len = htons (strlen(ptnshdr->datas));

  TNS_PRINT ("calling nf_nat_mangle_tcp_packet (%s) matchoff: %u
matchlen: %u", ptnshdr->datas, matchoff, matchlen);

  return (nf_nat_mangle_tcp_packet (skb, ct, ctinfo, matchoff,
matchlen, buffer, sizeof (struct
tnshdr_redirect)+strlen(ptnshdr->datas)-1));
}

static u_int nf_nat_tns (struct sk_buff *skb,
			 enum ip_conntrack_info ctinfo,
			 unsigned int matchoff,
			 unsigned int matchlen,
			 struct nf_conntrack_expect *exp)
{
  __be32 newip;
  u_int16_t port;
  struct nf_conn *ct = exp->master;
  enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);

  newip = ct->tuplehash[!dir].tuple.dst.u3.ip;
  exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;

  exp->dir = !dir;

  exp->expectfn = nf_nat_follow_master;

  TNS_PRINT ("exp->saved_proto.tcp.port: %u exp->tuple.src.u.tcp.port:
%u exp->tuple.dst.u.tcp.port: %u exp->dir: %u",
                 ntohs (exp->saved_proto.tcp.port),
                 ntohs (exp->tuple.src.u.tcp.port),
                 ntohs (exp->tuple.dst.u.tcp.port),
                 exp->dir);

  for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
    exp->tuple.dst.u.tcp.port = htons(port);
    TNS_PRINT ("tuple %p: %u " NIPQUAD_FMT ":%hu -> " NIPQUAD_FMT ":%hu",
		   &exp->tuple, exp->tuple.dst.protonum,
		   NIPQUAD(exp->tuple.src.u3.ip), ntohs(exp->tuple.src.u.all),
		   NIPQUAD(exp->tuple.dst.u3.ip), ntohs(exp->tuple.dst.u.all));

    if (0 == nf_ct_expect_related(exp)) {TNS_PRINT
("nf_ct_expect_related succ"); break;}
  }

  if (0 == port) return NF_DROP;

  if (!mangle_packet (skb, newip, port, matchoff, matchlen, ct, ctinfo)) {
    TNS_PRINT ("mangle packet failed, nf_ct_unexpect_related");
    nf_ct_unexpect_related(exp);
    return NF_DROP;
  }
  return NF_ACCEPT;
}

/* Return 1 for match, 0 for accept*/
static int find_pattern (const char *data, size_t dlen, struct
nf_conntrack_man *cmd, u_int * matchoff, u_int * matchlen)
{
  struct tnshdr_redirect * ptnshdr = (struct tnshdr_redirect*) data;
  int len = 0;
  int level = 1;
  __be16 port = 0;
  char * data_ptr = NULL;

  //check TNS TYPE
  if (NF_CT_TNS_REDIRECT != ptnshdr->tns_type) {
    TNS_PRINT ("current data is not tns packet");
    return (0);
  }

  *matchoff = 0;
  *matchlen = ntohs (ptnshdr->pkt_len);

  data_ptr =  (char*)data + dlen - 1;
  port = 0;
  for (len = 0; len < dlen; len++, data_ptr--) {
    if ('=' == *data_ptr) break;
    if (*data_ptr >= '0' && *data_ptr <= '9') {
      port = port + (*data_ptr -'0') * level;
      level *= 10;
    }
  }

  cmd->u.tcp.port = htons (port);

  TNS_PRINT ("ip = "NIPQUAD_FMT" port = %u", NIPQUAD(cmd->u3.ip), port);
  return ((0==port) ? 0 : 1);
}

static int help (struct sk_buff *skb,
		 unsigned int protoff,
		 struct nf_conn *ct,
		 enum ip_conntrack_info ctinfo)
{
  u_int dataoff = 0, datalen = 0;
  const struct tcphdr *th = NULL;
  struct tcphdr _tcph;
  const char *buf_ptr = NULL;
  int ret = NF_ACCEPT;
  int found = 0;
  struct nf_conntrack_expect * exp = NULL;
  u_int matchlen = 0, matchoff = 0;
  enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
  struct nf_conntrack_man cmd = {};
  union nf_inet_addr *daddr = NULL;

  if (ctinfo != IP_CT_ESTABLISHED && ctinfo !=
IP_CT_ESTABLISHED+IP_CT_IS_REPLY) {
    TNS_PRINT ("tns: Conntrackinfo = %u", ctinfo);
    return NF_ACCEPT;
  }

  th = skb_header_pointer(skb, protoff, sizeof(_tcph), &_tcph);
  if (th == NULL) return (NF_ACCEPT);

  dataoff = protoff + th->doff * 4;
  /* No data? */
  if (dataoff >= skb->len) {
    TNS_PRINT ("tns: dataoff(%u) >= skblen(%u)", dataoff, skb->len);
    return NF_ACCEPT;
  }
  datalen = skb->len - dataoff;

  spin_lock_bh (&nf_tns_lock);

  TNS_PRINT ("skb_headlen(skb)= %u offset: %u datalen: %u",
skb_headlen(skb), dataoff, datalen);
  buf_ptr = skb_header_pointer (skb, dataoff, datalen, tns_buffer);
  BUG_ON(buf_ptr == NULL);
  //tns_dump_block ("buf_ptr", (caddr_t)buf_ptr, datalen);
  //tns_dump_block ("tns_buffer", (caddr_t)tns_buffer, datalen);

  cmd.l3num = nf_ct_l3num(ct);
  memcpy (cmd.u3.all, &ct->tuplehash[dir].tuple.src.u3.all, sizeof(cmd.u3.all));

  found = find_pattern (buf_ptr, datalen, &cmd, &matchoff, &matchlen);

  /*no match */
  if (0 == found) {ret = NF_ACCEPT; TNS_PRINT ("unfound pattern"); goto out;}

  //proto: 2 192.168.100.100-> 192.168.100.103 port: 3747
  TNS_PRINT ("proto: %u " NIPQUAD_FMT "-> " NIPQUAD_FMT " port: %u",
		 nf_ct_l3num (ct),
		 NIPQUAD(ct->tuplehash[!dir].tuple.src.u3.ip),
		 NIPQUAD (ct->tuplehash[!dir].tuple.dst.u3.ip),
		 ntohs(cmd.u.tcp.port ));

  daddr = &ct->tuplehash[!dir].tuple.dst.u3;

  /* Update the tns info */
  if ((cmd.l3num == nf_ct_l3num(ct)) && memcmp(&cmd.u3.all,
&ct->tuplehash[dir].tuple.src.u3.all, sizeof(cmd.u3.all))) {
    if (cmd.l3num == PF_INET) {
      TNS_PRINT ("NOT RECORDING: " NIPQUAD_FMT " != " NIPQUAD_FMT,
		     NIPQUAD(cmd.u3.ip),
		     NIPQUAD(ct->tuplehash[dir].tuple.src.u3.ip));
    }
    TNS_PRINT ("update the tns info");
    daddr = &cmd.u3;
  }

#if 1
  exp = nf_ct_expect_alloc (ct);
  if (NULL == exp) {
    ret = NF_DROP;
    TNS_PRINT ("nf_ct_expect_alloc failed");
    goto out;
  }

  nf_ct_expect_init (exp, NF_CT_EXPECT_CLASS_DEFAULT, cmd.l3num,
		     &ct->tuplehash[!dir].tuple.src.u3, daddr,
		     IPPROTO_TCP, NULL, &cmd.u.tcp.port);

  if (ct->status & IPS_NAT_MASK) {
    TNS_PRINT ("match nat mask");
    ret = nf_nat_tns (skb, ctinfo, matchoff, matchlen, exp);
  } else {
    TNS_PRINT ("no nat");
    if (0 != nf_ct_expect_related (exp)) {
     ret = NF_DROP;
     TNS_PRINT ("nf_ct_expect_related failed");
    } else {
      ret = NF_ACCEPT;
     TNS_PRINT ("nf_ct_expect_related succ");
    }
  }

  nf_ct_expect_put (exp);
#endif
 out:
  spin_unlock_bh (&nf_tns_lock);
  return (ret);
}

static struct nf_conntrack_helper tns[MAX_PORTS] __read_mostly;
static char tns_names[MAX_PORTS][sizeof("tns-65535")] __read_mostly;

static const struct nf_conntrack_expect_policy tns_exp_policy = {
  .max_expected	= 1,
  .timeout	= 5 * 60,
};

/* don't make this __exit, since it's called from __init ! */
static void nf_conntrack_tns_fini(void)
{
  int i = 0;

  for (i = 0; i < ports_c; i++) {
    if (tns[i].me == NULL) continue;
    TNS_PRINT ("nf_ct_tns: unregistering helper for pf: %d port: %d",
tns[i].tuple.src.l3num, ports[i]);
    nf_conntrack_helper_unregister(&tns[i]);
  }

  if (NULL != tns_buffer) kfree(tns_buffer);
}

static int __init nf_conntrack_tns_init(void)
{
  int i = 0, ret = 0;
  char *tmpname;

  tns_buffer = kmalloc(65536, GFP_KERNEL);

  if (!tns_buffer) return -ENOMEM;

  if (ports_c == 0) ports[ports_c++] = TNS_PORT;

  for (i = 0; i < ports_c; i++) {
    tns[i].tuple.src.l3num = PF_INET;
    tns[i].tuple.src.u.tcp.port = htons(ports[i]);
    tns[i].tuple.dst.protonum = IPPROTO_TCP;
    tns[i].expect_policy = &tns_exp_policy;
    tns[i].me = THIS_MODULE;
    tns[i].help = help;
    tmpname = &tns_names[i][0];
    if (ports[i] == TNS_PORT)
      sprintf(tmpname, "tns");
    else
      sprintf(tmpname, "tns-%d", ports[i]);
    tns[i].name = tmpname;

    TNS_PRINT ("nf_ct_tns: registering helper for pf: %d port: %d",
tns[i].tuple.src.l3num, ports[i]);
    ret = nf_conntrack_helper_register(&tns[i]);
    if (ret) {
      TNS_PRINT ("nf_ct_tns: failed to register helper for pf: %d
port: %d", tns[i].tuple.src.l3num, ports[i]);
      nf_conntrack_tns_fini();
      return ret;
    }
  }

  return 0;
}

module_init(nf_conntrack_tns_init);
module_exit(nf_conntrack_tns_fini);

thanks,
Neco.F
