From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 1/2] iptables: utils: Add bash completion
Date: Wed, 2 Mar 2016 12:57:37 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1603021237030.15093@nerf40.vanv.qr>
References: <1456412814-4580-1-git-send-email-mart.frauenlob@chello.at> <1456412814-4580-2-git-send-email-mart.frauenlob@chello.at> <20160302113411.GA2068@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Mart Frauenlob <mart.frauenlob@chello.at>,
	netfilter-devel@vger.kernel.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:35878 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207AbcCBMEl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 07:04:41 -0500
In-Reply-To: <20160302113411.GA2068@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2016-03-02 12:34, Pablo Neira Ayuso wrote:
>On Thu, Feb 25, 2016 at 04:06:53PM +0100, Mart Frauenlob wrote:
>> This is a fully featured completion for ip[6]tables.
>>  utils/iptables_bash_completion/README.md |  290 ++++
>>  utils/iptables_bash_completion/iptables  | 2426 ++++++++++++++++++++++++++++++
>
>This is fair good amount of work, but this is also quite a bit of
>new shell code to be maintained in our trees.

That much is true..

>Moreover, I was told that, in the specific case of debian, there is a
>package (bash-completion) where you place this.

In other environments, bash-completion is more of a dumping ground
for scripts that (1.) do not live with their upstream, _and_, (2.)
also do not live with the distro-level source package for some
reason.

12:42 zap:~ # rpm -qf /etc/bash_completion.d/* /usr/share/bash-completion/* | sort -u
btrfsprogs-4.3.1-10.1.x86_64
grub2-2.02~beta2-20.14.2.x86_64
gstreamer-1.6.3-65.3.x86_64
kmod-21-0.x86_64
libreoffice-5.0.4.2-28.1.x86_64
util-linux-2.25.1-20.1.x86_64
util-linux-systemd-2.25.1-20.1.x86_64
youtube-dl-2016.03.01-101.1.noarch
zypper-1.11.34-1.1.x86_64
[...]

Having the completion script in the iptables releases would easily
ensure it always trickles down to distros in the same fashion, without
distro-level maintainers have to pull it down from $some_random_place.
