From: Paul Moore <pmoore@redhat.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Wed, 18 Jan 2017 07:32:40 -0500
Message-ID: <CAGH-KguX7fsNnZKmNxLiM5s8bnavq=6UknEaQ5Pa5xXucGHdtQ@mail.gmail.com>
References: <20170117052551.GQ3087@madcap2.tricolour.ca>
	<3051394.ngqbNXneNL@x2>
	<20170117161228.GS3087@madcap2.tricolour.ca>
	<CAHC9VhT7aR1hHfDyU-r6QXTV92rEx1x8s7cH66bzh8FiDv24eQ@mail.gmail.com>
	<20170118023429.GW3087@madcap2.tricolour.ca>
	<20170118053904.GE18214@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <20170118053904.GE18214@madcap2.tricolour.ca>
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

On Wed, Jan 18, 2017 at 12:39 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2017-01-17 21:34, Richard Guy Briggs wrote:
>> On 2017-01-17 15:17, Paul Moore wrote:
>> > On Tue, Jan 17, 2017 at 11:12 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
>> > > On 2017-01-17 08:55, Steve Grubb wrote:
>> > >> On Tuesday, January 17, 2017 12:25:51 AM EST Richard Guy Briggs wrote:
>> >
>> > ...
>> >
>> > >> > Ones that are not so straightforward:
>> > >> > - "secmark" depends on a kernel config setting, so should it always be
>> > >> >   present but "(none)" if that kernel feature is compiled out?
>> > >>
>> > >> If this is selinux related, I'd treat it the same way that we do subj
>> > >> everywhere else.
>> > >
>> > > Ok.
>> >
>> > To be clear, a packet's secmark should be recorded via a dedicated
>> > field, e.g. "secmark", and not use the "subj" field (it isn't a
>> > subject label in the traditional sense).
>>
>> I think Steve was talking about if, when or where to include that field,
>> not what its label is.
>
> In this case it is an "obj=" field, but since it is part of the LSM,
> each one has its own fields.

As I said above, use a "secmark" field and not the subject or object
fields; packet labeling is rather complex and there is value in
differentiating between secmark labels and network peer labels.

-- 
paul moore
security @ redhat
