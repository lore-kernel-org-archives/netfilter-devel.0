From: Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH] audit: normalize NETFILTER_PKT
Date: Wed, 8 Feb 2017 18:11:17 -0500
Message-ID: <CAHC9VhTj4sGyVt+j-SUA64Z1TwSZQkzoi35kmopcpOL2Lk97AA@mail.gmail.com>
References: <e3af1eaaf566af375dbc79abd4535e86f2fc8a6d.1485522479.git.rgb@redhat.com>
	<20170131194419.GE27141@madcap2.tricolour.ca>
	<CAHC9VhQu7sG_mMWjhYC=k-Kr_YQmrOyMboR3mckuBdSqsFuboQ@mail.gmail.com>
	<6667634.hKks8rloKk@x2>
	<CAHC9VhRKJjn7VWFusUo7FZy=SBrD_-P51XYye6baZpRC1bkvOQ@mail.gmail.com>
	<20170207212231.GG26850@madcap2.tricolour.ca>
	<CAGH-KgsKKCCigNRAyZeL1pxHxkrBD270FZpO3O4rLLZAJaQmyw@mail.gmail.com>
	<20170208123217.GI26850@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-audit@redhat.com,
        Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <20170208123217.GI26850@madcap2.tricolour.ca>
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

On Wed, Feb 8, 2017 at 7:32 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2017-02-07 23:02, Paul Moore wrote:
>> On Tue, Feb 7, 2017 at 4:22 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
>> > On 2017-02-06 14:41, Paul Moore wrote:
>> >> On Sat, Feb 4, 2017 at 8:25 AM, Steve Grubb <sgrubb@redhat.com> wrote:
>> >> > On Friday, February 3, 2017 6:44:16 PM EST Paul Moore wrote:
>> >> >> I'm still trying to understand what purpose this record actually
>> >> >> serves, and what requirements may exist.  In an earlier thread
>> >> >> somewhere Steve mentioned some broad requirements around data
>> >> >> import/export, and I really wonder if the NETFILTER_PKT record
>> >> >> provides anything useful here when it really isn't connecting the
>> >> >> traffic to the sender/receiver without a lot of additional logging and
>> >> >> post-processing smarts.  If you were interested in data import/export
>> >> >> I think auditing the socket syscalls would provide a much more useful
>> >> >> set of records in the audit log.
>> >> >
>> >> > The problem here is we cannot be selective enough through the syscall
>> >> > interface to get exactly what we want. For example, any auditing of connect
>> >> > and accept will also get af_unix traffic which is likely to be uid/gid lookups
>> >> > through sssd or glibc. Typically we want the IPv4/6 traffic. The netfilter rules
>> >> > are better suited to describing which packets are of interest.
>> >>
>> >> Okay, but how useful are these NETFILTER_PKT records, really?  The
>> >> only linkage you have back to the process on the local machine is via
>> >> the addr/proto/port tuple and that seems far from ideal.
>> >
>> > And even that could be spoofed easily and gathering more corroborating
>> > information would seem useful.
>> >
>> > Would the presence of the SOCKADDR record in any SYSCALL record be
>> > useful for somehow tagging a class of fd as being of interest?
>>
>> I don't think we want to create a SOCKADDR record for every syscall,
>> but it seems reasonable that we may want to include it for targeted
>> syscalls.  Right now it looks like we create a SOCKADDR record
>> whenever we copy a sockaddr struct across the kernel/userspace
>> boundary, that should be sufficient, yes?
>
> Yes, we certainly don't need it for every syscall.  Since the sockaddr
> record is only created if it is available we could further flag or check
> the protocol to further process only the network-based sockaddrs and
> ignore the unix sockaddrs for this purpose.  I'm picturing adding a flag
> to the fd, but that is making me a bit nervous about overstepping our
> usual code area.

Let's keep it as-is, I would think there are other cases where having
the address info for AF_UNIX (and others) might be helpful.

-- 
paul moore
www.paul-moore.com
