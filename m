From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: (no subject)
Date: Wed, 16 Feb 2005 09:14:10 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0502160910450.16487@blackhole.kfki.hu>
References: <20050215210947.32682.qmail@ad.mailbox.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: Varga Endre <drew@mailbox.hu>
In-Reply-To: <20050215210947.32682.qmail@ad.mailbox.hu>
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

On Tue, 15 Feb 2005, Varga Endre wrote:

> To be short, my problem is the following:
> I must track outgoing SYN+ACK packets (confirmation of connection
> request) and incoming ACK packets acknowledging the SYN+ACKs. With this,
> the module would be able to calculate the ratio of half open
> connections.
> It is easy to track outgoing SYN+ACKs, but to decide if an incoming ACK
> is a response to a former SYN+ACK I have to track the state of the TCP
> connection. Of course I dont want to do this, because the TCP conntrack
> module makes this - It would be a nonsense and a source of inconsistency
> to track the state in both modules.

You could rely on event notification from the nfnetlink-ctnetlink-0.13
patch from patch-o-matic-ng. Unfortunately it seems to me
nfnetlink-ctnetlink's a little bit out of sync compared to the recent
kernel trees.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
