From: Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH 1/1] netfilter: ip{,6}t_policy.h should include
	xp_policy.h
Date: Thu, 20 Nov 2008 10:37:16 +0000
Message-ID: <20081120103716.GC31575@shadowen.org>
References: <1227111682-14073-1-git-send-email-apw@canonical.com> <49245611.1080905@trash.net> <20081120094541.GA31575@shadowen.org> <49253219.9070300@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49253219.9070300@trash.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Nov 20, 2008 at 10:47:05AM +0100, Patrick McHardy wrote:
> Andy Whitcroft wrote:
>> On Wed, Nov 19, 2008 at 07:08:17PM +0100, Patrick McHardy wrote:
>>> Andy Whitcroft wrote:
>>>> It seems that all of the include/netfilter_{ipv4,ipv6}/{ipt,ip6t}_*.h which
>>>> share constants include the corresponding include/netfilter/xp_*.h files.
>>>> Neither ipt_policy.h not ip6t_policy.h do.  Make these consistant with
>>>> the norm.
>>> Does this actually fix a bug, or is it just for added consistency?
>>
>> It was reported by an Ubuntu user who was compiling against them.  From
>> my point of view it seemed clearly inconsistant and therefore most likely
>> wrong.  So it seemed reasonable to fix it and push it upstream, if
>> there was a reason I was sure you'd soon put me straight.
>
> I'm mainly asking in order to decide whether to push it for
> 2.7.28 or 2.6.29. So did the user report a compilation error
> or something like that?

We do have a bug open from an Ubuntu user who seems have hit the issue,
but details are scant, they did not report specifics of their use case.
I don't see it being particularly urgent, the work around is pretty simple
as I see it.  So I don't think there is any need to jump hoops to get it
into .28, we are pretty late in the cycle on that one.  For me knowing
its going to be upstream in .29 or wherever allows me to report that back
to the user.  If they are really insistant we can always pull the change
into our kernel as we won't have to carry it forever, though that is not
likely to be necessary.

-apw
