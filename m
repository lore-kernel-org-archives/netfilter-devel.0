From: "Allain Yoann" <Yoann.Allain@thomson.net>
Subject: IPSec decrypted transport packets don't go through hooks
Date: Wed, 27 Apr 2005 17:47:27 +0200
Message-ID: <9C1918067C3BC14C9C351C206D8A8437377857@rennsmail03.eu.thmulti.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
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

Hi,=20

=20

I'm new to this list.

I'm actually studying the IPSec / Netfilter interaction in the 2.6.11
kernel and there's something I don't catch:

=20

The IPSec processing is done after the hooks PRE-ROUTING and INPUT.

In Tunnel mode, packets are re-injected in the stack via the netif_rx
function (this is needed for this mode).

But in Transport mode, the packets are not re-injected. Why?

=20

This could be useful, if we want to filter decrypted packets that
arrived in transport mode.

Is there a way to do this filtering?

=20

Thanks in advance for your advices/explanations...

=20

Yoann

=20
