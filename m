From: octane indice <octane@alinto.com>
Subject: good practice for compiling kernel + pom + iptables
Date: Mon, 05 Mar 2007 23:57:24 +0100
Message-ID: <1173135444.45eca054dbd23@webmail.alinto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hello

Is there a "good practice" for recompiling kernel + pom + iptables in order
to have the maximum of choices available.

Is there a right order?

kernel, then iptables, then pom then kernel again and iptables again?

About pom.
I just downloaded the patch-o-matic-ng-20070219.
the usual:
KERNEL_DIR=<> IPTABLES_DIRE=<> ./runme base gives me just
4 choice of patch.
Is it Ok?

I'm currently writing some documentation and doesn't want to be wrong.

thanks

Tout doux les dépenses santé. Votre Assurance Santé à partir de 18€ par mois : http://www.alinto.com/pub/
