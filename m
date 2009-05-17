From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: user-space xtables ABI [was Re: [Fwd: Re: iptables pull request]]
Date: Sun, 17 May 2009 16:46:51 +0200
Message-ID: <4A10235B.3070607@netfilter.org>
References: <4A0E9786.8060407@netfilter.org> <1242566196.3996.23.camel@dogo.mojatatu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>
To: hadi@cyberus.ca
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58707 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbZEQOrE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 May 2009 10:47:04 -0400
In-Reply-To: <1242566196.3996.23.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jamal,

I'm cc'ing netfilter-devel.

jamal wrote:
> Hi Pablo,
> 
> On Sat, 2009-05-16 at 12:37 +0200, Pablo Neira Ayuso wrote:
>> Hi Jamal!
>>
>> Jan Engelhardt sent a couple of patches a couple of weeks ago. He is
>> changing the API that is being exported by iptables. I think that your
>> tc ipt thing is concerned. Could you let us know your opinion? The main
>> problem that I see is possible ABI breakages.
> 
> I am really hoping that we are going to end up with a stable API.
> 
> With tc the desire is even stronger because we try to maintain 
> backward compatibility i.e an old tc should still be able to 
> use current ipt and a newer tc should still be able to use older
> kernels. So breaking ABI in such a way that this becomes hard 
> to achieve IMO should be once in a blue-moon-sighting event.

Indeed, I agree.

> [Essentially with the last changes, this backward 
> compatibility broke and i had to change even the name of the 
> binary so people dont continue to use it on old scripts.]

Yes, aware of those.

> I have had to "discover" that the ABI was broken 7 different
> iptable releases in the past, when my users whine (it seems to 
> happen with some strong coincidence when i am busy at work); 
> this is an unfair expectation of me and i hope at least you
> guys get to improve on.

Now that we have a public API for extensions and your tc ipt thing uses
it, I would not expect more breakages as long as we're aware of it.

> maybe we can have some simple working relationship rules:
> 
> a) whoever breaks ABI (hopefully there are good reasons
> to intentionally break it) should also fix ipt, just like they
> fix iptables. 
> b) whoever breaks the ABI should consider both backward and
> forward compatibility. I will review patches to make sure this
> is still so.

I think that, now that we have a public API, ABI should be not broken.
In case that some interface has limitations, we can add a new one while
keeping the old. The result is not nice since you end having two
functions that do the same with different interfaces but this doesn't
break binary backward compatibility. Of course, the change would need
some justification, eg. some client code do need something that the
current interface does not allow in any way.

With this policy, design errors accumulate along time so we learn the
lesson from our own mistakes and, then, we work on a new version 2 of
the API to resolve the accumulated issues after some time. This is how
I'm managing existing netfilter libraries. This policy makes the
developement of libraries/public interfaces slower but I think that
users are way happier (no binary breakages).

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
