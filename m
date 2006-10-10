From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nfq_set_verdict_mark
Date: Wed, 11 Oct 2006 01:59:58 +0200
Message-ID: <452C33FE.6060902@netfilter.org>
References: <986D9B66-68B6-4A02-9762-40224E145496@cadvium.net>
	<4521284C.2070000@netfilter.org> <452B2D9A.7080702@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Robert Scott <rbscott@cadvium.net>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <452B2D9A.7080702@trash.net>
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

Hi Patrick,

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Robert Scott wrote:
>>
>>> i noticed that this function doesn't automatically convert the mark into
>>> the expected network byte order.  this is a minor detail, but the
>>> current behavior may confuse users. since nfq_get_nfmark automatically
>>> converts the mark into host order, i thought nfq_set_verdict_mark would
>>> also  do the reverse.
>>>
>>> not really a big deal, and this will probably break most existing
>>> installations in the field, but perhaps a note in the docs to give new
>>> users a heads up.
>>
>> Yes, I agree what you, we have to document this minor issue, I think
>> that we can introduce more API that can solve this inconsistency.
> 
> Do we actually have documentation where we can document it? :)
> 
> I'm beginning to wonder how much more kludges we will have in these
> libraries by continuing to treat them as stable without having had
> even a single beta version.

OK, I start thinking that I'm getting obsessed with breaking current
deployed apps :(. I also think that we can solve this minor annoying
issues by fixing the problem and then releasing a new version asap.

The current release process is too slow, I have the impression that
nobody is using the lastest official releases. For conntrackd, I'm
currently doing unnofficial releases of libnetfilter_conntrack because
the official release is broken with NAT handlings, well apart from the
fact that I also introduce some patches with new features that I need.

Just tell you that I don't mind about spending some time on
administration tasks like releases and any other stuff related with the
website if that can help to speed up the release process. I worked on
some scripts to automate the release process time ago after the workshop
that I can recover.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
