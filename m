From: =?UTF-8?B?0K7RgNC40Lkg0J/Rg9GF0LDQu9GM0YHQutC40Lk=?=
	<aikipooh@gmail.com>
Subject: Strange behaviour when adding rules with libiptc
Date: Mon, 23 Mar 2015 02:49:51 +0300
Message-ID: <CAKws=GSkHr7JN-aSfpU0fR2npAujz+7kxhUrCfmLoqtsGm03fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:33852 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbbCVXtv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Mar 2015 19:49:51 -0400
Received: by oier21 with SMTP id r21so128435747oie.1
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Mar 2015 16:49:51 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Good UTC night everyone!

I use libiptc (iptables-1.4.21-r1) to manage the iptables rules that
use my custom module. The module (after starvation) looks like:

#include <linux/module.h>
#include <linux/netfilter/x_tables.h>

struct xt_FAN_info {
  __u32 par;
};

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Yury A. Pukhalsky <aikipooh@gmail.com>");
MODULE_DESCRIPTION("None");
MODULE_ALIAS("ipt_FAN");

static int
fan_tg_check( const struct xt_tgchk_param *par )
{
  struct xt_FAN_info *einfo = par->targinfo;

  pr_notice( "FAN check: par=%d\n", einfo->par );

  return 0;
}

static void
fan_tg_destroy( const struct xt_tgdtor_param *par )
{
  struct xt_FAN_info *einfo = par->targinfo;

  pr_notice( "Destroying par=%d\n", einfo->par );
}

static struct xt_target fan_tg_reg __read_mostly = {
  .name = "FAN",
  .family = NFPROTO_UNSPEC,
  .targetsize = sizeof(struct xt_FAN_info),
  .table = "mangle",
  .checkentry = fan_tg_check,
  .destroy = fan_tg_destroy,
  .me = THIS_MODULE,
};

static int __init fan_tg_init(void)
{
  pr_notice("FAN init\n" );

  return xt_register_target( &fan_tg_reg );
}

static void __exit fan_tg_exit(void)
{
  pr_notice("FAN exit\n" );

  xt_unregister_target( &fan_tg_reg );
}

module_init( fan_tg_init );
module_exit( fan_tg_exit );

The control program that adds the rule (takes a parameter that the
module outputs) is this:

#include <libiptc/libiptc.h>
#include <errno.h>

struct xt_FAN_info {
  __u32 srv_addr;
};

typedef struct {
    struct ipt_entry e;
    struct xt_entry_match m;
    struct xt_tcp mtcp;
    struct xt_entry_target t;
    struct xt_FAN_info d;
} rule_t;

int main( int argc, char **argv )
{
  if( argc != 2 ) return 1;

  struct xtc_handle *h = iptc_init( "mangle" );

  if(!h) {
    printf("%s\n", iptc_strerror(errno));
    exit(1);
  }

  rule_t rule = {
    .e = {
      .ip.proto = IPPROTO_TCP,
      .ip.src.s_addr=inet_addr("10.214.217.48"),
      .ip.smsk.s_addr = htonl(0xffffffff)
    },
    .m.u.user.name = "tcp",
    .m.u.user.match_size = XT_ALIGN( sizeof( struct xt_entry_match ) +
sizeof( struct xt_tcp ) ),
    .mtcp = { .spts = {1023, 60535}, .dpts = {80,80} },
    .t.u.user.name = "FAN",
    .t.u.user.target_size = XT_ALIGN( sizeof( struct xt_entry_target ) +
      sizeof( struct xt_FAN_info ) ),
    .d = { atoi(argv[1]) }
  };
  rule.e.target_offset = sizeof(struct ipt_entry)
    + sizeof( struct xt_entry_match ) + sizeof( struct xt_tcp );
  rule.e.next_offset = XT_ALIGN( rule.e.target_offset +
 rule.t.u.user.target_size );

  if( !iptc_append_entry( "OUTPUT", (struct ipt_entry *) &rule, h) ) {
    printf("append: %s\n", iptc_strerror(errno));
    exit(1);
  }

  if( !iptc_commit( h ) ) {
    printf("commit: %s\n", iptc_strerror(errno));
    exit(1);
  }
  iptc_free( h );

  return 0;
}

I call this program several times, adding rules one by one:
localhost debug_mnl # ./control 1
localhost debug_mnl # ./control 2
localhost debug_mnl # ./control 3
localhost debug_mnl # ./control 4

And in the end I have 4 rules, as intended:
FAN        tcp  --  10.214.217.48        0.0.0.0/0            tcp
spts:1023:60535 dpt:80[8 bytes of unknown target data]
FAN        tcp  --  10.214.217.48        0.0.0.0/0            tcp
spts:1023:60535 dpt:80[8 bytes of unknown target data]
FAN        tcp  --  10.214.217.48        0.0.0.0/0            tcp
spts:1023:60535 dpt:80[8 bytes of unknown target data]
FAN        tcp  --  10.214.217.48        0.0.0.0/0            tcp
spts:1023:60535 dpt:80[8 bytes of unknown target data]

Yes the output of the kernel module looks funny:
Mar 23 02:43:07 localhost kernel: [ 3326.340475] FAN init
Mar 23 02:43:07 localhost kernel: [ 3326.342503] FAN check: par=1

Mar 23 02:43:12 localhost kernel: [ 3331.946819] FAN check: par=1
Mar 23 02:43:12 localhost kernel: [ 3331.946844] FAN check: par=2
Mar 23 02:43:12 localhost kernel: [ 3331.946893] Destroying par=1

Mar 23 02:43:21 localhost kernel: [ 3340.643805] FAN check: par=1
Mar 23 02:43:21 localhost kernel: [ 3340.643828] FAN check: par=2
Mar 23 02:43:21 localhost kernel: [ 3340.643836] FAN check: par=3
Mar 23 02:43:21 localhost kernel: [ 3340.643883] Destroying par=1
Mar 23 02:43:21 localhost kernel: [ 3340.643889] Destroying par=2

Mar 23 02:43:25 localhost kernel: [ 3344.424060] FAN check: par=1
Mar 23 02:43:25 localhost kernel: [ 3344.424084] FAN check: par=2
Mar 23 02:43:25 localhost kernel: [ 3344.424091] FAN check: par=3
Mar 23 02:43:25 localhost kernel: [ 3344.424098] FAN check: par=4
Mar 23 02:43:25 localhost kernel: [ 3344.424144] Destroying par=1
Mar 23 02:43:25 localhost kernel: [ 3344.424150] Destroying par=2
Mar 23 02:43:25 localhost kernel: [ 3344.424155] Destroying par=3

I think something's not cleaned up there.

-- 
Point of presence: http://vk.com/aikipooh
