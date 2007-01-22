From: "Jorge Bastos" <mysql.jorge@decimal.pt>
Subject: Fw: PPTP Problem with 2.6.20-rc1 >=
Date: Mon, 22 Jan 2007 18:08:58 -0000
Message-ID: <039101c73e50$632344b0$0301a8c0@hercules.decimalint.pt>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-15";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Hi,

Any progress about this?

Jorge


----- Original Message ----- 
From: "Jorge Bastos" <mysql.jorge@decimal.pt>
To: <netfilter-devel@lists.netfilter.org>
Sent: Saturday, January 20, 2007 7:30 PM
Subject: Re: PPTP Problem with 2.6.20-rc1 >=


 
> 
>> Jorge Bastos wrote:
>>> yap, my steps:
>>> 
>>> recompiled the kernel module, made a backup of the old module, copied
>>> the module to the /lib/modules............ to it's place, and restarted
>>> the machine (just to make sure it get really reloaded!!)
>>> 
>>> below in the folow order, original, and module with the patch:
>>> 
>>> cisne:/usr/src# l /nf_conntrack_proto_gre.ko
>>> -rw-r--r-- 1 root root 7470 Jan 20 14:41 /nf_conntrack_proto_gre.ko
>>> cisne:/usr/src# l
>>> /lib/modules/2.6.20-rc5/kernel/net/netfilter/nf_conntrack_proto_gre.ko
>>> -rw-r--r-- 1 root root 7799 Jan 20 14:50
>>> /lib/modules/2.6.20-rc5/kernel/net/netfilter/nf_conntrack_proto_gre.ko
>> 
>> 
>> OK thanks. I'll try to reproduce it myself.
>> 
>>
> 
>
