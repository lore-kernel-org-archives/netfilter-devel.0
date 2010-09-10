From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: VLAN ebtables target
Date: Fri, 10 Sep 2010 19:21:50 +0800
Message-ID: <AANLkTingKBq46n-tM-guNSwxDeaegSCfkW7KNYuiEMjb@mail.gmail.com>
References: <1284026558.2111.8.camel@nbmichele> <AANLkTinpMZyZgA5QZ8PezZv7r2iW1c6xPN7QcpxSzaqw@mail.gmail.com>
 <1284111698.3072.2.camel@nbmichele>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: michele.de_candia@alcatel-lucent.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:57503 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0IJLWL convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Sep 2010 07:22:11 -0400
Received: by wwi17 with SMTP id 17so49009wwi.1
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Sep 2010 04:22:10 -0700 (PDT)
In-Reply-To: <1284111698.3072.2.camel@nbmichele>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 10, 2010 at 5:41 PM, Michele Jr De Candia
<michele.de_candia@alcatel-lucent.com> wrote:
> On Fri, 2010-09-10 at 04:33 +0200, Changli Gao wrote:
>> On Thu, Sep 9, 2010 at 6:02 PM, Michele Jr De Candia
>> <michele.de_candia@alcatel-lucent.com> wrote:
>> > Hi all,
>> > I read on ebtable-devel mailing list that somebody has tried to do=
 a new
>> > target module to add or remove the VLAN tag with ebtables.
>> >
>> > There were some patches or references about previous developments?
>> >
>>
>> What is the requirement which needs this VLAN target? Most of
>> requirement can be satisfied =A0with ebtables and vlan network devic=
es.
>
> Supposing that the requirement is to get a VLAN tagged L2 frame comin=
g
> from an interface and routing it untagged to another interface, how
> would you do that?
>
>>

Supposing the VLAN tagged L2 frame conming from eth0, the VLAN ID is
2, and the other interface is eth1.

vconfig add eth0 2
vconfig set_flag eth0.2 1
brctl addbr br0
brctl addif br0 eth0.2
brctl addif br0 eth1

--=20
Regards,
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
