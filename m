From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Again, HOPLIMIT inconsistency
Date: Wed, 3 Mar 2004 21:00:01 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <931388940.20040303210001@dns.toxicfilms.tv>
Reply-To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I remember that Harald agreed with me to change the naming scheme
to HL instead of HOPLIMIT.

I remember having sent a patch that renames HOPLIMIT in
patch-o-matic-ng to HL (in helps and in files)

It has not been applied, may I ask why?

This causes inconsistency because helps say:
-j HOPLIMIT --hl-set
and we have
iptables/extensions/libip6t_HL.c
Won't work :-(

So, either we rename libip6t_HL.c to libip6t_HOPLIMIT.c,
or keep it the way it is, but rename HOPLIMIT to HL in patch-o-matic-ng
in help message (and preferably in the kernel files from IP6T_HOPLIMIT_* to
IP6T_HL_* as it was in the beginning)

Regards,
Maciej
