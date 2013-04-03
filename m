From: holger@eitzenberger.org
Subject: [PATCH RFC 0/2] icmpv6: match any ICMPv6 error/informational type
Date: Wed, 03 Apr 2013 16:27:29 +0200
Message-ID: <20130403142729.484857089@eitzenberger.org>
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:51650 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760323Ab3DCOms (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:42:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

for streamlining our ip6tables ruleset it would be helpfull to match
on *any* ICMPv6 informational type.  If not being able to specify any
informational type it would be required to specify the most common
types excplicitely, with as many rules as types.  And then with the
risk of missing some of them.

Therefore the attached two patches implement the ability to match on
any ICMPv6 informational (--icmpv6-info) or error (--icmpv6-error)
type.

I made the options --icmpv6-type, --icmpv6-error and --icmpv6-info
mutually exclusive.

These are the points I'd like your comment specifically:

1. I tried not to introduce a new revision by reusing the
  icmpv6_icmp.invflags for the new flags.

2. I think I can even rename icmpv6_icmp.invflags to icmpv6_icmp.flags
  because the ABI still being the same.  I did this because the name
  'invflags' being slightly misleading otherwise.

3. the F_* flags in the iptables extensions are the same values as
   the IP6T_ICMP_* values.  Should I use the IP6T_ICMP_* values
   in the extension?

Or add a new revision instead?

Please comment.

Thank you.

 /Holger

