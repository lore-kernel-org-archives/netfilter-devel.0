From: "Jorge Bastos" <mysql.jorge@decimal.pt>
Subject: Re: PPTP Problem with 2.6.20-rc1 >=
Date: Sat, 20 Jan 2007 15:48:17 -0000
Message-ID: <09a701c73caa$67116a90$0301a8c0@hercules.decimalint.pt>
References: <087801c73c89$cb5e00b0$0301a8c0@hercules.decimalint.pt><45B208B0.8050707@trash.net><08ac01c73c9d$fa6ce100$0301a8c0@hercules.decimalint.pt><091101c73ca3$01df0f80$0301a8c0@hercules.decimalint.pt>
	<45B23921.9020700@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="ISO-8859-15";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Patrick McHardy" <kaber@trash.net>, <netfilter-devel@lists.netfilter.org>
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

yap, my steps:

recompiled the kernel module, made a backup of the old module, copied the 
module to the /lib/modules............ to it's place, and restarted the 
machine (just to make sure it get really reloaded!!)

below in the folow order, original, and module with the patch:

cisne:/usr/src# l /nf_conntrack_proto_gre.ko
-rw-r--r-- 1 root root 7470 Jan 20 14:41 /nf_conntrack_proto_gre.ko
cisne:/usr/src# l 
/lib/modules/2.6.20-rc5/kernel/net/netfilter/nf_conntrack_proto_gre.ko
-rw-r--r-- 1 root root 7799 Jan 20 14:50 
/lib/modules/2.6.20-rc5/kernel/net/netfilter/nf_conntrack_proto_gre.ko



----- Original Message ----- 
From: "Patrick McHardy" <kaber@trash.net>
To: "Jorge Bastos" <mysql.jorge@decimal.pt>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Saturday, January 20, 2007 3:45 PM
Subject: Re: PPTP Problem with 2.6.20-rc1 >=


> Jorge Bastos wrote:
>> Ok, i've applied the patch, and recompiled the kernel module but, still
>> nothing:
>
> Thanks. I trust you properly installed the modules and reloaded the PPTP
> helper and GRE conntrack modules?
> 
