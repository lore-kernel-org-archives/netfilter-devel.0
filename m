From: Jaime Nebrera <jnebrera@eneotecnologia.com>
Subject: VLAN match within iptables
Date: Tue, 26 Jun 2007 11:22:25 +0200
Message-ID: <1182849745.22167.13.camel@blas>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org, Amin Azez <azez@ufomechanic.net>
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

  Hi all,

  We are seeking for a way to match rules based on VLAN Tag ID.

  Searching the archives I have found this post:

http://lists.netfilter.org/pipermail/netfilter-devel/2006-August/025336.html

  But the patch is missing and the answer was to use ebtables.

  Of course ebtables already has this and this is kinda redundant, but
at the same time things get a bit complex when you have to worry about
so many marks due to vlan id, ips stuff etc etc

  Is there any way to access the patch Amin sent to the list?

  Regards

-- 
Jaime Nebrera - jnebrera@eneotecnologia.com
Consultor TI - ENEO Tecnologia SL
Pol. PISA - C/ Manufactura 6, P1, 3B
Mairena del Aljarafe - 41927 - Sevilla
Telf.- 955 60 11 60 / 619 04 55 18
