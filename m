From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [Q] iptables AH module api mismatch between -master and 1.4.7
Date: Wed, 15 Jul 2015 16:19:38 +0300
Message-ID: <20150715131938.GL2034@uranus>
References: <20150715121521.GK2034@uranus>
 <alpine.LSU.2.20.1507151509580.30528@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, vzdevel <devel@openvz.org>,
	Pavel Emelyanov <xemul@virtuozzo.com>,
	Konstantin Khorenko <khorenko@virtuozzo.com>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:32929 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbbGONTm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jul 2015 09:19:42 -0400
Received: by laem6 with SMTP id m6so24506815lae.0
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jul 2015 06:19:41 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1507151509580.30528@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 15, 2015 at 03:10:49PM +0200, Jan Engelhardt wrote:
> 
> On Wednesday 2015-07-15 14:15, Cyrill Gorcunov wrote:
> 
> >Hello! Could you clarify please the following aspect: before the commit
> >
> > | commit 6944f2c8190f1c4319aeac748470c71b0ba45025
> >
> >if the AH module has no --ahspi argument passed to iptables then it
> >became [0;0xffffffff] by default, but in -master branch it becomes
> >[0;0] instead
> 
> That is unintentional. Just posted a patch with which I think
> this is remedied.

Thank you!
