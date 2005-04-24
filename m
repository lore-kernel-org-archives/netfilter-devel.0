From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables-batch 2nd try
Date: Sun, 24 Apr 2005 18:21:23 +0200
Message-ID: <426BC783.3030603@trash.net>
References: <20050421122008.GA22032@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ludwig Nussel <ludwig.nussel@suse.de>
In-Reply-To: <20050421122008.GA22032@suse.de>
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

Ludwig Nussel wrote:
> Hi,
> 
> Another attempt, this time the commits for the tables are done at
> the end like with iptables-restore. The purpose of this exercise is
> to speed up an existing shell script (SuSEfirewall2) by writing
> iptables calls into a file and run iptables-batch at the end instead of
> fork/exec all the time. The script doesn't need to be changed much
> for that, one basically just needs to redefine iptables as shell
> function. If iptables-batch is not available the script can
> transparently fall back to individual iptables calls.

Sounds reasonable, but I'm not very familiar with the iptables code,
so I'll wait for others to comment before applying it.

> +	num_tables = 3;
> +	alloc_tables();
> +	tables[0].name = strdup("filter");
> +	tables[0].handle = NULL;
> +	tables[1].name = strdup("mangle");
> +	tables[1].handle = NULL;
> +	tables[2].name = strdup("nat");
> +	tables[2].handle = NULL;
> +	current_table = &tables[0];

The raw table is missing.

Regards
Patrick
