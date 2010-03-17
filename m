From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 7/9] netfilter: xtables: inclusion of xt_SYSRQ
Date: Wed, 17 Mar 2010 15:21:23 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003171515040.6297@obet.zrqbmnf.qr>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-8-git-send-email-jengelh@medozas.de> <4BA0DF81.3030204@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38800 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748Ab0CQOVY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:21:24 -0400
In-Reply-To: <4BA0DF81.3030204@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-03-17 14:56, Patrick McHardy wrote:

>Jan Engelhardt wrote:
>> The SYSRQ target will allow to remotely invoke sysrq on the local
>> machine. Authentication is by means of a pre-shared key that can
>> either be transmitted plaintext or digest-secured.
>
>Lets deal with the other modules first while I make up my mind.

John Haxby wanted to see xt_SYSRQ mainlined[1]
[1] http://comments.gmane.org/gmane.comp.security.firewalls.netfilter.devel/32706


xt_condition's submission was triggered by reappearing souls on IRC (you 
might want to visit that sometimes ;-)
16.03.2010/20:27 < mancha> "no web access" is a nice toggle to have as 
are others
I personally use it too; somehow I find (when leaving the house)
 echo 1 >/proc/net/nf_condition/allow_from_university
more integrated than having to keep two iptables-restore rulesets in 
sync.


xt_TEE is something network people really seem to love[2,3] for logging.
[2] http://www.bjou.de/blog/2008/05/howto-copyteeclone-network-traffic-using-iptables/
[3] http://www-rocq.inria.fr/imara/dw/users/oliviermehani/2008phd/rtmapsplatform
