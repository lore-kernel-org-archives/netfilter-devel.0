From: Jamie Strandboge <jamie@strandboge.com>
Subject: [PATCH] ip6tables formatting problem
Date: Tue, 5 Feb 2008 19:51:32 -0500
Message-ID: <20080206005132.GD7357@lupin.strandboge.com>
Reply-To: Jamie Strandboge <jamie@strandboge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.strandboge.com ([74.41.70.118]:60881 "EHLO
	tonks.strandboge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbYBFA6P (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Feb 2008 19:58:15 -0500
Received: from lupin.strandboge.com (lupin.strandboge.com [192.168.2.9])
	by tonks.strandboge.com (Postfix) with ESMTP id 541A94C421A
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Feb 2008 19:51:31 -0500 (EST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am sending this here as bugzilla.netfilter.org is down. I am not
subscribed to the list, so please CC me on replies.

ip6tables improperly displays the destination address when the address
is longer than 18 characters.  Here is example output:
# ip6tables -L -n
...
DROP       tcp      2001:db8::/32        2001:db8:3:4:5:6:7:8/128tcp spt:25
...

Proper formatting should have a space between '2001:db8:3:4:5:6:7:8/128'
and 'tcp'.

Here is a patch to do just that:
--- iptables-1.3.8.0debian1.orig/iptables/ip6tables.c
+++ iptables-1.3.8.0debian1/iptables/ip6tables.c
@@ -1427,14 +1427,14 @@
        fputc(fw->ipv6.invflags & IP6T_INV_DSTIP ? '!' : ' ', stdout);
        if (!memcmp(&fw->ipv6.dmsk, &in6addr_any, sizeof in6addr_any)
            && !(format & FMT_NUMERIC))
-               printf(FMT("%-19s","-> %s"), "anywhere");
+               printf(FMT("%-19s ","-> %s"), "anywhere");
        else {
                if (format & FMT_NUMERIC)
                        sprintf(buf, "%s", addr_to_numeric(&(fw->ipv6.dst)));
                else
                        sprintf(buf, "%s", addr_to_anyname(&(fw->ipv6.dst)));
                strcat(buf, mask_to_numeric(&(fw->ipv6.dmsk)));
-               printf(FMT("%-19s","-> %s"), buf);
+               printf(FMT("%-19s ","-> %s"), buf);
        }

        if (format & FMT_NOTABLE)

Jamie Strandboge

--
Email: jamie@strandboge.com
IRC:   jdstrand

