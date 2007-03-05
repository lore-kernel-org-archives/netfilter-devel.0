From: octane indice <octane@alinto.com>
Subject: -m owner for incoming packets
Date: Tue, 06 Mar 2007 00:09:02 +0100
Message-ID: <1173136142.45eca30ed0cdc@webmail.alinto.com>
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

the man says that -m owner is here for locally generated packet.
Is it possible to use it for incoming packet?

As of:
iptables -A INPUT -p tcp -m owner --cmd-owner /usr/local/sbin/myprog -j ACCEPT

Thanks

Tout doux les dépenses santé. Votre Assurance Santé à partir de 18€ par mois : http://www.alinto.com/pub/
