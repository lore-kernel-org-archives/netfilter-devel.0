From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: xt_TARPIT (was: ipt_account / iptables 1.3.8)
Date: Wed, 18 Jul 2007 17:02:45 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707181659260.19782@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0707081655470.24717@fbirervta.pbzchgretzou.qr>
	<20070710190717.ccq5x5v4s5pqvxto@m.safari.iki.fi>
	<Pine.LNX.4.64.0707181309510.27468@fbirervta.pbzchgretzou.qr>
	<469E0FD5.9060309@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Sami Farin <safari-netfilter@safari.iki.fi>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <469E0FD5.9060309@trash.net>
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

On Wed, 18 Jul 2007, Patrick McHardy wrote:

>> +	/* This packet will not be the same as the other: clear nf fields */
>> +	nf_conntrack_put(nskb->nfct);
>> +	nskb->nfct = NULL;

If the target is called from the raw table, please attach the fake untrack 
entry to the created packet so that we could use TARPIT and conntrack 
nicely.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
