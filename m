From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: ipset: Timeout can be modified for already
 added elements
Date: Wed, 13 Apr 2011 13:52:55 +0200
Message-ID: <4DA58E97.2020509@trash.net>
References: <1302171060-20872-1-git-send-email-kadlec@blackhole.kfki.hu> <1302171060-20872-2-git-send-email-kadlec@blackhole.kfki.hu> <1302171060-20872-3-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38922 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab1DMLw5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 07:52:57 -0400
In-Reply-To: <1302171060-20872-3-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 07.04.2011 12:11, schrieb Jozsef Kadlecsik:
> When an element to a set with timeout added, one can change the timeout
> by "readding" the element with the "-exist" flag. That means the timeout
> value is reset to the specified one (or to the default from the set
> specification if the "timeout n" option is not used). Example
> 
> ipset add foo 1.2.3.4 timeout 10
> ipset add foo 1.2.3.4 timeout 600 -exist
> 

This one unfortunately also doesn't apply cleanly, please rebase to
nf-next-2.6.git. Thanks!
