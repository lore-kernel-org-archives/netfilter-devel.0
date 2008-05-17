From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter moving to git
Date: Sat, 17 May 2008 09:59:13 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805170930120.15590@fbirervta.pbzchgretzou.qr>
References: <48299680.7020808@trash.net> <alpine.LNX.1.10.0805131614570.448@fbirervta.pbzchgretzou.qr> <4829A316.2080402@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57972 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbYEQH7O (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 May 2008 03:59:14 -0400
In-Reply-To: <4829A316.2080402@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-05-13 16:17, Patrick McHardy wrote:
>> 
>> All of that I have long done in my copy of the git repository,
>> announced already around mid-February. - git://dev.medozas.de/xtables
>> (Never mind the repository's name, it's the official SVN-top-off-the-head)
>
> Feel free to send me instructions for repeating these steps,
> but I certainly won't replace our repository by an external
> one.
>
diff -dpru <(git log --pretty="format:%T" origin/master) <(git log
--pretty="format:%T" xt/master)

Result:

--- /dev/fd/63  2008-05-17 09:30:26.625861648 +0200
+++ /dev/fd/62  2008-05-17 09:30:26.629859699 +0200
@@ -1,4 +1,3 @@
-7b98d6e3798565dec77aa46ceb4f11d17f791ef7
 0d663371e39a2e4a7290ec6c5b27aaa406a8751e
 6c5a04c5b09fa13303547fba07f726c953347173
 8ae6e4457a0d70a40b573b606488744a62a7a3bb

Which proves it is the same, tree-wise, minus the newest commit
that was done.
And the log difference you can see in
http://dev.medozas.de/files/.iptables-xtables.txt
I suggest you take a look.
