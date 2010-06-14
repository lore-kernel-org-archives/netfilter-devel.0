From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables-addons build fails
Date: Tue, 15 Jun 2010 01:09:46 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1006150107220.14214@obet.zrqbmnf.qr>
References: <4C16A109.7050404@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: martinbarrowcliff <martinbarrowcliff@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43172 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab0FNXJr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jun 2010 19:09:47 -0400
In-Reply-To: <4C16A109.7050404@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-06-14 23:37, martinbarrowcliff wrote:

> BTW, must mention, latest lzma says the 1.27.xz file
> on sourceforge is corrupt. I used the git source instead.
> Still failed.

--2010-06-15 01:06:15--  http://sunet.dl.sourceforge.net/project/xtables-addons/Xtables-addons/1.27/xtables-addons-1.27.tar.xz
Resolving sunet.dl.sourceforge.net... 194.71.11.73
Connecting to sunet.dl.sourceforge.net|194.71.11.73|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 331224 (323K) [application/x-tar]
Saving to: `xtables-addons-1.27.tar.xz'

100%[======================================>] 331,224     7.60K/s   in 31s     

--2010-06-15 01:07:34--  http://heanet.dl.sourceforge.net/project/xtables-addons/Xtables-addons/1.27/xtables-addons-1.27.tar.xz.asc
Resolving heanet.dl.sourceforge.net... *a193.1.193.66, 2001:770:18:aa40::c101:c142
Connecting to heanet.dl.sourceforge.net|193.1.193.66|:80... sconnected.
HTTP request sent, awaiting response... c 200 OK
Length: 198 [text/plain]
Saving to: `xtables-addons-1.27.tar.xz.asc'

100%[======================================>] 198         --.-K/s   in 0s      

$ gpg --verify *asc
gpg: Signature made Sun May 16 22:20:44 2010 CEST using DSA key ID 844C4360
gpg: Good signature from "Jan Engelhardt <jengelh@gmx.de>"

$ sha1sum sf/xtables-addons-1.27.tar.xz local/xtables-addons-1.27.tar.xz 
a0ac6a28de3258629c9020394f69bda5eae54e54  sf/xtables-addons-1.27.tar.xz
a0ac6a28de3258629c9020394f69bda5eae54e54  local/xtables-addons-1.27.tar.xz

$ xz -t sf/xtables-addons-1.27.tar.xz; echo $?
0

All is normal.
