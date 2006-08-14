From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: connlimit
Date: Mon, 14 Aug 2006 20:18:06 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0608142012190.22415@bizon.gios.gov.pl>
References: <002d01c6bf2e$351f1c70$650ba8c0@DORKA> <44E0726D.7040504@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-2111746006-1155579486=:22415"
Cc: netfilter-devel@lists.netfilter.org, php0t <php0t@zorro.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <44E0726D.7040504@trash.net>
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

---187430788-2111746006-1155579486=:22415
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 14 Aug 2006, Patrick McHardy wrote:

> php0t wrote:
>>   Dear developers,
>>
>> I've had a nice time trying to limit connections. The kernel is
>> 2.6.17.8.
>> Apart from the first couple of annoyances (such as the patch being
>> renamed from iplimit to connlimit, patch-o-matic not being able to apply
>> it to the current kernel etc), I've managed to patch manually, compile
>> it as a module and load it.
>>
>>   However, when I try to add an according test rule, I get the 'Invalid
>> argument' error, and dmesg says:
>> ip_tables: connlimit match: invalid size 0 !=3D 16
>>
>> I also tried going to the site mentioned in the latest pom-ng's
>> source.list:
>>
>> # ipp2p, time, IPMARK and connlimit maintained by Krzysztof Oledzki
>> <ole@ans.pl>
>> http://people.netfilter.org/ole/pom/
>>
>> But all I get is a smiley :)
>
> Just do what it says: "Please use "./runme --download" from a recent
> pom-ng." :)
>
> That will download the patches for you.

This is the new message which I placed few hours ago, after the first=20
mail. Now everyone should know what to do. :)

Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-2111746006-1155579486=:22415--
