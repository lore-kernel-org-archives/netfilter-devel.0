From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnftnl 1.0.9 release
Date: Tue, 2 Jan 2018 21:07:09 +0100
Message-ID: <20180102200709.4tcdxcmuc5miach6@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="r6unvjeh4klmcx6y"
Cc: netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--r6unvjeh4klmcx6y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnftnl 1.0.9

libnftnl is a userspace library providing a low-level netlink
programming interface (API) to the in-kernel nf_tables subsystem. The
library libnftnl has been previously known as libnftables. This library
is currently used by the nft command line tool.

This release includes mostly bug fixes plus one new
nftnl_expr_fprintf() function.

You can download this library from:

http://www.netfilter.org/projects/libnftnl/downloads.html
ftp://ftp.netfilter.org/pub/libnftnl/

Thanks!

--r6unvjeh4klmcx6y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-libnftnl-1.0.9.txt"

Armin K (1):
      src: Fix exporting symbols with clang

Harsha Sharma (1):
      tests: change char * pointer to constant (const char *)

Pablo Neira Ayuso (2):
      data_reg: calm down compilation warning in nftnl_data_reg_value_json_parse()
      build: libnftnl 1.0.9 release

Phil Sutter (7):
      expr: Introduce nftnl_expr_fprintf()
      data_reg: Add a missing break in nftnl_data_reg_snprintf
      gen: Remove a pointless call to mnl_nlmsg_get_payload()
      object: Avoid returning garbage in nftnl_obj_do_parse()
      ruleset: Avoid reading garbage in nftnl_ruleset_cb()
      set_elem: Don't return garbage in nftnl_set_elems_parse()
      trace: Check return value of mnl_attr_parse_nested()


--r6unvjeh4klmcx6y--
