From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [Q] iptables AH module api mismatch between -master and 1.4.7
Date: Wed, 15 Jul 2015 15:10:49 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1507151509580.30528@nerf40.vanv.qr>
References: <20150715121521.GK2034@uranus>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, vzdevel <devel@openvz.org>,
	Pavel Emelyanov <xemul@virtuozzo.com>,
	Konstantin Khorenko <khorenko@virtuozzo.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:33703 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbbGONKu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jul 2015 09:10:50 -0400
In-Reply-To: <20150715121521.GK2034@uranus>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2015-07-15 14:15, Cyrill Gorcunov wrote:

>Hello! Could you clarify please the following aspect: before the commit
>
> | commit 6944f2c8190f1c4319aeac748470c71b0ba45025
>
>if the AH module has no --ahspi argument passed to iptables then it
>became [0;0xffffffff] by default, but in -master branch it becomes
>[0;0] instead

That is unintentional. Just posted a patch with which I think
this is remedied.
