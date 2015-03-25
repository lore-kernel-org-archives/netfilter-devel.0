From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [PATCH V2] ipvs: disable inline net_ipvs function with
 CONFIG_IP_VS not being set
Date: Wed, 25 Mar 2015 21:15:37 +0100
Message-ID: <CACna6rx88PSANYixdj8Fwdg57j997z9Cft-mx_72tCOJ0Rk5tw@mail.gmail.com>
References: <1427273637-29151-1-git-send-email-zajec5@gmail.com>
	<1427275043-1192-1-git-send-email-zajec5@gmail.com>
	<alpine.LFD.2.11.1503252148420.1795@ja.home.ssi.bg>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Simon Horman <horms@verge.net.au>
To: Julian Anastasov <ja@ssi.bg>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:35262 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbbCYUPh convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 16:15:37 -0400
Received: by ieclw3 with SMTP id lw3so31239425iec.2
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Mar 2015 13:15:37 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.11.1503252148420.1795@ja.home.ssi.bg>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25 March 2015 at 21:04, Julian Anastasov <ja@ssi.bg> wrote:
>
>         Hello,
>
> On Wed, 25 Mar 2015, Rafa=C5=82 Mi=C5=82ecki wrote:
>
>> Including net/ip_vs.h without CONFIG_IP_VS was causing:
>> include/net/ip_vs.h: In function 'net_ipvs':
>> include/net/ip_vs.h:35:12: error: 'struct net' has no member named '=
ipvs'
>>
>> Fixes: 8b4d14d8eb368 ("netns: exclude ipvs from struct net when IPVS=
 disabled")
>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
>> ---
>> V2: Disable function totally instead of returning NULL.
>
>         While this version is better, the commit message
> looks scary, it should explain that problem happens only
> for modules out of kernel tree, we do not want other admins
> to wonder whether they need this commit for their trees.

OK, I just need some decision if you want/need this patch at all and
if I should send another version.


>         And of course, it is better to implement your
> own ip_vs_check_diff4 version, it is some inline stuff...

I did.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
