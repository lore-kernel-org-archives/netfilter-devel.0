From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: ip_conntrack table full problem
Date: Mon, 14 Mar 2005 16:47:42 +0100
Message-ID: <200503141647.42299.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
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

Hi,

I'm facing a problem with conntrack on a 2.4.21 kernel.
One machine which firewalls a webradio reproducable
becomes unresponsive every week with
"ip_conntrack: table full, dropping packet."

Raising the /proc/sys/net/ipv4/ip_conntrack_max limit only delayed the 
problem. I also installed a cronscript, which saves the contents 
of /proc/net/ip_conntrack every minute to a folder.
When the system died there were around 150 connections in conntrack,
far below the maximum limit.

Also interesting is that the system never recovers from the "full table 
error", even though the conntrack table in /proc is almost empty. It feels
like the table is filled with "ghost entries" and there's no room
for new connections.

I googled around and found this:
http://cert.uni-stuttgart.de/archive/suse/security/2005/02/msg00174.html

The problem is at least confirmed by Ludwig Nussel from SuSE:
http://cert.uni-stuttgart.de/archive/suse/security/2005/02/msg00197.html

I want to help tracking the problem down. I can't upgrade to a newer kernel 
version because of various other patches, but as the "stock" SuSE 9.2 kernel 
got the same problem I assume it's a more generic problem.

Would it be wise to dump the complete internal conntrack table to syslog when 
the error occurs? Any patches I could try? Any other ideas?

Thanks in advance,
Thomas Jarosch
