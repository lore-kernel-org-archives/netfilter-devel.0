From: "Jing Min Zhao" <zhaojingmin@hotmail.com>
Subject: Re: New H.323 conntrack & NAT helper module
Date: Wed, 22 Mar 2006 11:18:18 -0500
Message-ID: <BAY109-DAV7A64D4AFA179BE4910A01B3D90@phx.gbl>
References: <925A849792280C4E80C5461017A4B8A2032119@mail733.InfraSupportEtc.com><BAY109-DAV1E3EEAC01132FB3EE2E2EB3F00@phx.gbl><44001CDD.3030305@trash.net><BAY109-DAV1A4C43C331B9AEBC1F22EB3F00@phx.gbl><4400A541.9080901@trash.net><BAY109-DAV96ADAFAB4170550F4A52FB3F40@phx.gbl><440960E4.80601@trash.net><BAY109-DAV1330DD37E6D3BA0FF46E0DB3E00@phx.gbl><44158920.30700@trash.net><BAY109-DAV757C3488B317953CCA29AB3E70@phx.gbl><4419281D.6050702@trash.net><BAY109-DAV69864489FACDF598B1718B3E50@phx.gbl><441EBAC1.8060007@trash.net><BAY109-DAV19348A8A477692078B76DB3DB0@phx.gbl>
	<441EFED7.9010002@trash.net>
	<BAY109-DAV130DE7B7B14F08F39A37E1B3D90@phx.gbl>
	<442175A8.7040103@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Patrick McHardy" <kaber@trash.net>
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


----- Original Message ----- 
From: "Patrick McHardy" <kaber@trash.net>
To: "Jing Min Zhao" <zhaojingmin@hotmail.com>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Wednesday, March 22, 2006 11:04 AM
Subject: Re: New H.323 conntrack & NAT helper module


> Jing Min Zhao wrote:
>> Andrew Morton found some compilation errors at the linkage stage:
>> 
>> LD .tmp_vmlinux1 net/built-in.o(.text+0x7762d): In function
>> `set_sig_addr': : undefined reference to `get_h225_addr'
>> net/built-in.o(.text+0x776c9): In function `set_sig_addr': : undefined
>> reference to `get_h225_addr' net/built-in.o(.text+0x77742): In function
>> `set_ras_addr': : undefined reference to `get_h225_addr'
>> net/built-in.o(.text+0x77d82): In function `nat_q931': : undefined
>> reference to `get_h225_addr' make: *** [.tmp_vmlinux1] Error 1
>> 
>> The reason is function 'get_h225_addr` is incorrectly defined as a
>> 'static' function in ip_conntrack_helper_h323.c and `set_sig_addr' is in
>> ip_nat_helper_h323.c. This is interesting because
>> gcc normally doesn't report this obvious error.
>> 
>> I apologize and will release a bugfix version soon.
> 
> Don't worry, I already fixed it in my tree and will push it out
> soon.
>
Thank you very much.

Anybody who want the bugfix version (0.6) for 2.6.15 and 2.6.16 
can download them from 
http://sourceforge.net/project/showfiles.php?group_id=158936

This version includes Patrick's 3 changes on March 20.

Thanks again.

Jing Min Zhao
