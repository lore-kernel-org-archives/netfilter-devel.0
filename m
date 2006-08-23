From: "Fischer, Anna" <anna.fischer@hp.com>
Subject: libiptc and PHYSDEV?? -> Invalid argument error!
Date: Wed, 23 Aug 2006 16:38:45 +0100
Message-ID: <86FE9B2B91ADD04095335314BE6906E854D837@sdcexc04.emea.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
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

Hi,

I'm using libiptc to access iptables features from my application.
Everything works fine so far; I can create and delete rules from my
chains, and use the UDP+TCP extensions to set up port filtering etc. So
now I want to use the PHYSDEV extension and I'm working with the
ipt_physev_info structure for that, as I have used the ipt_tcp /ipt_udp
structures when filtering TCP/UDP traffic. It works to append a rule
with ipt_append_entry, but when I issue a commit statement with a
PHYSDEV extension rule then I get the error "Invalid argument". I can
set up PHYSDEV extension rules with the iptables command line interface
and this works fine. I can also read rules with PHYSDEV extension in my
application, but I cannot commit new ones. So what exactly does the
"Invalid argument" error mean? What do I need to do to use the PHYSDEV
extension with libiptc?

I've iptables and x_tables built into the kernel (2.6.15) and use the
iptables v1.3.5 user space tool.

Thanks for your help,
Anna
