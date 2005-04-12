From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: ipt_time fixes (resend, sorry)
Date: Tue, 12 Apr 2005 20:45:49 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0504122030330.19724@bizon.gios.gov.pl>
References: <Pine.LNX.4.61.0501141503220.9908@bizon.gios.gov.pl>
	<20050114143722.GA10088@ti64.telemetry-investments.com>
	<Pine.LNX.4.61.0501141542230.3572@bizon.gios.gov.pl>
	<57991.142.169.215.10.1105716756.squirrel@142.169.215.10>
	<Pine.LNX.4.61.0501141622190.4865@bizon.gios.gov.pl>
	<20050201120618.GA6878@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.62.0504051006020.4373@bizon.gios.gov.pl>
	<20050410202632.GO9155@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-739276955-1113331549=:19724"
Cc: netfilter-devel@lists.netfilter.org, Fabrice MARIE <fabrice@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050410202632.GO9155@sunbeam.de.gnumonks.org>
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

---187430788-739276955-1113331549=:19724
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sun, 10 Apr 2005, Harald Welte wrote:

> On Tue, Apr 05, 2005 at 10:18:34AM +0200, Krzysztof Oledzki wrote:
>>
>>
>> On Tue, 1 Feb 2005, Harald Welte wrote:
>>
>>> On Fri, Jan 14, 2005 at 04:24:01PM +0100, Krzysztof Oledzki wrote:
>>>> OK, How about...
>>> Could you please coordinate with Fabrice Marie (the author of the
>>> module?) and send me (personally) the final patch?
>>
>> Hello,
>>
>> I think it is good time to commit my ipt_time-fix-timestamp2.patch. I be=
lieve
>> it was ACKed by the author of ipt_time module:
>
> yes.  Unfortunately the patch didn't apply:
Hm... strange...

> patching file time/linux/net/ipv4/netfilter/ipt_time.c
> Hunk #1 FAILED at 48.
olenf@bizon:~/patch-o-matic-ng-20050411$ cat ../40-ipt_time-fix-timestamp2.=
patch|patch -p1
patching file time/linux-2.6/include/linux/netfilter_ipv4/ipt_time.h
patching file time/linux-2.6/net/ipv4/netfilter/ipt_time.c
Hunk #1 succeeded at 54 (offset -2 lines).

> can you please provide a current verison of the patc and send it as
> mime-attachment?
I sent it both as MIME-attachment (for easy patching) and inlinde (for=20
easy reviewing). The first one should apply cleanly...

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-739276955-1113331549=:19724--
