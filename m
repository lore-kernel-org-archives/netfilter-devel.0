From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter moving to git
Date: Tue, 13 May 2008 17:13:53 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805131620450.448@fbirervta.pbzchgretzou.qr>
References: <48299680.7020808@trash.net> <alpine.LNX.1.10.0805131614570.448@fbirervta.pbzchgretzou.qr> <4829A316.2080402@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37571 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbYEMPNy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2008 11:13:54 -0400
In-Reply-To: <4829A316.2080402@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-05-13 16:17, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> On Tuesday 2008-05-13 15:24, Patrick McHardy wrote:
>> 
>> > I've finally managed to complete the git setup on netfilter.org
>> > and created an iptables repository for testing.
>> >
>> > gitweb is running at git.netfilter.org (http and https), the
>> > git-daemon URL for the repositories is shown in gitweb.
>> >
>> > The repository might change in case we manage to import the missin
>> > branches and fix up the tags (they dates appear to be messed up for
>> > some reason), but please feel free to test already and let me know
>> > of any problems.
>> 
>> All of that I have long done in my copy of the git repository,
>> announced already around mid-February. - git://dev.medozas.de/xtables
>> (Never mind the repository's name, it's the official SVN-top-off-the-head)
>
> Feel free to send me instructions for repeating these steps,

while (!done && !looks_good) {
	git-filter-branch
}

Seriously, there is no automated way to properly populate the Author,
Committer, Date and Email fields, especially if the practice how it
is effectively stored in the logs has changed over time.
http://dev.medozas.de/files/iptables.aux/ is the base scripts
(running do_rewrite), plus hand fixups (do_rewrite2) where the
automated tools fail to catch every case.

> but I certainly won't replace our repository by an external one.

This is the one from Yasuyuki, kept in-sync with the SVN.

There is no difference in the blobs:
diff -dpru -x .svn -x .git iptables.svncheckout iptables.git;
(account for $Id$ expansion)

or the directory structure:
cd iptables.svncheckout/;
for i in `find [a-z]* -type d`; do
	diff -dpru <(git ls-tree HEAD $i/) \
		   <(cd ../xtables/; git ls-tree HEAD $i/);
done | less -S

Only changes so far are logs to fix obvious spelling mistakes or
metadata fixups (separation of author--committer), or 
perhaps just give a better message for the older commits like "argh".

[something like
	for ((n = 0; n < 1244; ++n); do
	diff -dpru <(cd iptables.gitified; git log HEAD~"$n"!) \
	<(cd xtables; git log HEAD~"$n"!)
	done;
should make it visible]

Fact is there has been going a lot of work into keeping it in 
git-style shape. It's alright if you do not trust it, but then
again, it would be a waste to run with a crippled-metadata repo
or to do the conversion again.
