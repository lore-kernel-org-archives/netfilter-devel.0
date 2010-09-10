From: Michele Jr De Candia <michele.de_candia@alcatel-lucent.com>
Subject: Re: VLAN ebtables target
Date: Fri, 10 Sep 2010 13:30:56 +0200
Message-ID: <1284118256.3072.7.camel@nbmichele>
References: <1284026558.2111.8.camel@nbmichele>
	 <AANLkTinpMZyZgA5QZ8PezZv7r2iW1c6xPN7QcpxSzaqw@mail.gmail.com>
	 <1284111698.3072.2.camel@nbmichele>
	 <AANLkTingKBq46n-tM-guNSwxDeaegSCfkW7KNYuiEMjb@mail.gmail.com>
Reply-To: michele.de_candia@alcatel-lucent.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smail2.alcatel.fr ([64.208.49.57]:51726 "EHLO smail2.alcatel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab0IJLbN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Sep 2010 07:31:13 -0400
In-Reply-To: <AANLkTingKBq46n-tM-guNSwxDeaegSCfkW7KNYuiEMjb@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2010-09-10 at 13:21 +0200, Changli Gao wrote:
> On Fri, Sep 10, 2010 at 5:41 PM, Michele Jr De Candia
> <michele.de_candia@alcatel-lucent.com> wrote:
> > On Fri, 2010-09-10 at 04:33 +0200, Changli Gao wrote:
> >> On Thu, Sep 9, 2010 at 6:02 PM, Michele Jr De Candia
> >> <michele.de_candia@alcatel-lucent.com> wrote:
> >> > Hi all,
> >> > I read on ebtable-devel mailing list that somebody has tried to do a new
> >> > target module to add or remove the VLAN tag with ebtables.
> >> >
> >> > There were some patches or references about previous developments?
> >> >
> >>
> >> What is the requirement which needs this VLAN target? Most of
> >> requirement can be satisfied  with ebtables and vlan network devices.
> >
> > Supposing that the requirement is to get a VLAN tagged L2 frame coming
> > from an interface and routing it untagged to another interface, how
> > would you do that?
> >
> >>
> 
> Supposing the VLAN tagged L2 frame conming from eth0, the VLAN ID is
> 2, and the other interface is eth1.
> 
> vconfig add eth0 2
> vconfig set_flag eth0.2 1
> brctl addbr br0
> brctl addif br0 eth0.2
> brctl addif br0 eth1
> 

Thank you but I think this untags all the frames coming to eth0.2.

If I want to untag some frames according to some rule (e.g. src or dst
mac address) this can't be the way, right? 



