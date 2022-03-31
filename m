Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE4AC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Mar 2022 10:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbiCaKGD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Mar 2022 06:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234469AbiCaKGD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Mar 2022 06:06:03 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E947AD5EA3
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2022 03:04:14 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nZrf2-00060H-H6; Thu, 31 Mar 2022 12:04:12 +0200
Date:   Thu, 31 Mar 2022 12:04:12 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 9/9] extensions: DNAT: Support service names in
 all spots
Message-ID: <YkV8nIURQHbWNJ4W@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220330155851.13249-1-phil@nwl.cc>
 <20220330155851.13249-10-phil@nwl.cc>
 <89qp85o0-704s-5280-sqp6-s71so14n7487@vanv.qr>
 <YkTEM8r6tv+fkOOK@orbyte.nwl.cc>
 <935op3q3-s38p-674r-1n2n-8spr98o7s37@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <935op3q3-s38p-674r-1n2n-8spr98o7s37@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 31, 2022 at 02:19:51AM +0200, Jan Engelhardt wrote:
> On Wednesday 2022-03-30 22:57, Phil Sutter wrote:
> >> >+-p tcp -j DNAT --to-destination 1.1.1.1:echo-ftp-data/ssh;-p tcp -j DNAT --to-destination 1.1.1.1:7-20/22;OK
> >> 
> >> This looks dangerous. It is why I originally never allowed service names in
> >> port ranges that use dash as the range character.
> >
> >Guess if someone is able to manipulate /etc/services, any service names
> >are problematic, not just in ranges.
> 
> Well, pretty much anyone has a shot at manipulating this file. File a
> port registration with IANA, and when your distro updates the file,
> eventually there is a chance of messing up firewall configs,
> worldwide.
> 
> Other than that, thanks to nsswitch, the service list can also be in
> LDAP or so, and then all that's needed is a disgruntled LDAP admin
> who dislikes the firewall admin.
> 
> >Another potential problem I didn't have in mind though is that 'a-b'
> >could mean [a; b] or [a-b] assuming that all three exist. But I haven't
> >found a valid example in my /etc/services, yet. :)
> 
> I found 25 at once!
> 
> 914c :: 914c-g :: g-talk
> ads :: ads-s :: s-openmail
> bctp :: bctp-server :: server-find
> cis :: cis-secure :: secure-mqtt
> connect :: connect-server :: server-find
> docker :: docker-s :: s-openmail
> documentum :: documentum-s :: s-openmail
> domain :: domain-s :: s-openmail
> dtp :: dtp-net :: net-device
> genie :: genie-lm :: lm-mon
> linktest :: linktest-s :: s-openmail
> mailbox :: mailbox-lm :: lm-mon
> mbap :: mbap-s :: s-openmail
> ns :: ns-server :: server-find
> plato :: plato-lm :: lm-mon
> rmonitor :: rmonitor-secure :: secure-mqtt
> sentinel :: sentinel-lm :: lm-mon
> sitewatch :: sitewatch-s :: s-openmail
> spss :: spss-lm :: lm-mon
> sql :: sql-net :: net-device
> tacacs :: tacacs-ds :: ds-slp
> tl1 :: tl1-lv :: lv-auth
> trim :: trim-ice :: ice-router
> wnn6 :: wnn6-ds :: ds-slp
> wsdapi :: wsdapi-s :: s-openmail

Your /etc/services seems to be much larger than mine, many of those
don't exist in my case.

> To be read as: "wsdapi-s-openmail" is ambiguous, because
> it allows for two interpretations (and all four port names are in
> /etc/services):
> 
> 	[wsdapi]-[s-openmail]
> 	[wsdapi-s]-[openmail]

OK. My code preferred the latter, checking if the former is possible is
a poor workaround. The only difference it makes is rules get rejected
instead of changing behaviour silently.

> >> The "solution" would be to use : as the range character, but that would require
> >> a new --dport option for reasons of command-line compatibility.
> >
> >Well, we could allow both (a-b with numeric a and b only) and use it in
> >output only if non-numeric was requested.
> 
> Given I'm seeing "914c" in the IANA list (leading digits always stand
> out from the crowd, e.g. you don't normally see them in UNIX
> usernames either), I won't hold my breath that no one would try to
> register "914-915".

That's an interesting point: "914c" is not usable in iptables. The code
tries strtoul which succeeds for "914", "c" is then rejected as illegal
remainder. To fix that, we had to consult getservbyname() first which is
a performance hit. Guess the whole "support users with bad number
memory" game is best effort, only.

I'll submit a v2 without the experimental "names in ranges" patch in a
minute.

Thanks, Phil
