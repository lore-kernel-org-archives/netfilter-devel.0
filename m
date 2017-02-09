From: Paul Moore <paul@paul-moore.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Thu, 9 Feb 2017 11:31:55 -0500
Message-ID: <CAHC9VhRrDKkoHw7nfApmqCh5GQ8XnjCjALEKG8PBxb4KLvPm9g@mail.gmail.com>
References: <20170117052551.GQ3087@madcap2.tricolour.ca>
	<20170207205219.GA5864@madcap2.tricolour.ca>
	<CAGH-KguuAriVuLEE+mb2HwQLcq6ePeDfVyZ=acoxmomnK5R09w@mail.gmail.com>
	<5128842.c7Bb9yu5kt@x2>
	<CAHC9VhTG-ByCf5v0tmXmVJBhCer3-3AvMUJP45UPTNF_Xik3JA@mail.gmail.com>
	<20170209105617.GA2089@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <20170209105617.GA2089@salvia>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
List-Id: netfilter-devel.vger.kernel.org

On Thu, Feb 9, 2017 at 5:56 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Paul,
>
> On Wed, Feb 08, 2017 at 06:09:07PM -0500, Paul Moore wrote:
>> On Wed, Feb 8, 2017 at 11:30 AM, Steve Grubb <sgrubb@redhat.com> wrote:
>> > On Tuesday, February 7, 2017 10:56:39 PM EST Paul Moore wrote:
>> >> On Tue, Feb 7, 2017 at 3:52 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
>> >> > So while I'm not advocating this is what should be done and I'm trying
>> >> > to establish bounds to the scope of this feature, but would it be
>> >> > reasonable to simply not log packets that were transiting this machine
>> >> > without a local endpoint?
>> >>
>> >> I'm still waiting on more detailed requirements information from
>> >> Steve, but based on what we've heard so far, it seems that ignoring
>> >> forwarded traffic is a reasonable thing to do.
>> >
>> > OK, I have done teh analysis to see where things stand on this ...
>>
>> ...
>>
>> > At this point, I would say there is no purpose for xt_AUDIT.c based on Common
>> > Criteria. It looks like its built in response to the
>> > CONFIG_NETFILTER_XT_TARGET_AUDIT config option. So, it can be cleanly
>> > deprecated.
>>
>> Based on some off-list discussions with Richard it would appear that
>> there are several users of the NETFILTER_PKT record so I am in no
>> hurry to deprecate it.  Considering that there are no CC requirements
>> on the record, I think we can focus on simply providing a basic record
>> that satisfies the whims of the userspace tools without adding any
>> pain to the kernel.  I believe Richard is currently working on a
>> proposal to do that, let's discuss it further in that thread.
>
> If the concern is to keep the existing output format around, you can
> add new functions with the specific new layout at the cost of keeping
> more code around. That should be fine since this code is not much
> complex IMO. You can probably add a new explicit command line option,
> eg. --version, that indicates what audit format version you want to
> use, so users don't break.

There are several things to consider, and I'm not going to worry too
much about it until Richard posts his updated RFC.  In quick summary,
Steve is worried about record formats which don't meet a specific
format specification (e.g. fields that optionally appear depending on
the protocol are bad from his perspective) and I'm worried about
adding a bunch of additional code to the kernel.

We can discuss this further once we see Richard's patches, he is aware
of all the concerns and I expect he will have something interesting to
use as a starting point for further discussion.

> BTW, any plans to add audit support to nf_tables?

It would be nice, but it isn't on my TODO list at the moment; if you
want to work on it I think that would be great!

-- 
paul moore
www.paul-moore.com
