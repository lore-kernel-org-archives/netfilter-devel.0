From: Patrick McHardy <kaber@trash.net>
Subject: Re: nfq_set_verdict_mark
Date: Wed, 11 Oct 2006 11:02:53 +0200
Message-ID: <452CB33D.8060908@trash.net>
References: <986D9B66-68B6-4A02-9762-40224E145496@cadvium.net>
	<4521284C.2070000@netfilter.org> <452B2D9A.7080702@trash.net>
	<452C33FE.6060902@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Robert Scott <rbscott@cadvium.net>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <452C33FE.6060902@netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
> 
>>I'm beginning to wonder how much more kludges we will have in these
>>libraries by continuing to treat them as stable without having had
>>even a single beta version.
> 
> 
> OK, I start thinking that I'm getting obsessed with breaking current
> deployed apps :(. I also think that we can solve this minor annoying
> issues by fixing the problem and then releasing a new version asap.

I checked google code-search and the two users I could find already
do the conversion manually, so they will break. Thats definitely not
good, but I wonder if we should trust that this will be the last
of these bugs or if we should clearly mark this as beta/unstable API
and appologize for not beeing clear from the beginning. Its just
not a good idea to release a library with an interface that is more
or less cast in stone without any real testing.

> The current release process is too slow, I have the impression that
> nobody is using the lastest official releases. For conntrackd, I'm
> currently doing unnofficial releases of libnetfilter_conntrack because
> the official release is broken with NAT handlings, well apart from the
> fact that I also introduce some patches with new features that I need.

You're probably right (about people not using official releases) and
definitely right about releasing too seldom.

> Just tell you that I don't mind about spending some time on
> administration tasks like releases and any other stuff related with the
> website if that can help to speed up the release process. I worked on
> some scripts to automate the release process time ago after the workshop
> that I can recover.

That would be great. Let me know if you need anything (I think I recall
your keys expired?).
