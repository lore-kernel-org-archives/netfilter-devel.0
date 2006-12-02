From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: ipt_time module doesn't work
Date: Sat, 2 Dec 2006 14:21:08 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0612021418400.7891@bizon.gios.gov.pl>
References: <45717b6d.2e1.4709.4420592@webmailh2.aruba.it>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1103502776-1165065668=:7891"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Fulvio Ricciardi <fulvio.ricciardi@zeroshell.net>
In-Reply-To: <45717b6d.2e1.4709.4420592@webmailh2.aruba.it>
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

---187430788-1103502776-1165065668=:7891
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 2 Dec 2006, Fulvio Ricciardi wrote:

>
>> On Sat, 2 Dec 2006, Fulvio Ricciardi wrote:
>
>>> I noticed ipt_time doesn't work with the kernels
>>> 2.6.18.2 and 2.6.19.
>>> The error messages is the following:
>>>
>>> iptables -A INPUT -mtime
>>> iptables: Unknown error 4294967295
>>>
>>> Is it possible to solve the problem? will time extention
>>> be broken for ever?
>>>
>>> Thanks you in advance for  your replies.
>>> Best Regards
>>
>> Strange, it _should_ work, and it works for me:
>>
>> root@fw1:~#  iptables -A INPUT -mtime
>> root@fw1:~# iptables -L INPUT
>> Chain INPUT (policy ACCEPT)
>> target     prot opt source               destination
>>             0    --  anywhere             anywhere
>>    TIME on all  days
>> root@fw1:~# uname -r
>> 2.6.18.1
>>
>> Where did you get ipt_time from?
> patch-o-matic-ng-20061129.tar.bz2  no longer contain
> ipt_time patch.
Common mistake. Please use "./runme --download" and make sure
you have curl installed.

> The latest one that contain it is patch-o-matic-ng-20060706.tar.bz2.
This version of ipt_time is old and not ready for recent kernels.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1103502776-1165065668=:7891--
