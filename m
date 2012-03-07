From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: NFQUEUE in bridge mode performance poor in the last kernels
Date: Tue, 06 Mar 2012 17:19:43 -0800
Message-ID: <1331083183.9504.10.camel@edumazet-glaptop>
References: <CA+qZnSTG+_5y=6dGFqoJwRj0LxMvr2qtmyvykFjfnVgaYgbNPA@mail.gmail.com>
	 <1331047163.2474.47.camel@edumazet-laptop>
	 <CA+qZnSTMb=wXeHmmj5=HKxQcLbMJK16m+u37EERw5G_Wgup5tQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: tingwei liu <tingw.liu@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:34216 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031740Ab2CGBTq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Mar 2012 20:19:46 -0500
Received: by obbuo6 with SMTP id uo6so6171170obb.19
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Mar 2012 17:19:45 -0800 (PST)
In-Reply-To: <CA+qZnSTMb=wXeHmmj5=HKxQcLbMJK16m+u37EERw5G_Wgup5tQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2012-03-07 at 08:46 +0800, tingwei liu wrote:
> On Tue, Mar 6, 2012 at 11:19 PM, Eric Dumazet <eric.dumazet@gmail.com=
> wrote:
> > Le mardi 06 mars 2012 =C3=A0 10:05 +0800, tingwei liu a =C3=A9crit =
:
> >> In the past few days, I have puzzled by NFQUEUE in bridge mode.
> >> I have take some test with five kernels.
> >> 2.6.24.4
> >> 2.6.36.4
> >> 2.6.38
> >> 3.0.8
> >> 3.1.10
> >>
> >> The result is : 2.6.24.4,2.6.26.4,2.6.38 have a goog performance;
> >> 3.0.8 and 3.1.10 have a poor performance.
> >> Next is copy from suricata maillist( eric@regit.org )
> >>
> >> I'm having a look at it. There has been some changes between the t=
wo
> >> kernel versions (bringing more performances) but it seems there is=
 some
> >> side effects with bridge.
> >> Thanks!
> >
> > More data is welcomed. What is "good", what is "bad" ?
> >
> Sorry for that.
> My network is 100Mbps.
> "good" means the forward bandwidth almost 100Mbps.
> "bad" means the forward bandwidth with nfqueue only 30Mbps.
> Thanks for your reply!

more info needed... like what kind of network adapter do you use , and
ethtool -k settings, like

ethtool -k eth0


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
