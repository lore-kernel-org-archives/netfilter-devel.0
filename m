From: Peter Lenci <peterlenci@yahoo.ca>
Subject: CLASSIFY target in POSTROUTING only?
Date: Fri, 4 Mar 2005 06:23:06 -0500 (EST)
Message-ID: <20050304112306.29481.qmail@web90007.mail.scd.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
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

Hi all

The CLASSIFY extension can only be used in the POSTROUTING chain of the
mangle table. Is there a technical reason for this or is it just an aid
to prevent misconfiguration? In particular I'd like to use the CLASSIFY
target in the PREROUTING table (in combination with ingress tcp shaping
with the IMQ device).

Regards
Peter

______________________________________________________________________ 
Post your free ad now! http://personals.yahoo.ca
