From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH 2.4] update raw patch in POM take 2
Date: Thu, 27 Oct 2005 16:08:15 +0200
Message-ID: <4360DF4F.9060601@tac.ch>
References: <42C2B94D.4070401@tac.ch>
	<20050828115653.GF4244@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050828115653.GF4244@rama.de.gnumonks.org>
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

> patchwork.netfilter.org led me to this old unapplied patch. I've now
> applied it as patchlets/raw/linux-2.4.31.patch.  Please let me know if
> you need any further changes.

All is fine, it still applies to 2.4.32-rc1 + latest git. I have
additionally added kdb to the source tree now to debug the oops when
unloading the ip_conntrack module. I hope to be working on this again soon.

Thanks,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Kasinostrasse 30, CH-5001 Aarau tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
