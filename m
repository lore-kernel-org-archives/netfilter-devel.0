From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 2.6.15.4 1/1][RFC] ipt_owner: inode match supporting both
 incoming and outgoing packets
Date: Mon, 20 Feb 2006 11:26:56 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0602201122330.21034@excalibur.intercode>
References: <200602181410.59757.edwin.torok@level7.ro>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="537529445-1169445822-1140452646=:21034"
Cc: netfilter-devel@lists.netfilter.org,
	fireflier-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, martinmaurer@gmx.at,
	Patrick McHardy <kaber@trash.net>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161004AbWBTQ1B@vger.kernel.org>
To: =?iso-8859-1?q?T=F6r=F6k_Edwin?= <edwin.torok@level7.ro>
In-Reply-To: <200602181410.59757.edwin.torok@level7.ro>
Content-ID: <Pine.LNX.4.64.0602201125220.21034@excalibur.intercode>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--537529445-1169445822-1140452646=:21034
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0602201125221.21034@excalibur.intercode>

On Sat, 18 Feb 2006, Török Edwin wrote:

> This is a patch based on Luke Kenneth Casson Leighton's patch [1] 
> One problem with that patch was that it couldn't be used for filtering 
> incoming packets, due to the fact that more than one process can listen on 
> the same socket ([2],[3]).

Have a look at my skfilter patches:
http://people.redhat.com/jmorris/selinux/skfilter/kernel/

These implement a scheme for matching incoming packets against sockets by 
adding a new hook in the socket layer.

For upstream merge, the issues are:
- should the new socket hook be used for all incoming packets?
- ensure IP queuing still works

Patrick: any other issues?



- James
-- 
James Morris
<jmorris@namei.org>
--537529445-1169445822-1140452646=:21034--
