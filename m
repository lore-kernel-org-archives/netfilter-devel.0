From: Paul Moore <paul@paul-moore.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Wed, 8 Feb 2017 18:09:07 -0500
Message-ID: <CAHC9VhTG-ByCf5v0tmXmVJBhCer3-3AvMUJP45UPTNF_Xik3JA@mail.gmail.com>
References: <20170117052551.GQ3087@madcap2.tricolour.ca>
	<20170207205219.GA5864@madcap2.tricolour.ca>
	<CAGH-KguuAriVuLEE+mb2HwQLcq6ePeDfVyZ=acoxmomnK5R09w@mail.gmail.com>
	<5128842.c7Bb9yu5kt@x2>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Steve Grubb <sgrubb@redhat.com>
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <5128842.c7Bb9yu5kt@x2>
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

On Wed, Feb 8, 2017 at 11:30 AM, Steve Grubb <sgrubb@redhat.com> wrote:
> On Tuesday, February 7, 2017 10:56:39 PM EST Paul Moore wrote:
>> On Tue, Feb 7, 2017 at 3:52 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
>> > So while I'm not advocating this is what should be done and I'm trying
>> > to establish bounds to the scope of this feature, but would it be
>> > reasonable to simply not log packets that were transiting this machine
>> > without a local endpoint?
>>
>> I'm still waiting on more detailed requirements information from
>> Steve, but based on what we've heard so far, it seems that ignoring
>> forwarded traffic is a reasonable thing to do.
>
> OK, I have done teh analysis to see where things stand on this ...

...

> At this point, I would say there is no purpose for xt_AUDIT.c based on Common
> Criteria. It looks like its built in response to the
> CONFIG_NETFILTER_XT_TARGET_AUDIT config option. So, it can be cleanly
> deprecated.

Based on some off-list discussions with Richard it would appear that
there are several users of the NETFILTER_PKT record so I am in no
hurry to deprecate it.  Considering that there are no CC requirements
on the record, I think we can focus on simply providing a basic record
that satisfies the whims of the userspace tools without adding any
pain to the kernel.  I believe Richard is currently working on a
proposal to do that, let's discuss it further in that thread.

-- 
paul moore
www.paul-moore.com
