From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] ipset type "expire"
Date: Thu, 19 May 2005 16:06:17 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0505191553010.12421@blackhole.kfki.hu>
References: <20050519132414.GH6159@clifford.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Clifford Wolf <clifford@clifford.at>
In-Reply-To: <20050519132414.GH6159@clifford.at>
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

Hi Clifford,

On Thu, 19 May 2005, Clifford Wolf wrote:

> I've already mailed with Jozsef Kadlecsik about this patch in March. It
> seamed to me as he liked it, but it did not show up in the netfilter
> subversion repository so far..
>
> 	http://www.clifford.at/priv/ipset_expire_v2.patch
>
> This patch adds an "expire" ipset type. The entries in such IP sets expire
> automatically after the specified timeout. This is useful e.g. for
> portknocking setups or blacklisting IPs for some time without any userland
> daemons running.
>
> Please apply the patch in the subversion repository or comment on it if you
> think it should not be included..

After rewieving your patch I rejected to add it to ipset due to the linear
storage of the addresses/timeouts. But therefore I wrote 'iptree' type,
which implements the same functionality avoiding linear storarge and was
released at 11 Apr 2005 in ipset 2.2.0:

| A new set type called 'iptree' (inspired and triggered by Clifford
| Wolf) added, which makes possible to store IP addresses which
| automatically time out. Please note, this is an initial new feature with
| some hardcoded parameter (like the frequency of garbage collection) and
| thus may change in the future.

Sorry for not letting you directly about the decision.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
