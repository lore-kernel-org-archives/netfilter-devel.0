From: Andreas Schultz <aschultz@tpip.net>
Subject: nft: parser problem, can use mark as datatype in sets and maps
Date: Mon, 10 Aug 2015 15:48:12 +0200 (CEST)
Message-ID: <1027218717.2766569.1439214492178.JavaMail.zimbra@tpip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpip.net ([92.43.49.48]:53618 "EHLO mail.tpip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550AbbHJNsU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 09:48:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

The data type definition for mark and the general idea of the parser
indicate that the following nft statements should work:
 
  # nft add map filter MAP1 { type ipv4_addr : mark\; }
  # nft add set filter SET1 { type mark\; }

However, both fail with a similar error message:

  <cmdline>:1:40-43: Error: syntax error, unexpected mark, expecting string
  add map filter MAP1 { type ipv4_addr : mark; }
  <cmdline>:1:28-31: Error: syntax error, unexpected mark, expecting string
  add set filter SET1 { type mark; }

The problem is parser, it expects a string as data type spec, but
mark is already declared as a token.

I don't have much experience with bison, so does anyone have a quick
work-around for this?

Andreas
