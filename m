From: Patrick McHardy <kaber@trash.net>
Subject: Re: locking issue in ip_conntrack_alter_reply
Date: Mon, 03 May 2004 14:15:23 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <409637DB.6030600@trash.net>
References: <Pine.LNX.4.33.0405031057120.24224-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira <pablo@eurodev.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0405031057120.24224-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Jozsef Kadlecsik wrote:

>On Fri, 30 Apr 2004, Pablo Neira wrote:
>
>  
>
>>I'll study if that assertion is right before submitting a patch.
>>    
>>
>
>The assertion is right, because we alter unconfirmed packets when setting
>up nat info. And you're also right, write-locking is unnecessary: the
>entry is not in the hash table yet, so nobody else can grab and modify the
>conntrack entry. [And it is overlooked in the per bucket locking patch too.]
>  
>

I've ported your conntrack patches to 2.6, I will include this change
before adding them to CVS.

Regards
Patrick

>Best regards,
>Jozsef
>-
>E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
>PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
>Address : KFKI Research Institute for Particle and Nuclear Physics
>          H-1525 Budapest 114, POB. 49, Hungary
>
>  
>
