From: Brad Fisher <brad@info-link.net>
Subject: [PATCH] pom-ng version of IMQ target
Date: Wed, 12 May 2004 16:57:25 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40A29DC5.1B440519@info-link.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: linuximq@yahoogroups.com
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Attached is a pom-ng version of the IMQ target available from
linuximq.org.  It's based off the 2.4.26 patch, and includes all of the
kernel (linux-2.4.26-imq.diff) and userspace patches (IMQ.pom-ng.patch).

Seems to apply and compile ok for me to the 2.4.26 kernel and iptables
cvs.  You must apply the patch I sent earlier today for pom-ng cvs
before this will work properly, or you will probably end up with a
half-patched kernel or userspace. (see:
http://marc.theaimsgroup.com/?l=netfilter-devel&m=108438884109560&w=2)

Hopefully someone else will find this patch useful.  You are free to use
it as you wish.

-Brad Fisher
