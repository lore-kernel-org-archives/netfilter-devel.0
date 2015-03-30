From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH 2/3] src: add xt compat support
Date: Mon, 30 Mar 2015 12:19:29 +0200
Message-ID: <CAOkSjBiV4NXMx5FZz_82HhA+ZkSsCXZ1K3u47Uc77ikVkgcU6A@mail.gmail.com>
References: <20150325191556.13491.88761.stgit@nfdev2.cica.es>
 <20150325191602.13491.63370.stgit@nfdev2.cica.es> <20150325194441.GA26737@salvia>
 <CAOkSjBivwzs8X+y1PRqG8-hg4b-0QQ_NXfJ38YoT9V05vt7Bag@mail.gmail.com>
 <20150327123139.GA10614@salvia> <CAOkSjBivXDdt7S4=iPVJT0cubNFML2UeBgRQjecSr_XucDYDAg@mail.gmail.com>
 <20150327131354.GA11617@salvia> <20150327131411.GA3001@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:33736 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbbC3KTu convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Mar 2015 06:19:50 -0400
Received: by wgbgs4 with SMTP id gs4so77287703wgb.0
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2015 03:19:49 -0700 (PDT)
In-Reply-To: <20150327131411.GA3001@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27 March 2015 at 14:14, Patrick McHardy <kaber@trash.net> wrote:
> On 27.03, Pablo Neira Ayuso wrote:
>> On Fri, Mar 27, 2015 at 01:59:31PM +0100, Arturo Borrero Gonzalez wr=
ote:
>> > >> >> index 0000000..414f3d1
>> > >> >> --- /dev/null
>> > >> >> +++ b/include/xt.h
>> > >> >> @@ -0,0 +1,100 @@
>> > >> >> +#ifndef _NFT_XT_H_
>> > >> >> +#define _NFT_XT_H_
>> > >> >> +
>> > >> >> +#include <net/if.h>
>> > >> >> +
>> > >> >> +/* Fake ebt_entry */
>> > >> >> +struct ebt_entry {
>> > >> >
>> > >> > I think you can avoid this if you:
>> > >> >
>> > >> > #include <linux/netfilter_bridge/ebtables.h>
>> > >>
>> > >> Can't include <linux/netfilter_bridge/ebtables.h> because it in=
cludes
>> > >> <linux/if.h> and clash with <net/if.h>
>> > >
>> > > There must be a clean way to fix this without embedding the ebt_=
entry
>> > > structure.
>> >
>> > We seem to have the same problem in ebtables-compat:
>> >
>> > http://git.netfilter.org/iptables/tree/iptables/nft-bridge.h#n32
>>
>> Try to find a way to fix it there too ;-)
>
> Can't we switch to the linux includes? We're Linux only anyways :)

It doesn't seem to be that simple:
 * src/meta.c uses if_nametoindex() and if_indextoname() which are
defined in <net/if.h> and not in <linux/if.h>.
 * <xtables.h> uses <net/if.h> and replacing it leads to also touch
<include/libiptc/ipt_kernel_headers.h>

Should I workaround these two?

Could you please suggest any replacement for if_nametoindex() and
if_indextoname()?

regards

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
