From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter moving to git
Date: Tue, 13 May 2008 17:19:19 +0200
Message-ID: <4829B177.9000501@trash.net>
References: <48299680.7020808@trash.net> <alpine.LNX.1.10.0805131614570.448@fbirervta.pbzchgretzou.qr> <4829A316.2080402@trash.net> <alpine.LNX.1.10.0805131620450.448@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Netfilter Core Team <coreteam@netfilter.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46265 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635AbYEMPT7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2008 11:19:59 -0400
In-Reply-To: <alpine.LNX.1.10.0805131620450.448@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2008-05-13 16:17, Patrick McHardy wrote:
>>>
>>> All of that I have long done in my copy of the git repository,
>>> announced already around mid-February. - git://dev.medozas.de/xtables
>>> (Never mind the repository's name, it's the official SVN-top-off-the-head)
 >>
>> Feel free to send me instructions for repeating these steps,
> 
> while (!done && !looks_good) {
> 	git-filter-branch
> }
> 
> Seriously, there is no automated way to properly populate the Author,
> Committer, Date and Email fields, especially if the practice how it
> is effectively stored in the logs has changed over time.
> http://dev.medozas.de/files/iptables.aux/ is the base scripts
> (running do_rewrite), plus hand fixups (do_rewrite2) where the
> automated tools fail to catch every case.

I don't think its particulary important to fix up the commiter
names (and strip the certificate-mess), it you really need to
know, its easy to find out.

>> but I certainly won't replace our repository by an external one.
> 
> This is the one from Yasuyuki, kept in-sync with the SVN.
> 
> There is no difference in the blobs:
> diff -dpru -x .svn -x .git iptables.svncheckout iptables.git;
> (account for $Id$ expansion)
> 
> or the directory structure:
> cd iptables.svncheckout/;
> for i in `find [a-z]* -type d`; do
> 	diff -dpru <(git ls-tree HEAD $i/) \
> 		   <(cd ../xtables/; git ls-tree HEAD $i/);
> done | less -S

I took the last one from Yasuyuki and resynced it, might have
missed a more current version though.

> Only changes so far are logs to fix obvious spelling mistakes or
> metadata fixups (separation of author--committer), or 
> perhaps just give a better message for the older commits like "argh".
> 
> [something like
> 	for ((n = 0; n < 1244; ++n); do
> 	diff -dpru <(cd iptables.gitified; git log HEAD~"$n"!) \
> 	<(cd xtables; git log HEAD~"$n"!)
> 	done;
> should make it visible]
> 
> Fact is there has been going a lot of work into keeping it in 
> git-style shape. It's alright if you do not trust it, but then
> again, it would be a waste to run with a crippled-metadata repo
> or to do the conversion again.

True, but as a matter of principle, I can't use an untrusted repository.

And anyways, I also don't see anything wrong with simply starting with
a clean history by only importing the latest version, In that case I'd
have no problem using your fixed-up repository as historical reference.

