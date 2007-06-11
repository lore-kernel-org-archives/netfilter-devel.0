From: aton <aton@packetdropped.org>
Subject: libnfnetlink.h include generates problems...
Date: Mon, 11 Jun 2007 23:39:22 +0200
Message-ID: <466DC10A.50805@packetdropped.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

in one of my programs, i include the following two files:

#include <linux/netfilter.h>
#include <libnetfilter_queue/libnetfilter_queue.h>

while a few of my header files include each other i get errors from
these nfqueue header:

In file included from /usr/include/sys/uio.h:24,
                 from /usr/include/sys/socket.h:27,
                 from /usr/local/include/libnfnetlink/libnfnetlink.h:19,
                 from
/usr/local/include/libnetfilter_queue/libnetfilter_queue.h:16,
                 from misc.h:14,
                 from packeter.c:9:
/usr/include/sys/types.h:62: error: conflicting types for 'dev_t'
/usr/include/linux/types.h:27: error: previous declaration of 'dev_t'
was here
/usr/include/sys/types.h:72: error: conflicting types for 'mode_t'
/usr/include/linux/types.h:33: error: previous declaration of 'mode_t'
was here
/usr/include/sys/types.h:77: error: conflicting types for 'nlink_t'
/usr/include/linux/types.h:36: error: previous declaration of 'nlink_t'
was here
etc. etc.

i talked to some guys from ##c on freenode, and they said, probably
libnfnetlink.h should not directly include linux/types.h

sorry if this is my mistake, i am not very good at this stuff

greetings, aton
