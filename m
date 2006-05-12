From: Patrick McHardy <kaber@trash.net>
Subject: Re: Update: Patch-o-matic cleanup
Date: Fri, 12 May 2006 12:26:57 +0200
Message-ID: <446462F1.9030403@trash.net>
References: <443165AA.4030509@trash.net> <4433CA75.9040607@trash.net>
	<44642357.3000308@trash.net> <446460C4.5050806@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
In-Reply-To: <446460C4.5050806@gmx.net>
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

Carl-Daniel Hailfinger wrote:
> Hi,
> 
> Patrick McHardy wrote:
> 
>>I've now removed all patches that didn't find a new maintainer or
>>which already have an external repository. I'll keep the ones where
>>people are still setting up the repository for a couple more days,
>>these are:
> 
> 
> would it be possible for you to generate a list of the patches which
> didn't find a new maintainer and have no external repository in sight?

Unfortunately I just deleted my list together with the patches.
But anything is better than cleaning up ipt_recent, so here is
a new one :)

- account
- ACCOUNT
- comment
- connrate
- conntrack_locking
- cuseeme-nat
- dropped-table
- expire
- fuzzy
- goto
- h323-conntrack-nat
- ip_queue_vwmark
- MARK-operations
- mport
- nat-reservations
- netfilter-docbook
- NETLINK
- NETMAP
- nth
- osf
- owner-socketlookup
- pool
- pptp-conntrack-nat
- psd
- quota
- random
- TCPLAG
- tproxy
- TRACE
- unclean
- XOR

Some of these are already in mainline (or something comparable) or will
be soon:

- comment
- goto
- h323
- ip_queue_vwmark
- MARK-operations
- mport
- nth
- random
- quota
- pptp

The tproxy guys will probably set up their own repository, at least
thats what they said at the last workshop.
