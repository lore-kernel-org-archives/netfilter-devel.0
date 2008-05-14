From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter moving to git
Date: Wed, 14 May 2008 20:24:44 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805141935320.5292@fbirervta.pbzchgretzou.qr>
References: <48299680.7020808@trash.net> <alpine.LNX.1.10.0805131614570.448@fbirervta.pbzchgretzou.qr> <4829A316.2080402@trash.net> <alpine.LNX.1.10.0805131620450.448@fbirervta.pbzchgretzou.qr> <4829B177.9000501@trash.net> <alpine.LNX.1.10.0805131734130.448@fbirervta.pbzchgretzou.qr>
 <482B1335.30200@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Netfilter Core Team <coreteam@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54923 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbYENSYq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 May 2008 14:24:46 -0400
In-Reply-To: <482B1335.30200@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-05-14 18:28, Patrick McHardy wrote:
>> > And anyways, I also don't see anything wrong with simply starting with
>> > a clean history by only importing the latest version, In that case I'd
>> > have no problem using your fixed-up repository as historical reference.
>> >
>> I think this idea came up back in February already (starting from a
>> new slate), I am fine with that.
>> 
>> Though, what's wrong with stitching the first version of the
>> new repository to the last version of the old one?
>
> That would work, but Yasuyuki already provided me with the
> information for properly tagging the tree, so I'll keep the
> current iptables repository. Thanks anyway.

"The tags - they do nothing!"

There was confusion (in the git layer) how to handle the svn path
reordering that took place over time, which Yasuyuki did a great job
of clearing up. But making it a good git repository does not stop
after importing and, probably git-tagging the SVN branches^W tags^W
twigs. I mean hey, try to work with it like with the standards that
git and linux set, like

$ git shortlog v1.4.0..HEAD --
fatal: bad revision 'v1.4.0..HEAD'

Oh shoot, the tags are not the usual ones. Well, deducting a point
and continuing the quest:

$ git shortlog svn_t_iptables_1_4_0..HEAD --
fatal: bad revision 'svn_t_iptables_1_4_0..HEAD'

Eats, shoot again, and leaves. Giving in on another deducted point:

$ git shortlog svn_t_iptables_1_4_0rc1..HEAD -- | grep -v '^ '
/C=EU/ST=EU/CN=Pablo Neira Ayuso/... (4):
/C=EU/ST=EU/CN=Patrick McHardy/... (107):
/C=JP/ST=JP/CN=Yasuyuki Kozakai/... (29):

Hm yeah X.509, not exactly git but.. *sigh*. Even so, the
contributors should get their share in the release shortlog which,
ignoring that moving to git was just recent, would also happen too
seldom if things continue their way in that 6 month cycle.

$ git shortlog v1.4.0-rc1..HEAD | grep -v '^ ' | grep -v '^$' | wc -l
23

I am not saying you should take this repository, that is for you to
decide. Just whether I should continue on that official iptables or
not because obviously here is a difference in how to run things.
