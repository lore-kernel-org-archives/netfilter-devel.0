From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2 1/3] iptables: change 'iface' part in hash:net,iface
 set
Date: Fri, 13 Jul 2012 10:11:34 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207131003540.31126@blackhole.kfki.hu>
References: <cover.1341871199.git.mr.dash.four@googlemail.com> <09f86300bb1913aa4c6063618fbbcd84fac2e608.1341871200.git.mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207101735540.24998@blackhole.kfki.hu> <4FFCBDAD.5010206@googlemail.com>
 <alpine.DEB.2.00.1207112119460.26540@blackhole.kfki.hu> <4FFF6EC8.60300@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:58637 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab2GMILf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jul 2012 04:11:35 -0400
In-Reply-To: <4FFF6EC8.60300@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 13 Jul 2012, Mr Dash Four wrote:

> > These functions are static. Nothing else uses them.
> >   
> OK, that's good because I intend to change the parse_dirs function in 
> the new "version" and introduce additional parameter called "features" 
> so that these are used directly and not rely on the info->flags to store 
> these (as was the case up until now). That would also allow for 
> additional features to be added in the future, if needed (u8 is almost 
> exhausted - you have one spare bit left there!).

The almost exhausted u8 is an additional reason why it's better to use 
unsigned int in the *protocol* between the kernel-userspace 
(struct ip_set_req_get_features).
 
> > At the moment, the enum ip_set_feature definition is kernel specific 
> > in the kernel header file. Next time Pablo regenerates the header 
> > files for iptables from the kernel ones, your modification above will 
> > be lost. Therefore the enum definition must be moved out from the 
> > "#ifdef __KERNEL__" region in the kernel header file.
> >   
> Yep, just saw that too, so I'll just move the ip_set_feature enum just 
> above the #ifdef __KERNEL__ part and I assume it would be picked up 
> "automatically", is that right?

No, let the patchset be complete in itself, i.e. include the patches both 
for the kernel and iptables header files.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
