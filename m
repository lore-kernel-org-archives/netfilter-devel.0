From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] iptables: restore NOTRACK functionality, target
 aliasing
Date: Mon, 8 Oct 2012 14:02:23 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1210081253540.14822@nerf07.vanv.qr>
References: <alpine.LNX.2.01.1210080141140.2933@nerf07.vanv.qr> <1349656356-10180-1-git-send-email-jengelh@inai.de> <20121008083721.GA12128@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:48178 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab2JHMCY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2012 08:02:24 -0400
In-Reply-To: <20121008083721.GA12128@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2012-10-08 10:37, Pablo Neira Ayuso wrote:

>On Mon, Oct 08, 2012 at 02:32:36AM +0200, Jan Engelhardt wrote:
>> Commit v1.4.16-1-g2aaa7ec is testing for real_name (not) being NULL
>> which was always false (true). real_name was never NULL, so cs->jumpto
>> would always be used, which rendered -j NOTRACK unusable, since the
>> chosen real name.revision is for example NOTRACK.1, which does not exist
>> at the kernel side.
>> 
>> 	# ./iptables/xtables-multi main4 -t raw -A foo -j NOTRACK
>> 	dbg: Using NOTRACK.1
>> 	WARNING: The NOTRACK target is obsolete. Use CT instead.
>> 	iptables: Protocol wrong type for socket.
>> 
>> To reasonably support the extra-special verdict names, make it so that
>> real_name remains NULL when an extension defined no alias, which we can
>> then use to determine whether the user entered an alias name (which
>> needs to be followed) or not.
>
>I have applied this and made a new release.
>
>I kindly told you. I don't want late patches to hit iptables if I'm
>about to release it, ie. close to when the Linux kernel comes out.
>The reason was that chances to hit bugs and not noticing becomes
>higher. In other words, stick to conservative mode.

That is clear now, but was not when when the Alias Support patches
went in. Sorry for that.

As for the documentation updates ("doc:" labeled patches in
http://marc.info/?l=netfilter-devel&m=134903982604088&w=2 ), you gave
an OK, but then infuriated over them being merged, though
documentation generally does not cause bugs.


>
>Let this serve as proof of it.
>
>You disregarded my advice and now we have this shame, three releases
>in one day just because of rushing.

I will heed your words, but I do also think that letting patches sit
in git for longer may not necessarily buy more. For -j verdict,
maybe. But in general, iptables firewalling & networking users do not
use git so much, but they love tarballs, also because that gets
spread out by distros in a glimpse.

Here is an instance of iproute2 where an issue also only got noticed
after the tar got out:

http://archlinux.2023198.n4.nabble.com/ip-addr-show-doesn-t-show-my-ipv4-address-after-update-is-this-expected-behaviour-td4658792.html
http://forums.funtoo.org/viewtopic.php?id=1526
(this subsequently also got posted to netdev)

There is also that one NLM_F_MULTI issue in libnfnetlink, which
slept for 2 months in git before becoming a tar.


If, and only if, the "next" branch is empty (which was the case for
libnfnetlink), I do not think synchronization to the kernel release
schedule makes sense. But that is just my opinion..



Something completely different:

There seems to be something happening in your git cherry-pick process
causing the time to shift. Commit
ed03bc396b861ae0302b5cc9b3826cf58ef6aa24 from
git://git.inai.de/iptables has AuthorDate 2012-10-08 01:54:48+0200,
but commit dd43527cb6bdf3d469100850ca10dcd2fb761304 in iptables has
2012-10-07 14:32:36+0000. I am not sure if your clock is off, since
the CommitDate looks accurate.
