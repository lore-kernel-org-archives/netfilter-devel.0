From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: kernel BUG at kernel/sched.c:2833!
Date: Tue, 22 Nov 2005 12:40:28 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511221236510.16598@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0511141033001.8729@bizon.gios.gov.pl>
	<437882BE.6080705@eurodev.net>
	<Pine.LNX.4.64.0511162216140.16387@bizon.gios.gov.pl>
	<437BD093.3010905@eurodev.net>
	<Pine.LNX.4.64.0511172250390.9911@bizon.gios.gov.pl>
	<4381D8B3.1010100@eurodev.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1341955812-1132659628=:16598"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4381D8B3.1010100@eurodev.net>
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

---187430788-1341955812-1132659628=:16598
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 21 Nov 2005, Pablo Neira wrote:

> Hi,
>
> Krzysztof Oledzki wrote:
>>> I realised that Yasuyuki's patch is incomplete. Could you give a try to
>>> the patch attached. Thanks.
>>
>> Didn't help:
>>
>>  ------------[ cut here ]------------
>> kernel BUG at kernel/sched.c:2833!
>> invalid operand: 0000 [#55]
>> PREEMPT
>> Modules linked in:
>
> Did you install any extra module from pom-ng?
>
>> CPU:    0
>> EIP:    0060:[<c01166a5>]    Not tainted VLI
>> EFLAGS: 00010206   (2.6.14.2)
>> EIP is at sub_preempt_count+0x35/0x40
>>
>> Need about 3 seconds to trigger this bug with:
>>
>> # while true; do conntrack -L|wc -l; done
>
> I can't reproduce that problem that you're reporting.
Ah. One idea: maybe to reproduce this problem you need many active=20
conntracks with differenet protocols (tcp/udp/icmp/esp...)? This router=20
handles 5K-10K connections, SNAT, DNAT, IPSec, etc...

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1341955812-1132659628=:16598--
