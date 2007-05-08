From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/5]: kill unused stuff and fixes re-assigning helper
Date: Tue, 08 May 2007 10:32:51 +0200
Message-ID: <464035B3.70406@trash.net>
References: <200705070259.l472xcgO014664@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200705070259.l472xcgO014664@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> They remove unused l3proto->destroy() and duplicated declarations,
> clear private area in 'struct nf_conn' for helper before reusing the area,
> and considers about unchanged helper when re-assigning helper.
> 
> Patrick, please consider to apply them.


All patches applied, thanks Yasuyuki.
