From: "Eric Leblond" <eric@inl.fr>
Subject: ct_link and conntrack evolution ?
Date: Thu, 15 Jul 2004 12:12:23 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <58305.193.164.229.102.1089886343.squirrel@193.164.229.102>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
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

The NuFW project (see http://www.nufw.org for details) has recently
evolved by building a "real-time" authenticated connection tracking table
stored in a SQL database. This brings some great features especially in
the Single Sign On domain (application can ask the SQL database about
users as they know about the connection).

As it can for sure not be compared with ct_link implementation, it points
out that it may be useful to be able to add some informations to
conntrack. I think about mark (like connmark does) or other fields as the
userid (although it's really NuFW oriented).

BR,
-- 
Eric Leblond : eric@inl.fr
INL : http://www.inl.fr/
