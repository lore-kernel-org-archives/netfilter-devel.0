From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 2.6.15.4 1/1][RFC] ipt_owner: inode match supporting both
 incoming and outgoing packets
Date: Mon, 20 Feb 2006 15:06:41 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0602201502220.21834@excalibur.intercode>
References: <200602181410.59757.edwin.torok@level7.ro>
 <Pine.LNX.4.64.0602201122330.21034@excalibur.intercode>
 <200602201940.40504.edwin.torok@level7.ro>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="537529445-163837869-1140466001=:21834"
Cc: netfilter-devel@lists.netfilter.org,
	fireflier-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, martinmaurer@gmx.at,
	Patrick McHardy <kaber@trash.net>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161115AbWBTUGq@vger.kernel.org>
To: =?iso-8859-2?q?T=F6r=F6k_Edwin?= <edwin.torok@level7.ro>
In-Reply-To: <200602201940.40504.edwin.torok@level7.ro>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--537529445-163837869-1140466001=:21834
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 20 Feb 2006, Török Edwin wrote:

> In the following I will be referring to 16-skfilter-ipt_owner-ctx.patch:
> 
> However I'd like to do filtering based on owner (process) even when selinux is 
> not available. Your context match explicitly requires selinux to be enabled, 
> and a policy loaded.

See at 10-skfilter-incoming-ipt_owner.patch, which enables incoming 
matching based on socket owner, not related to SELinux.

> Could you please use LSM hooks (like inode_getsecurity) instead of directly 
> using selinux? I'd want to provide my own implementation of labeling (a 
> very,very simple labeling, a very small subset of what selinux does, but 
> which wouldn't require much configuration). In other words, I want to write a 
> LSM, and then mod_register_security() my module.
> 
> Or if the above is not possible, could you provide some hooks, where I could 
> register my hooks to provide these:
> - int available()
> - int ctx_to_id(char*,u32*)
> - int socket_to_ctxid(struct sock*,u32*)
> 
> (Of course I could create another match that would use my module to do the 
> matching on the SOCKET  chain. But this would uselessly duplicate 
> functionality&code, an additional hook would be a much cleaner solution).
> 
> What is your opinion on what I said above? I am open to suggestions, 
> criticism, advice....

It's possible to investigate doing this via LSM, although probably not 
justified unless someone else is using this feature in the mainline tree.


- James
-- 
James Morris
<jmorris@namei.org>
--537529445-163837869-1140466001=:21834--
