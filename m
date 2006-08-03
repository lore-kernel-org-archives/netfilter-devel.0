From: Patrick McHardy <kaber@trash.net>
Subject: Re: bugreport ipt_CLUSTERIP
Date: Thu, 03 Aug 2006 11:48:30 +0200
Message-ID: <44D1C66E.1080307@trash.net>
References: <20060725082618.8zdzyrc36s0ksgsk@mail.tu-chemnitz.de>	<44C8CB58.60709@trash.net>	<1154078751.44c9d81ff2c50@www.domainfactory-webmail.de>	<44CABEBC.9050101@trash.net>
	<20060802201212.3089b23b@zeus.subnet.mm-double.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Maik Hentsche <netfilter@mm-double.de>
In-Reply-To: <20060802201212.3089b23b@zeus.subnet.mm-double.de>
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

Maik Hentsche wrote:
> I added the rule, then tried to ping the virtual IP, which did not
> work (no arp response). Then I deleted the rule and did nothing else
> with CLUSTERIP. The machine was used by another developer a week ago
> and I do not know, if he did anything with iptables, but he hardly used
> CLUSTERIP. I'm very sorry to not be able to help more.


Thanks anyway. I'll try some more to reproduce it ..
