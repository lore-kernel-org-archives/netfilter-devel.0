From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Reset conntrack...
Date: Sat, 4 Dec 2004 15:51:50 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412041547340.14126@filer.marasystems.com>
References: <41AF92B1.30802@anduras.de> <20041203060819.GG4605@oknodo.bof.de>
	<41B049C5.403@anduras.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Anders <anders@anduras.de>
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

On Fri, 3 Dec 2004, Sven Anders wrote:

> ~ 1) Recheck all CONNTRACK entries against the new firewall rules.
>
> ~ 2) Set all CONNTRACK entries with states RELATED or ESTABLISHED to
> ~     NEW, to force the recheck.

Setting it to NEW won't help you as this discards the current conntrack 
entry, and if the next packet is return traffic or on an related 
connection your ruleset will get very upset.

> Is there any way to accomplish this?

There is three ways

a) The simple "CONFIRMED" patch posted by a collegue of mine little more 
than a year ago (see archives).

b) Use CONNMARK as a ruleset counter instead of looking for state 
ESTABLISHED,RELATED. Mark accepted traffic with a specific CONNMARK and 
then look for this mark rather than the state.

Note that in both cases special care is needed to make sure you look at 
traffic or addresses in the "original" direction. See the conntrack match. 
Also beware of related connections such as the data channel of FTP 
connection etc.

Regards
Henrik
