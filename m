From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: Removing a REDIRECT rule not working
Date: Fri, 19 Dec 2014 13:50:52 +0100
Message-ID: <m716vc$t0t$1@ger.gmane.org>
References: <m713rl$dau$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58693 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbaLSMvJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Dec 2014 07:51:09 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1Y1x1Q-0004l1-Hh
	for netfilter-devel@vger.kernel.org; Fri, 19 Dec 2014 13:51:08 +0100
Received: from ip4d14db36.dynamic.kabel-deutschland.de ([77.20.219.54])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Dec 2014 13:51:08 +0100
Received: from for-gmane by ip4d14db36.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Dec 2014 13:51:08 +0100
In-Reply-To: <m713rl$dau$1@ger.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Oops, sorry my bad: there was unfortunately a misconfiguration in my router... :-(


U.Mutlu wrote, On 12/19/2014 12:57 PM:
> I think I found a bug in iptables:
>
> If applying such a rule:
>
>   iptables -t nat -A PREROUTING -p tcp --dport 1234 -j REDIRECT --to-port 5678
>
> then testing it at least once by putting a server-app at port 5678,
> and then throwing this rule away by clearing (flushing) alle the tables
> doesn't get this rule disappear anymore; it somehow is still active,
> because the REDIRection still works even after clearing the tables.
>
> (Haven't checked yet if after a reboot of the system the problem disappears,
> but even then this of course wouldn't be a satifactory solution to the problem.)
>
> My system: debian 8 (jessie), iptables from the beforementioned repo, version
> v1.4.21
>
>
> Another related issue:
>
> The following documentation says that the above rule would be a "transparent
> proxy":
>   http://www.tldp.org/HOWTO/TransparentProxy-5.html
> But this can't be true, because it's NAT (s.a.); whereas from a
> transparent proxy one would expect that the originating IP gets
> passed thru to the redirected port, which is not the case here;
> only the NATted IP gets passed...
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


