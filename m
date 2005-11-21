From: Robert Iakobashvili <coroberti@gmail.com>
Subject: Netlink send from the interrupt context
Date: Mon, 21 Nov 2005 10:34:16 +0200
Message-ID: <7e63f56c0511210034h49917721k74ddb251b9bb1815@mail.gmail.com>
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

A bit offline question.

Are there netlink socket netlink_unicast () and netlink_broadcast ()
interrupt safe?

If not, where is the problem and the direction to make them safe?

If it is not easy, what could be a workaroud?

Thank you in advance.


Sincerely,
----------------------------------------------------------------
Robert Iakobashvili  - NAVIGARE NECESSE EST
coroberti at gmail dot com
---------------------------------------------------------------
