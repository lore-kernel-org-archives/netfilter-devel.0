From: "php0t" <php0t@zorro.hu>
Subject: Problem with recent plugin
Date: Sat, 7 Jan 2006 09:17:50 +0100
Message-ID: <000801c61362$d9e4a180$0200a8c0@DORKA>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

 
  Dear developers,
 
The other day i was trying to make a new firewall for a server of mine,
using 'recent' for anti-portscanning, flood protection of open ports,
etc. I have written and tested successfully such firewalls for about 4
other linux servers. They all work fine. On this one, however, the
firewall didn't function as expected. For the anti-portscanning feature,
it lets in a lot more attempts before blocking the remote IP, and for
the anti-flood, it either allows any amount of connects inside, or
either blocks it on the second connect.
 
  I know what you think - a lot of things could be the reason for this,
the last one being some bug in the kernel. This is what i thought at
first, too, until i discovered the following fact. Below you can see the
'heart' of the flood protection. If 30 connections are made in 60
seconds, they should go on 'floodban'. What happens: the flood
protection is NEVER triggered. So... I set --hitcount to 20 (from 30)...
What happens: first connect is allowed in, second one goes on floodban
right away. Yes. All i did was change 30 to 20. When i realized this, i
changed 20 to 21... Again, ALL connects are allowed in, even if i flood
it with about 5 connects / second. As soon as I change 21 back to 20,
the old block-for-the-second-time problem occurs again.
 
  I've 'played' around with this for many hours, i could hardly believe
it was anyone's fault other than mine before i experienced the bug
mentioned above. Googling for such problems, I found one post where they
had kind of the same issue. I checked on bugzilla as well, but I'm
unsure if https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=415 is
totally the same thing: why would increasing hitcount from 20 to 21
change behaviour?
 
  Recommendation/input would be appreciated. I'll be glad to help in any
possible way, too (eg. if you need to see some settings for the kernel,
etc).
 
 
  Thanks,
php0t@zorro.hu
 
 
 
#
# floodcheck
#
 
$IPTABLES -A floodcheck -m recent --name conns --rcheck --seconds 60
--hitcount 30 -j floodban
$IPTABLES -A floodcheck -m recent --name conns --set -j ACCEPT

#
# floodban
#
 
$IPTABLES -A floodban -j LOG --log-prefix "FIREWALL_FLOODPROTECT "
$IPTABLES -A floodban -m recent --name floodban --set -j DROP

 
ratesz:/# cat /etc/issue
Debian GNU/Linux 3.1 \n \l
 
ratesz:/# uname -a
Linux ratesz 2.6.12.3 #1 Mon Jul 25 16:23:04 CEST 2005 i686 GNU/Linux
