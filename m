From: octane indice <octane@alinto.com>
Subject: Launch script when packet is received
Date: Tue, 06 Mar 2007 00:03:34 +0100
Message-ID: <1173135814.45eca1c605b17@webmail.alinto.com>
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

Is there any way to do something like this:

iptables -A INPUT <packet> -j ACTION --script /sbin/myscript.sh

And better, with myscript.sh called with arguments like IP src or dest or
protocol or type of packet?
 
thanks

Tout doux les dépenses santé. Votre Assurance Santé à partir de 18€ par mois : http://www.alinto.com/pub/
