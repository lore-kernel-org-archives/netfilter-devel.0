From: "Forte Systems - Iosif Peterfi" <iosif.peterfi@fortesys.ro>
Subject: RE: connlimit patch crashes 2.6.11 kernel
Date: Wed, 18 May 2005 11:50:41 +0300
Message-ID: <7675.02390449426$1116406229@news.gmane.org>
References: <59441.212.77.105.138.1116402606.squirrel@poczta.teldom.pl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <tomasz.maj@teldom.pl>
In-Reply-To: <59441.212.77.105.138.1116402606.squirrel@poczta.teldom.pl>
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

The same problem here 2.6.11. But no imq this time. Connlimit from latest
snapshot. No problem at module insertion. Crashes when there are rules using
the connlimit match. 

This is my other modules:

sch_sfq 6016 6 - Live 0xf88bf000
ipt_tos 2432 1 - Live 0xf889d000
ipt_helper 3200 3 - Live 0xf8898000
ipt_connbytes 3072 18 - Live 0xf8896000
ipt_CLASSIFY 2944 209 - Live 0xf88bb000
ipt_length 2560 8 - Live 0xf88bd000
sch_esfq 6784 6 - Live 0xf889a000
sch_htb 17536 2 - Live 0xf88a6000
ipt_REDIRECT 3072 3 - Live 0xf888d000
iptable_mangle 3328 1 - Live 0xf881c000
iptable_nat 23868 2 ipt_REDIRECT, Live 0xf889f000
ipt_REJECT 6656 8 - Live 0xf8880000
ipt_limit 3072 29 - Live 0xf888b000
ipt_state 2560 4 - Live 0xf881e000
ip_conntrack 50280 3 ipt_helper,iptable_nat,ipt_state, Live 0xf88ad000
ipt_LOG 7680 15 - Live 0xf8893000
ipt_ULOG 8196 12 - Live 0xf888f000
iptable_filter 3328 1 - Live 0xf8879000
ip_tables 24960 14
ipt_tos,ipt_helper,ipt_connbytes,ipt_CLASSIFY,ipt_length,ipt_REDIRECT,iptabl
e_mangle,iptable_nat,ipt_REJECT,ipt_limit,ipt_state,ipt_LOG,ipt_ULOG,iptable
_filter, Live 0xf8883000
ipv6 246304 16 - Live 0xf88c3000
e100 34560 0 - Live 0xf886f000

The oops message is the same: Kernel panic - not syncing: Fatal exception in
interrupt.
My dump is a bit different but I dont know how to capture it.



-----Original Message-----
From: netfilter-devel-bounces@lists.netfilter.org
[mailto:netfilter-devel-bounces@lists.netfilter.org] On Behalf Of
tomasz.maj@teldom.pl
Sent: Wednesday, May 18, 2005 10:50 AM
To: Mateusz Pluta
Cc: netfilter-devel@lists.netfilter.org; 'Patrick McHardy'
Subject: RE: connlimit patch crashes 2.6.11 kernel

Hello,

Yes, I've got the same problem as Mariusz, my kernel 2.6.11 crashes when I
use connlimit patch.

Greetings
Tomek


>> Mateusz wrote:
>>> Problem does not occur when I don't apply connlimit patch to
> kernel.
>>>
>>> [<c0318777>] imq_nf_queue+0xc7/0x1a0
>>
>> Does the problem occur without the imq patch?
>>
>> Regards
>> Patrick
>
> Yes, I use imq patch, and in crash time packets problably go
> through
> the imq device, because I use it to traffic shaping.
>
> One other person found my post, and report me the same problem.
>
> Best regards, Mateusz Pluta
>
>





-- 
This message was scanned for spam and viruses by BitDefender.
For more information please visit http://linux.bitdefender.com/




-- 
This message was scanned for spam and viruses by BitDefender.
For more information please visit http://linux.bitdefender.com/
