From: Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC 0/3] netfilter reverse path filter matches
Date: Fri, 26 Aug 2011 11:21:02 +0200
Message-ID: <1314350465-19598-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:33898 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753748Ab1HZJKi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:10:38 -0400
Received: id: fw by Chamillionaire.breakpoint.cc authenticated by fw with local
	(easymta 1.00 BETA 1)
	id 1QwsQv-0005mv-Bg
	for netfilter-devel@vger.kernel.org; Fri, 26 Aug 2011 11:10:37 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Here are the ipv4/ipv6 reverse path filter matches that
were discussed briefly at the workshop.

These are not ready for merging at this time, but I think
sending current status is helpful in moving things forward.

There are 3 matches:
xt_rpfilter, ipt_rpfilter, ip6t_rpfilter.

Obviously, it will be either xt_rpfilter or the latter two.
At the moment, xt_rpfilter has too many issues: it does not behave
the same as current ip4-builtin rp_filter, because output route resolution
is used for validation.
Depending on the routes this may result in different route lookup results
than what a real reply packet would see.

It also breaks with ipv4 multipath setups when there are several matching
routes.
As ipv4 and ipv6 need different treatment anyway, using different modules
does not seem to be a problem. (This also avoids extra module dependency
issues)

The ipv4-only match (ipt_rpfilter) tries to do exactly what the current
fib_validate_source does.  Known remaining Problems are:

- additional fib lookup to get oif (will be used in reverse lookup as iif)
- using match in PREROUTING may do the wrong thing when
  policy routing is used via mangle PREROUTING (we may perform
  fib lookup with wrong nfmark)
- using it in FORWARD is problematic because stack could send out
  icmp errors (ttl exceeded, PMTU, ...) before the packet would
  have been rpf-tested.

We seemed to have consesus on the following:
- no special treatment of ipsec-protected packets (users can use policy match)
- packets from IFF_LOOPBACK should always match
- result caching can be implemented later on, if needed.

Userspace part is stored in my iptables repository on
http://git.breakpoint.cc/cgi-bin/gitweb.cgi?p=fw/iptables.git (branch 'rpfilter').

Kernel patches are located in the 'xt_rpfilter' branch on
http://git.breakpoint.cc/cgi-bin/gitweb.cgi?p=fw/nf-next.git (i'll send the relevant patches
as followup to this email).

Please let me know if I forgot any remaing issues, or if you spot any
additional issues that have not been raised so far.

Thanks,
Florian
