From: Diego Woitasen <diegows@linux.org.ar>
Subject: Conntrack and high avaibility
Date: Tue, 16 Sep 2003 12:26:11 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1063725970.2697.11.camel@sasa>
Reply-To: diegows@linux.org.ar
Mime-Version: 1.0
Content-Type: text/plain
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

I need a firewall with HA, transparent to the user, but i have the
problem of conntrack. When the stand-by firewall become active the
conntrack is started from zero (all connection must be establish again).
Exists a project to transfer conntrack information between firewalls?
If not? This is feasible to do it? If this is feasible i want to start
working on it.

Thanks! 

-- 
Diego Woitasen
