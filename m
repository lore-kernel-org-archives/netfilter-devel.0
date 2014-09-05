From: Florian Westphal <fw@strlen.de>
Subject: Re: iptables: missing connlabel.conf causes unnecessary error
 messages
Date: Fri, 5 Sep 2014 11:51:37 +0200
Message-ID: <20140905095137.GC934@breakpoint.cc>
References: <CAAXf6LW4zfxOMeUO4=UPFUX=0VGjLbM_wKhdb3L7DK4SPBmbhg@mail.gmail.com>
 <20140905091305.GB934@breakpoint.cc>
 <CAAXf6LVWzjt_becB7dwFNtcevGZn-nsGxACtZHqrv+4MUSsSaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Thomas De Schampheleire <patrickdepinguin@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58021 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755840AbaIEJvj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:51:39 -0400
Content-Disposition: inline
In-Reply-To: <CAAXf6LVWzjt_becB7dwFNtcevGZn-nsGxACtZHqrv+4MUSsSaA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas De Schampheleire <patrickdepinguin@gmail.com> wrote:
> On Fri, Sep 5, 2014 at 11:13 AM, Florian Westphal <fw@strlen.de> wrote:
> > Thomas De Schampheleire <patrickdepinguin@gmail.com> wrote:
> >> Commit http://git.netfilter.org/iptables/commit/?id=51340f7b6a1103b12d86ef488f7140406d80401e
> >> removed the default /etc/xtables/connlabel.conf file distributed with netfilter.
> >>
> >> From this commit onwards, every call to iptables will show the message:
> >>     cannot open connlabel.conf, not registering 'connlabel' match: No
> >> such file or directory
> >
> > Right, this happens for static builds.
> 
> If with 'static' you mean 'statically linked', then this is not correct.
> My iptables application is dynamically linked:

I meant --enable-static during configure stage.
