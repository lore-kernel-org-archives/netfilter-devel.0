From: Phil Oester <kernel@linuxace.com>
Subject: Re: Reset conntrack...
Date: Fri, 3 Dec 2004 08:07:40 -0800
Message-ID: <20041203160740.GA22497@linuxace.com>
References: <41AF92B1.30802@anduras.de> <20041203060819.GG4605@oknodo.bof.de>
	<41B049C5.403@anduras.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Anders <anders@anduras.de>
Content-Disposition: inline
In-Reply-To: <41B049C5.403@anduras.de>
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

On Fri, Dec 03, 2004 at 12:11:01PM +0100, Sven Anders wrote:
> Possible solutions:
> 
> ~ 1) Recheck all CONNTRACK entries against the new firewall rules.
> 
> ~ 2) Set all CONNTRACK entries with states RELATED or ESTABLISHED to
> ~     NEW, to force the recheck.
> 
> Is there any way to accomplish this?

Make iptables modular, and unload/reload the conntrack module everytime
you change your rules.  Not pretty, but without hacking the code, the
only way to achieve your objective.

Phil
