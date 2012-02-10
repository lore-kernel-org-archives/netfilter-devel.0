From: Jean-Philippe Menil <jean-philippe.menil@univ-nantes.fr>
Subject: Re: BUG nf_conntrack_ffff880863c50000: Objects remaining on kmem_cache_close()
Date: Fri, 10 Feb 2012 08:44:00 +0100
Message-ID: <4F34CAC0.7060800@univ-nantes.fr>
References: <4F328A81.4050607@univ-nantes.fr> <20120209155753.GB5951@1984> <4F33F03C.5030805@univ-nantes.fr> <20120209193917.GB6881@1984>
Reply-To: jean-philippe.menil@univ-nantes.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-tls2.univ-nantes.fr ([193.52.101.146]:59663 "EHLO
	smtp-tls.univ-nantes.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab2BJHoF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Feb 2012 02:44:05 -0500
In-Reply-To: <20120209193917.GB6881@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 09/02/2012 20:39, Pablo Neira Ayuso a =E9crit :
> On Thu, Feb 09, 2012 at 05:11:40PM +0100, Jean-Philippe Menil wrote:
>> Le 09/02/2012 16:57, Pablo Neira Ayuso a =E9crit :
>>> On Wed, Feb 08, 2012 at 03:45:21PM +0100, Jean-Philippe Menil wrote=
:
>>>> Hi,
>>>>
>>>> I'm seeing bug in a host with a 3.2.1 kernel.
>>>> This host is running both kvm and lxc guest.
>>>> It seems that it happened just after the restart of a lxc guest.
>>>>
>>>> However, it doesn't seem to affect any guest.
>>>>
>>>> I was just wondering if this was problematic, and if so, what shou=
ld
>>>> I do to debug this further.
>>> Could you provide more information on your setup? Is it using
>>> conntrackd or anything you think it can be relevant to this bug.
>>>
>>> It can make it easier for us to know what's wrong with this.
>>>
>> Hi,
>>
>> the server hosts two kvm guest (one firewall running contrackd, one
>> captive portal) and a lxc guest (running squid).
>> This setup remain unchanged for month, except the kernel (reboot
>> with a 3.2.1 one week ago).
> Is conntrackd running with NetlinkEventsReliable On?
Hi,

No, the NetlinkEventsReliable is commented in the configuration file.

However, on the same hosts, i see strange things:
ths host boot with the following parameter:
net.netfilter.nf_conntrack_max=3D262144
net.netfilter.nf_conntrack_tcp_timeout_established=3D10800

nf_conntrack is loaded with the following parameter:
options nf_conntrack hashsize=3D262144

But it seems that the nf_conntrack_max reset to his default value=20
(65536) periodically.
Three days ago, i manually increase the nf_conntrack_max to 262144,=20
yesterday i see plenty of "nf_conntrack: table full, dropping packet".
checking the value, is fall down to 65536.

It's maybe not related, but i can't understand how the value can change=
?

Regards.


--=20
Jean-Philippe Menil - P=F4le r=E9seau Service IRTS
DSI Universit=E9 de Nantes
jean-philippe.menil@univ-nantes.fr
Tel : 02.53.48.49.27 - Fax : 02.53.48.49.09

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
