From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 6/8][CTNETLINK] Rework conntrack fields dumping logic
 on events
Date: Tue, 08 Aug 2006 12:45:00 +0200
Message-ID: <44D86B2C.80006@trash.net>
References: <44C61C17.5040800@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44C61C17.5040800@netfilter.org>
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

Pablo Neira Ayuso wrote:
> +	/*
> +	 * What do we dump on conntrack events? Good question,
> +	 * the following table should clarify 8)
> +	 *
> +	 *                |   NEW   | UPDATE  | DESTROY |
> +	 *      ----------------------------------------|
> +	 * 	tuples    |    Y    |    Y    |    Y    |
> +	 * 	status    |    Y    |    Y    |    N    |
> +	 * 	timeout   |    Y    |    Y    |    N    |
> +	 *      protoinfo |    Y    |    Y    |    N    |
> +	 *      helper    |    S    |    S    |    N    |
> +	 * 	counters  |    N    |    N    |    Y    |
> +	 * 	mark      |    S    |    S    |    N    |
> +	 *
> +	 * Leyend:
> +	 *         Y: yes
> +	 *         N: no
> +	 *         S: iif the field is set
> +	 */
> +

I think this is a bit excessive, the code pretty much speaks for itself.
