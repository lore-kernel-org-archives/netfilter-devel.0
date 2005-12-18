From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: [ANNOUNCE] Debian packages for libnfnetlink, libnetfilter-{queue,
 log, conntrack}, conntrack
Date: Sun, 18 Dec 2005 19:20:04 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0512181918310.24288@bizon.gios.gov.pl>
References: <20051127173411.GA2031@roonstrasse.net>
	<438A02D3.3030203@trash.net>
	<20051202102345.GA29691@roonstrasse.net> <43A59A5F.1010006@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-2119315527-1134930004=:24288"
Cc: laforge@netfilter.org, Max Kellermann <max@duempel.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43A59A5F.1010006@trash.net>
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

---187430788-2119315527-1134930004=:24288
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sun, 18 Dec 2005, Patrick McHardy wrote:

> Max Kellermann wrote:
>> On 2005/11/27 20:02, Patrick McHardy <kaber@trash.net> wrote:
>>=20
>>> Very nice, but please wait with trying to get them into
>>> sid until we have resolved the CTA_PROTO_NUM issue.
>>=20
>>=20
>> ok, please notify me when the new release is out.
>
> I've changed libnetlink_conntrack to use the correct type, I guess
> we should release this soon. Harald, I'm not familiar with the
> process, can you please take care of this?

I think we should add some comment about required kernel and wait for=20
2.6.14.5 and 2.6.15 to come out.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-2119315527-1134930004=:24288--
