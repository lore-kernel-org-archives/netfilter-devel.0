From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Ulogd2 beta3 +NFCT - unable to get working
Date: Wed, 24 Jun 2009 20:06:07 +0200
Message-ID: <4A426B0F.3070309@netfilter.org>
References: <c4b050a10906231656u53e20855ud5cf5833ca5db7cc@mail.gmail.com> <4A426A1C.6050003@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Anton VG <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39345 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbZFXSGO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:06:14 -0400
In-Reply-To: <4A426A1C.6050003@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Anton VG wrote:
>> Hello!
>>
>> Just spent all night trying to get the %SUBJ% working, but been
>> unable. There is no any other example in whole internet other than
>> included into a package and
>> http://software.inl.fr/trac/wiki/ulogd2/user
>>
>> Ulogd starts, and tells that everything initialized - but
>> /var/log/ulogd_syslogemu.log - is always 0 bytes - no logging there.
> 
> Is nf_conntrack_netlink loaded?
> 
> I still have to send a patch to autoload to the kernel to add support
> for this autoload.

Hm, I should read what I write before pushing "send" :-). I meant that,
for event listening, there's no autoload of the "nf_conntrack_netlink"
module yet. What you're reporting seems like a sympthon that this module
is missing.
