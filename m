From: jamal <hadi@cyberus.ca>
Subject: Re: user-space xtables ABI [was Re: [Fwd: Re: iptables pull
	request]]
Date: Sun, 17 May 2009 11:14:21 -0400
Message-ID: <1242573261.3996.36.camel@dogo.mojatatu.com>
References: <4A0E9786.8060407@netfilter.org>
	 <1242566196.3996.23.camel@dogo.mojatatu.com>
	 <4A10235B.3070607@netfilter.org>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:34182 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbZEQPVV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 May 2009 11:21:21 -0400
Received: by qw-out-2122.google.com with SMTP id 5so2213047qwd.37
        for <netfilter-devel@vger.kernel.org>; Sun, 17 May 2009 08:21:22 -0700 (PDT)
In-Reply-To: <4A10235B.3070607@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo,

On Sun, 2009-05-17 at 16:46 +0200, Pablo Neira Ayuso wrote:

> Now that we have a public API for extensions and your tc ipt thing uses
> it, I would not expect more breakages as long as we're aware of it.
[..]
> I think that, now that we have a public API, ABI should be not broken.

That would be fantastic.

> In case that some interface has limitations, we can add a new one while
> keeping the old. 

And maybe spit out some warning somewhere that the interface being used
is deprecated (the way the kernel does it so well currently).

> The result is not nice since you end having two
> functions that do the same with different interfaces but this doesn't
> break binary backward compatibility. 

Would be an improvement - currently i have to find out over configure
scripts at compile time i.e write a little program using old API and if
doesnt compile, try the next thing etc.
I think if you also depracate over a period of time the old interface
by giving ample warnings the API users are surely going to migrate.

> Of course, the change would need
> some justification, eg. some client code do need something that the
> current interface does not allow in any way.

Indeed.

> With this policy, design errors accumulate along time so we learn the
> lesson from our own mistakes and, then, we work on a new version 2 of
> the API to resolve the accumulated issues after some time. This is how
> I'm managing existing netfilter libraries. This policy makes the
> developement of libraries/public interfaces slower but I think that
> users are way happier (no binary breakages).

I think there will always be challenges and lessons learnt but i dont
see the approach you outline as making "development slower" - it just
forces whoever introduces a new interface thinks at least twice ;->
An evolution instead of a revolution is a lot more acceptable
i.e build on existing interface and give it more features than totaly
changing it like you change your socks.

cheers,
jamal 

