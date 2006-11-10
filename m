From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [CTNETLINK] Rework conntrack fields dumping logic on events
Date: Fri, 10 Nov 2006 22:09:53 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0611102151300.26087@blackhole.kfki.hu>
References: <4553D3D5.40408@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <4553D3D5.40408@netfilter.org>
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

On Fri, 10 Nov 2006, Pablo Neira Ayuso wrote:

> This patch also replace IPCT_HELPINFO by IPCT_HELPER since we want to
> track the helper assignation process, not the changes in the private
> information held by the helper.

Actually, how it is solved to pass the setting of dynamically assigned 
(i.e. currently not registered) helpers? What about registering such 
helpers with non-matching address/proto/port parameters?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
