From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipporthash doesn't work ( ipset-2.3.0, iptables-1.3.8-15,
 kernel-2.6.22.3-7-bigsmp, SuSE 10.3 Beta2)
Date: Wed, 5 Sep 2007 12:27:21 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709051209210.17878@blackhole.kfki.hu>
References: <D0B3C45E7FCE4C488BEF410B2EF666A101974490@moe.nextone.local>
	<Pine.LNX.4.64.0709051146050.17878@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
To: Hung Lin <hlin@nextone.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0709051146050.17878@blackhole.kfki.hu>
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

On Wed, 5 Sep 2007, Jozsef Kadlecsik wrote:

>> After I insert the iptables rule, I cannot ssh to that machine but I can 
>> ping it (I tried from different ips: 172.16.1.121, 10.1.5.27, and 
>> 10.1.5.28.).  It's not the correct behavior.  I suppose the commands I ran 
>> should block the package from 10.1.5.28 to the port 7.  But it seems to 
>> block every IP to the port 22.
>
> I'm unable to reproduce it. The set and rules just work as expected.

Ouch! Out of range condition wrongly interpreted as 'yes' instead of 'no'.
The fix is already in the svn repository, the updated patch-o-matic 
shapshot will be out at the ipset site at afternoon.
Thank you for spotting this nasty bug.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
