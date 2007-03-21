From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: bloom filter in netfilter?
Date: Wed, 21 Mar 2007 16:00:05 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0703211557320.4799@blackhole.kfki.hu>
References: <46000DDF.70509@info.ucl.ac.be> <46003590.9070002@netfilter.org>
	<46012931.5060107@info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Sebastien Tandel <standel@info.ucl.ac.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46012931.5060107@info.ucl.ac.be>
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

On Wed, 21 Mar 2007, Sebastien Tandel wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
>
> one potential bad news ? :)
>
> http://people.netfilter.org/kadlec/hashtrie/
>
> see the shared node case

As I wrote there, the bad results might be my fault. Feel free anyone to 
plug in another bloom filter implementation into the code and test it.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
