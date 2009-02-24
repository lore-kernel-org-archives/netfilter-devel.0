From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ANNOUNCE] conntrack-tools 0.9.11 released
Date: Tue, 24 Feb 2009 10:55:10 +0100
Message-ID: <49A3C3FE.2000403@netfilter.org>
References: <49A03C73.8010004@netfilter.org>	<20090222233433.0dc8f396@liberty.rlwhome.lan>	<alpine.LSU.2.00.0902230815570.20446@fbirervta.pbzchgretzou.qr>	<49A26A3E.5020707@netfilter.org> <20090223093416.2c63fc02@liberty.rlwhome.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Robby Workman <rw@rlworkman.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20090223093416.2c63fc02@liberty.rlwhome.lan>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Robby Workman wrote:
> On Mon, 23 Feb 2009 10:19:58 +0100
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
>> Jan Engelhardt wrote:
>>> On Monday 2009-02-23 06:34, Robby Workman wrote:
>>>> On Sat, 21 Feb 2009 18:40:03 +0100
>>>> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>>>
>>>>> The netfilter project presents another development release of the
>>>>> conntrack-tools...
>>>> I thought I recalled seeing discussion about this already, but I
>>>> don't see it in my archives, so maybe not.   With glibc-2.7, this
>>>> release builds fine; however, with glibc-2.9, both src/mcast.c and
>>>> src/sync-mode.c need limits.h included, or else INT_MAX is
>>>> undefined.
>>> This builds fine for me - and I am on glibc 2.9.
>>> Just *what* is it in (which distro? Debian/Ubuntu again?)
>>> again to constantly fail on INT_MAX?
>> Indeed. This also compiles fine for me in debian. I have committed a
>> patch for this [1]. This issue is unfortunate. Gentoo bugzilla on
>> conntrack-tools had a patch but nobody has sent it to me. I notice it
>> after the release.
>>
>> [1]
>> http://git.netfilter.org/cgi-bin/gitweb.cgi?p=conntrack-tools.git;a=commit;h=9bf002ff7935e7dff625683787fc3a06ac2ef2cb
> 
> 
> Weird that it's not affecting Jan then, because it's definitely
> something specific to newer glibc (or perhaps gcc, but it's not
> immediately obvious how that would be the case). I'm on Slackware 
> rather than Gentoo, running quite a bit of prerelease development 
> builds (including gcc-4.3.3 and glibc-2.9 along with 2.6.28.7 kernel).

I'm don't mind too much as long as the following patch (which is already
in git to fix the gentoo's problem) fixes also yours:

http://git.netfilter.org/cgi-bin/gitweb.cgi?p=conntrack-tools.git;a=commitdiff;h=9bf002ff7935e7dff625683787fc3a06ac2ef2cb;hp=87c8c090e1b64eac27edb968845cb1e8ee65b06b

Please, confirm that the problem is resolved.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
