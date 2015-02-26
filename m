From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] ct_sip_parse_numerical_param() error handling
Date: Thu, 26 Feb 2015 17:22:04 +0300
Message-ID: <20150226142204.GA14815@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18872 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbbBZOWZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Feb 2015 09:22:25 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Patrick McHardy,

The patch 2bbb21168a90: "[NETFILTER]: nf_conntrack_sip: introduce URI
and header parameter parsing helpers" from Mar 25, 2008, leads to the
following static checker warning:

	net/netfilter/nf_conntrack_sip.c:1230 process_register_request()
		warn: bool is not less than zero.

	net/netfilter/nf_conntrack_sip.c:1336 process_register_response()
		warn: bool is not less than zero.

The problem is ct_sip_parse_numerical_param() returns zero on failure
but two of the callers expect negative error codes.

net/netfilter/nf_conntrack_sip.c
  1307          if (ct_sip_get_header(ct, *dptr, 0, *datalen, SIP_HDR_EXPIRES,
  1308                                &matchoff, &matchlen) > 0)
  1309                  expires = simple_strtoul(*dptr + matchoff, NULL, 10);
                        ^^^^^^^
We set expires.

  1310  
  1311          while (1) {
  1312                  unsigned int c_expires = expires;
                                     ^^^^^^^^^^^^^^^^^^^^
and c_expires.

  1313  
  1314                  ret = ct_sip_parse_header_uri(ct, *dptr, &coff, *datalen,
  1315                                                SIP_HDR_CONTACT, &in_contact,
  1316                                                &matchoff, &matchlen,
  1317                                                &addr, &port);
  1318                  if (ret < 0) {
  1319                          nf_ct_helper_log(skb, ct, "cannot parse contact");
  1320                          return NF_DROP;
  1321                  } else if (ret == 0)
  1322                          break;
  1323  
  1324                  /* We don't support third-party registrations */
  1325                  if (!nf_inet_addr_cmp(&ct->tuplehash[dir].tuple.dst.u3, &addr))
  1326                          continue;
  1327  
  1328                  if (ct_sip_parse_transport(ct, *dptr, matchoff + matchlen,
  1329                                             *datalen, &proto) == 0)
  1330                          continue;
  1331  
  1332                  ret = ct_sip_parse_numerical_param(ct, *dptr,
  1333                                                     matchoff + matchlen,
  1334                                                     *datalen, "expires=",
  1335                                                     NULL, NULL, &c_expires);
                                                                        ^^^^^^^^^
  1336                  if (ret < 0) {
                            ^^^^^^^
"ret" is never negative.

  1337                          nf_ct_helper_log(skb, ct, "cannot parse expires");
  1338                          return NF_DROP;
  1339                  }
  1340                  if (c_expires == 0)
                            ^^^^^^^^^^^^^^
On the first error path in ct_sip_parse_numerical_param(), if
ct_sip_header_search() failes then we return the original c_expires.  On
the other error path we set it to zero.

  1341                          break;
  1342                  if (refresh_signalling_expectation(ct, &addr, proto, port,
  1343                                                     c_expires))
  1344                          return NF_ACCEPT;
  1345          }
  1346  

regards,
dan carpenter
