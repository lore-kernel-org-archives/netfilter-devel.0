From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: Routing decision?
Date: Tue, 16 Sep 2003 00:32:33 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0309160030520.21174-100000@filer.marasystems.com>
References: <7C9884991ADAE0479C14F10C858BCDF5122E38@alderaan.smgtec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Wim Ceulemans <wim.ceulemans@able.be>,
   <netfilter-devel@lists.netfilter.org>, <pieter@able.be>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Daniel Chemko <dchemko@smgtec.com>
In-Reply-To: <7C9884991ADAE0479C14F10C858BCDF5122E38@alderaan.smgtec.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 15 Sep 2003, Daniel Chemko wrote:

> I am using this with squid in userspace, and I am unaware of any way to
> get squid to bind its outbound interface.

See tcp_outgoing_address in squid.conf. Gives you powers way beyond what 
can be done in iptables/policy routing for selecting which source address 
to use (assuming the current STABLE release of Squid is used)

policy using based on source address is then trivial and does not even 
need marks.

Regards
Henrik
