From: Andre Luiz da Silva <andrack@gmail.com>
Subject: iptables command and target ULOG problem
Date: Sun, 1 May 2005 11:30:15 -0800
Message-ID: <79a98d9f05050112304848c6ce@mail.gmail.com>
Reply-To: Andre Luiz da Silva <andrack@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hello friends...

I'm using the iptables version 1.2.11 and I have the follow problem with
ULOG iptables target:

For example....

When I insert the rule and the parameter '-j ULOG' are before icmp protocol
options, I received the error "Bad argument":

"
andre:~/iptables-1.2.11 # ./iptables -I INPUT -j ULOG --protocol icmp
--icmp-type echo-reply
Bad argument `echo-reply'
Try `iptables -h' or 'iptables --help' for more information.
"

But with '-j ULOG' later the icmp protocol options (or any other
options), no error occurs.

"
andre:~/iptables-1.2.11 # ./iptables -I INPUT --protocol icmp
--icmp-type echo-reply -j ULOG
"

This problem does not occur with target "LOG".


Any ideias?=20

Thank's
