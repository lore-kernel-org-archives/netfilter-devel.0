From: Maik Hentsche <netfilter@mm-double.de>
Subject: Re: bugreport ipt_CLUSTERIP
Date: Wed, 2 Aug 2006 20:12:12 +0200
Message-ID: <20060802201212.3089b23b@zeus.subnet.mm-double.de>
References: <20060725082618.8zdzyrc36s0ksgsk@mail.tu-chemnitz.de>
	<44C8CB58.60709@trash.net>
	<1154078751.44c9d81ff2c50@www.domainfactory-webmail.de>
	<44CABEBC.9050101@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44CABEBC.9050101@trash.net>
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

Patrick McHardy <kaber@trash.net> wrote:

> I tried to reproduce this (by first adding your rule, then deleting
> it, adding it again, rebooting), but got no crash.

It did not happen again for me either, even though, I tried a lot to
reproduce it.

> Did you added/deleted/flushed/... any CLUSTERIP rules before the crashes?

I added the rule, then tried to ping the virtual IP, which did not
work (no arp response). Then I deleted the rule and did nothing else
with CLUSTERIP. The machine was used by another developer a week ago
and I do not know, if he did anything with iptables, but he hardly used
CLUSTERIP. I'm very sorry to not be able to help more.

so long
Maik

-- 
Der Verstand ist wie eine Fahrkarte. Sie hat nur Sinn wenn man sie
benutzt. (Ernst R. Hauschka (*1926), deutscher Essayist,
Aphoristiker und Bibliothekar)
