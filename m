From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] fine grain locking for tcp helper
Date: Mon, 3 May 2004 10:55:28 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405031034400.24224-100000@blackhole.kfki.hu>
References: <40946DB9.6050705@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40946DB9.6050705@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

On Sun, 2 May 2004, Pablo Neira wrote:

> This patch provides a fine-grain locking for the tcp helper in
> conntrack. A per-conntrack lock is used, instead of having a global lock
> to protect tcp specific data. If I'm missing something, please let me know.

I'm not conviced that much could be gained with per TCP locking assuming
normal traffic, predominated by TCP. I'm fairly sure that per bucket
locking is the way we should go.

Could you check and revive the patches

conntrack_arefcount	- revised reference counting
conntrack_locking	- per bucket locking
[conntrack_nonat	- optimization for the conntrack-only case]

The patches could be pushed forward if there were independent
success reports for general cases, not just performance test reports.

Thank you your work indeed!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
