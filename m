From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: Problem accessing https://my.procurve.com/profile/index.aspx
 (ACK is over the upper bound)
Date: Mon, 2 Jul 2007 20:55:56 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707022017050.25153@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0707010207490.13212@bizon.gios.gov.pl>
	<Pine.LNX.4.64.0707010255010.13212@bizon.gios.gov.pl>
	<Pine.LNX.4.64.0707010334080.13212@bizon.gios.gov.pl>
	<4688FD1A.4010303@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1965030743-1183402556=:25153"
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4688FD1A.4010303@trash.net>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1965030743-1183402556=:25153
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 2 Jul 2007, Patrick McHardy wrote:

> Krzysztof Oledzki wrote:
>> Found this:
>>
>> http://groups.google.pl/group/fa.openbsd.tech/browse_frm/thread/e27c7363=
b2c636b5/01ba6e0fa873cf42
>>
>>
>> Sounds familiar - it seems that there may be a crappy OpenBSD firewall
>> lurking somewhere along the path. :(
>
>
> Indeed, too bad they apparently don't fix their crap and we're getting
> at least one report per month about this.

It seems they finally fixed it in a cvs at end of the Jan 2006 (so late -=
=20
10 years after sack had been specified in rfc2018):=20
http://www.openbsd.org/cgi-bin/cvsweb/src/sys/net/pf.c.diff?r1=3D1.508&r2=
=3D1.509

AFAIK it first went into 4.0 (released Nov 1, 2006) and also OPENBSD_3_9=20
(STABLE "branch" for 3.9) so it is safe to assume that only very new=20
installations may be safe. :(

AFAIK (again) this fix hasn't went into FreeBSD and NetBSD at all. :( Oh,=
=20
crappy...

>> What we can do with such packets? Maybe, when a ack is valid but a sack
>> is not (as it is in this situation) we are able to remove such insane
>> sack option(s) with a hope that this ACK itself may acknowledge somethin=
g?
>
>
> I'm not too big a fan of this idea, but I will consider it if someone
> sends a patch. It would have to be manually enabled at least.

Fair enough.

>> Additionally, creating TCPOPTSSTRIP target to allow striping specific
>> tcp option(s) (for example Sack-Permitted from a SYN packet) may also be
>> usable if it is possible to include this extension in a base kernel.
>> This may also help with a similar window scaling problem as current
>> solution requires to add a route on _all_ hosts inside a network.
>> Working around it on a firewall may be much faster.
>
>
> Feel free to send patches :)

OK. Will try to cook something. Can I base it on the IPV4OPTSSTRIP=20
there is a better example? :)

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1965030743-1183402556=:25153--
