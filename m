From: Anton VG <anton.vazir@gmail.com>
Subject: Re: Ulogd2 beta3 +NFCT - unable to get working
Date: Thu, 25 Jun 2009 01:54:36 +0500
Message-ID: <c4b050a10906241354w648ffffo50bfa0305f08bee5@mail.gmail.com>
References: <c4b050a10906231656u53e20855ud5cf5833ca5db7cc@mail.gmail.com>
	 <4A426A1C.6050003@netfilter.org> <4A426B0F.3070309@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:56972 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbZFXUye convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:54:34 -0400
Received: by ewy6 with SMTP id 6so1608518ewy.37
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2009 13:54:36 -0700 (PDT)
In-Reply-To: <4A426B0F.3070309@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yes, it's loaded, here is the list of loaded modules.

# lsmod|grep nf
nf_conntrack_netlink    17040  0
nfnetlink_log           9396  1 xt_NFLOG
nfnetlink               5176  5 nf_conntrack_netlink,nfnetlink_log
nf_nat                 19876  1 iptable_nat
nf_conntrack_ipv4      14472  7 iptable_nat,nf_nat
nf_defrag_ipv4          2240  1 nf_conntrack_ipv4
nf_conntrack           70624  7
xt_connbytes,nf_conntrack_netlink,xt_conntrack,iptable_nat,nf_nat,nf_co=
nntrack_ipv4,sch_esfq
#

But I suppose it would not log any connections in case it's not? But
it does some, but in unpredictable manner.


2009/6/24 Pablo Neira Ayuso <pablo@netfilter.org>:
> Pablo Neira Ayuso wrote:
>> Anton VG wrote:
>>> Hello!
>>>
>>> Just spent all night trying to get the %SUBJ% working, but been
>>> unable. There is no any other example in whole internet other than
>>> included into a package and
>>> http://software.inl.fr/trac/wiki/ulogd2/user
>>>
>>> Ulogd starts, and tells that everything initialized - but
>>> /var/log/ulogd_syslogemu.log - is always 0 bytes - no logging there=
=2E
>>
>> Is nf_conntrack_netlink loaded?
>>
>> I still have to send a patch to autoload to the kernel to add suppor=
t
>> for this autoload.
>
> Hm, I should read what I write before pushing "send" :-). I meant tha=
t,
> for event listening, there's no autoload of the "nf_conntrack_netlink=
"
> module yet. What you're reporting seems like a sympthon that this mod=
ule
> is missing.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
