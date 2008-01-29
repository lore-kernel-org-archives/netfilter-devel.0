From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: iptables-addons project idea
Date: Tue, 29 Jan 2008 18:44:14 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801291833300.14907@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net, Krzysztof Oledzki <ole@ans.pl>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34649 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbYA2RoQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:44:16 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


I have started the iptables-addons subproject which aims to replace 
patch-o-matic-ng, at least for those extensions which do not need to 
patch into the kernel. Means, you just run make within the source 
directory (assuming you have kernel-source and iptables-devel 
installed) and got more extensions.

The initial tree with the TARPIT and TEE targets is at

(repository)	git://computergmbh.de/iptables-addons
(gitweb)	http://dev.computergmbh.de/

There is a "compat" branch which provides glue code to make it compile 
(and run) on kernels older than davem/net-2.6.25.git without having to 
clutter the actual extensions with #preprocessor directives. (I 
personally like it - with just 6 KB of glue, it should compile for 
kernels starting from 2.6.19!)

So what you want is the "compat" branch for compiling, and the "master" 
branch for judgement :-)

Again, the tree only has two targets right now because you might have 
wanted to transform the patch-o-matic-ng repository and keeping history 
instead of starting history afresh.

Comments please!
thanks,
Jan
