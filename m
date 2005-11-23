From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [RFC] [PATCH] nf_conntrack_netlink port take#2
Date: Wed, 23 Nov 2005 02:21:10 +0100
Message-ID: <4383C406.7010400@eurodev.net>
References: <43836FFE.3020504@eurodev.net>
	<20051122220851.GD31478@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051122220851.GD31478@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> On Tue, Nov 22, 2005 at 08:22:38PM +0100, Pablo Neira wrote:
>>
>>Sorry for the bad timing. Here attached the take#2 of the
>>nf_conntrack_netlink port. It includes a layer-3 abstraction as
>>suggested. Attached two patches:
> 
> ok, I didn't have the time for a detailed review (and chances are
> undlikely that I will have anytime soon).  However, if noone opposes, I
> would like to submit this for 2.6.16 quite soon.  But not too soon (dave
> has a open net-2.6.16 tree, but we don't want to flood him with
> incremental fixes, at least not intentionally).  So I'd say Pablo keeps
> the patch update out-of-tree until 2.6.15 is released, and at that time
> we push it to mainline immediately.

Fine with it. I'll keep such patch updated at my people.netfilter.org place.

-- 
Pablo
